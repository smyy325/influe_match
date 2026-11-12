// Dosya Görevi: Gerçek Zamanlı Mesajlaşma ve Sohbet Odaları BLoC (Business Logic Component).
// Bu sınıf, markalar ve içerik üreticileri arasındaki canlı sohbet odalarını yükler,
// mesaj akışlarını (Stream) dinler, mesaj gönderme ve yeni sohbet başlatma işlemlerini yönetir.

import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../cekirdek/hata/sonuc.dart';
import '../depo/sohbet_deposu.dart';
import '../model/mesaj_modeli.dart';
import '../model/sohbet_odasi_modeli.dart';
import 'sohbet_event.dart';
import 'sohbet_state.dart';

/// SohbetBloc: SohbetEvent olaylarını dinleyen ve duruma göre SohbetState yayınlayan BLoC sınıfı.
class SohbetBloc extends Bloc<SohbetEvent, SohbetState> {
  // Bağımlılık enjeksiyonu ile alınan Sohbet Deposu (Repository) arayüzü.
  final ISohbetDeposu sohbetDeposu;
  
  // Canlı mesajlaşma akış aboneliği.
  StreamSubscription? _mesajAboneligi;

  /// SohbetBloc Kurucu Metodu: Sohbet olaylarını işleyici fonksiyonlara bağlar.
  SohbetBloc({required this.sohbetDeposu}) : super(SohbetBaslangic()) {
    on<SohbetOdalariniYukleEvent>(_onOdalariYukle);
    on<MesajlariDinleEvent>(_onMesajlariDinle);
    on<MesajGonderEvent>(_onMesajGonder);
    on<SohbetBaslatEvent>(_onSohbetBaslat);
  }

  /// _onOdalariYukle(): Kullanıcının açık olan tüm sohbet odalarını getirir ve canlı Firestore dinlemesini başlatır.
  Future<void> _onOdalariYukle(
    SohbetOdalariniYukleEvent event,
    Emitter<SohbetState> emit,
  ) async {
    final aktifSohbetId = state is SohbetOdalariYuklendi ? (state as SohbetOdalariYuklendi).aktifSohbetId : null;
    final aktifMesajlar = state is SohbetOdalariYuklendi ? (state as SohbetOdalariYuklendi).aktifMesajlar : const <MesajModeli>[];
    emit(SohbetYukleniyor());
    
    final sonuc = await sohbetDeposu.sohbetOdalariniGetir(event.kullaniciId);
    if (sonuc case Basari(:final veri)) {
      emit(SohbetOdalariYuklendi(
        odalar: veri,
        aktifSohbetId: aktifSohbetId,
        aktifMesajlar: aktifMesajlar,
      ));
    }

    // Firestore üzerindeki sohbet odalarını canlı olarak dinlemeye devam eder.
    await emit.forEach(
      sohbetDeposu.sohbetOdalariniIzle(event.kullaniciId),
      onData: (odalar) => SohbetOdalariYuklendi(
        odalar: odalar,
        aktifSohbetId: state is SohbetOdalariYuklendi ? (state as SohbetOdalariYuklendi).aktifSohbetId : null,
        aktifMesajlar: state is SohbetOdalariYuklendi ? (state as SohbetOdalariYuklendi).aktifMesajlar : const [],
      ),
    );
  }

  /// _onMesajlariDinle(): Belirli bir sohbet odasının anlık mesaj akışını (Stream) dinler.
  Future<void> _onMesajlariDinle(
    MesajlariDinleEvent event,
    Emitter<SohbetState> emit,
  ) async {
    await _mesajAboneligi?.cancel();
    final mevcutOdalar = state is SohbetOdalariYuklendi ? (state as SohbetOdalariYuklendi).odalar : const <SohbetOdasiModeli>[];
    
    await emit.forEach(
      sohbetDeposu.mesajlariIzle(event.sohbetId),
      onData: (mesajlar) => MesajlarYuklendi(
        sohbetId: event.sohbetId,
        mesajlar: mesajlar,
        odalar: state is SohbetOdalariYuklendi ? (state as SohbetOdalariYuklendi).odalar : mevcutOdalar,
      ),
    );
  }

  /// _onMesajGonder(): Yeni bir mesaj metnini ilgili sohbet odasına kaydeder/gönderir.
  Future<void> _onMesajGonder(
    MesajGonderEvent event,
    Emitter<SohbetState> emit,
  ) async {
    await sohbetDeposu.mesajGonder(event.mesaj);
  }

  /// _onSohbetBaslat(): Bir kampanya başvurusu üzerinden yeni bir sohbet odası oluşturur ya da var olan odayı getirir.
  Future<void> _onSohbetBaslat(
    SohbetBaslatEvent event,
    Emitter<SohbetState> emit,
  ) async {
    final sonuc = await sohbetDeposu.sohbetOlusturVeyaGetir(
      ilanId: event.ilanId,
      ilanBasligi: event.ilanBasligi,
      karsiTarafId: event.karsiTarafId,
      karsiTarafAdi: event.karsiTarafAdi,
      karsiTarafProfil: event.karsiTarafProfil,
      karsiTarafRol: event.karsiTarafRol,
      mevcutKullaniciId: event.mevcutKullaniciId,
    );
    switch (sonuc) {
      case Basari(:final veri):
        add(MesajlariDinleEvent(veri.id));
      case Hata(:final mesaj):
        emit(SohbetHatasi(mesaj));
    }
  }

  /// close(): BLoC nesnesi sonlandığında aktif mesaj aboneliğini temizler.
  @override
  Future<void> close() {
    _mesajAboneligi?.cancel();
    return super.close();
  }
}
