// Dosya Görevi: Kampanya İlanları ve Başvuru Yönetimi BLoC (Business Logic Component).
// Bu sınıf, ilanların listelenmesi, oluşturulması, güncellenmesi, silinmesi, canlı Firestore dinlemesi
// ve ilan başvuruları/reddetme süreçlerinin iş mantığını (Business Logic) yönetir.

import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../cekirdek/hata/sonuc.dart';
import '../depo/ilan_deposu.dart';
import '../model/basvuru_modeli.dart';
import '../model/ilan_modeli.dart';
import 'ilan_event.dart';
import 'ilan_state.dart';

/// IlanBloc: IlanEvent olaylarını dinleyen ve duruma göre IlanState yayınlayan BLoC sınıfı.
class IlanBloc extends Bloc<IlanEvent, IlanState> {
  // Bağımlılık enjeksiyonu ile alınan İlan Deposu (Repository) arayüzü.
  final IIlanDeposu ilanDeposu;
  
  // Canlı Firestore akış aboneliğini tutan değişken.
  StreamSubscription? _akisAboneligi;
  
  // Ekranda ilanların ve başvuruların anlık sıfırlanmasını önleyen önbellek (cache) listeleri.
  List<IlanModeli> _sonIlanlar = const [];
  List<BasvuruModeli> _sonBasvurular = const [];

  /// IlanBloc Kurucu Metodu: İlan olaylarını (Events) ilgili işleyici (Handler) metodlara bağlar.
  IlanBloc({required this.ilanDeposu}) : super(IlanBaslangic()) {
    on<IlanlariYukleEvent>(_onIlanlariYukle);
    on<IlanAkisiniDinleEvent>(_onAkisiDinle);
    on<IlanOlusturEvent>(_onIlanOlustur);
    on<IlanGuncelleEvent>(_onIlanGuncelle);
    on<IlanSilEvent>(_onIlanSil);
    on<IlanaBasvurEvent>(_onIlanaBasvur);
    on<BasvurulariYukleEvent>(_onBasvurulariYukle);
  }

  /// _onIlanlariYukle(): Kategori, arama kelimesi veya marka kimliğine göre ilanları depodan çeker.
  Future<void> _onIlanlariYukle(
    IlanlariYukleEvent event,
    Emitter<IlanState> emit,
  ) async {
    // Hafızada önceden yüklenmiş ilan yoksa yükleniyor durumunu yayınlar.
    if (_sonIlanlar.isEmpty) emit(IlanYukleniyor());
    
    final sonuc = await ilanDeposu.ilanlariGetir(
      kategori: event.kategori,
      aramaKelimesi: event.aramaKelimesi,
      markaId: event.markaId,
    );
    
    switch (sonuc) {
      case Basari(:final veri):
        _sonIlanlar = veri;
        emit(IlanlarYuklendi(
          ilanlar: _sonIlanlar,
          basvurular: _sonBasvurular,
          seciliKategori: event.kategori ?? 'Tümü',
        ));
      case Hata(:final mesaj):
        emit(IlanHatasi(mesaj));
    }
  }

  /// _onAkisiDinle(): Firestore üzerindeki canlı ilan değişikliklerini (Stream) dinler ve anlık günceller.
  Future<void> _onAkisiDinle(
    IlanAkisiniDinleEvent event,
    Emitter<IlanState> emit,
  ) async {
    await _akisAboneligi?.cancel();
    await emit.forEach(
      ilanDeposu.tumIlanlariIzle(),
      onData: (ilanlar) {
        _sonIlanlar = ilanlar;
        return IlanlarYuklendi(ilanlar: _sonIlanlar, basvurular: _sonBasvurular);
      },
      onError: (error, stackTrace) => state,
    );
  }

  /// _onIlanOlustur(): Marka tarafından yeni bir kampanya ilanı oluşturulduğunda çalışır.
  Future<void> _onIlanOlustur(
    IlanOlusturEvent event,
    Emitter<IlanState> emit,
  ) async {
    emit(IlanYukleniyor());
    final sonuc = await ilanDeposu.ilanOlustur(event.ilan);
    switch (sonuc) {
      case Basari():
        emit(const IlanIslemiBasarili('İlan başarıyla yayınlandı!'));
        add(const IlanlariYukleEvent());
      case Hata(:final mesaj):
        emit(IlanHatasi(mesaj));
    }
  }

  /// _onIlanGuncelle(): Mevcut bir ilanın bilgilerini güncellemek için çalışır.
  Future<void> _onIlanGuncelle(IlanGuncelleEvent event, Emitter<IlanState> emit) async {
    emit(IlanYukleniyor());
    final sonuc = await ilanDeposu.ilanGuncelle(event.ilan);
    switch (sonuc) {
      case Basari():
        emit(const IlanIslemiBasarili('İlan güncellendi.'));
        add(const IlanlariYukleEvent());
      case Hata(:final mesaj):
        emit(IlanHatasi(mesaj));
    }
  }

  /// _onIlanSil(): Bir ilanı yayından kaldırmak/silmek için çalışır.
  Future<void> _onIlanSil(IlanSilEvent event, Emitter<IlanState> emit) async {
    final sonuc = await ilanDeposu.ilaniSil(event.ilanId);
    switch (sonuc) {
      case Basari():
        emit(const IlanIslemiBasarili('İlan kaldırıldı.'));
        add(const IlanlariYukleEvent());
      case Hata(:final mesaj):
        emit(IlanHatasi(mesaj));
    }
  }

  /// _onIlanaBasvur(): Influencer ilana başvurduğunda ya da özel teklifi reddettiğinde çalışır.
  Future<void> _onIlanaBasvur(
    IlanaBasvurEvent event,
    Emitter<IlanState> emit,
  ) async {
    final sonuc = await ilanDeposu.ilanaBasvur(event.basvuru);
    switch (sonuc) {
      case Basari():
        final mesaj = event.basvuru.durum == BasvuruDurumu.reddedildi
            ? 'Özel teklif reddedildi.'
            : 'Başvurunuz başarıyla iletildi! Marka inceleyip sizinle iletişime geçecektir.';
        emit(IlanIslemiBasarili(mesaj));
        add(const IlanlariYukleEvent());
        add(BasvurulariYukleEvent(influencerId: event.basvuru.influencerId));
      case Hata(:final mesaj):
        emit(IlanHatasi(mesaj));
    }
  }

  /// _onBasvurulariYukle(): Kullanıcı rolüne göre yapılan başvuruları veya gelen teklifleri getirir.
  Future<void> _onBasvurulariYukle(
    BasvurulariYukleEvent event,
    Emitter<IlanState> emit,
  ) async {
    final seciliKat = state is IlanlarYuklendi ? (state as IlanlarYuklendi).seciliKategori : 'Tümü';
    if (_sonBasvurular.isEmpty && _sonIlanlar.isEmpty) emit(IlanYukleniyor());
    final sonuc = await ilanDeposu.basvurulariGetir(
      influencerId: event.influencerId,
      markaId: event.markaId,
    );
    switch (sonuc) {
      case Basari(:final veri):
        _sonBasvurular = veri;
        emit(BasvurularYuklendi(
          _sonBasvurular,
          ilanlar: _sonIlanlar,
          seciliKategori: seciliKat,
        ));
      case Hata(:final mesaj):
        emit(IlanHatasi(mesaj));
    }
  }

  /// close(): BLoC nesnesi kapandığında akış aboneliğini (StreamSubscription) sonlandırır.
  @override
  Future<void> close() {
    _akisAboneligi?.cancel();
    return super.close();
  }
}
