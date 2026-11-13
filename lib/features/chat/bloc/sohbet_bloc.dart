import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/error/sonuc.dart';
import '../models/mesaj_modeli.dart';
import '../models/sohbet_odasi_modeli.dart';
import '../repository/sohbet_deposu.dart';
import 'sohbet_event.dart';
import 'sohbet_state.dart';

class SohbetBloc extends Bloc<SohbetEvent, SohbetState> {
  final ISohbetDeposu sohbetDeposu;
  
  StreamSubscription? _mesajAboneligi;

  SohbetBloc({required this.sohbetDeposu}) : super(SohbetBaslangic()) {
    on<SohbetOdalariniYukleEvent>(_onOdalariYukle);
    on<MesajlariDinleEvent>(_onMesajlariDinle);
    on<MesajGonderEvent>(_onMesajGonder);
    on<SohbetBaslatEvent>(_onSohbetBaslat);
  }

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

    await emit.forEach(
      sohbetDeposu.sohbetOdalariniIzle(event.kullaniciId),
      onData: (odalar) => SohbetOdalariYuklendi(
        odalar: odalar,
        aktifSohbetId: state is SohbetOdalariYuklendi ? (state as SohbetOdalariYuklendi).aktifSohbetId : null,
        aktifMesajlar: state is SohbetOdalariYuklendi ? (state as SohbetOdalariYuklendi).aktifMesajlar : const [],
      ),
    );
  }

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

  Future<void> _onMesajGonder(
    MesajGonderEvent event,
    Emitter<SohbetState> emit,
  ) async {
    await sohbetDeposu.mesajGonder(event.mesaj);
  }

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

  @override
  Future<void> close() {
    _mesajAboneligi?.cancel();
    return super.close();
  }
}
