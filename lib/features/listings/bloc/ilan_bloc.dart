import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/error/sonuc.dart';
import '../models/basvuru_modeli.dart';
import '../models/ilan_modeli.dart';
import '../repository/ilan_deposu.dart';
import 'ilan_event.dart';
import 'ilan_state.dart';

class IlanBloc extends Bloc<IlanEvent, IlanState> {
  final IIlanDeposu ilanDeposu;
  
  StreamSubscription? _akisAboneligi;
  
  List<IlanModeli> _sonIlanlar = const [];
  List<BasvuruModeli> _sonBasvurular = const [];

  IlanBloc({required this.ilanDeposu}) : super(IlanBaslangic()) {
    on<IlanlariYukleEvent>(_onIlanlariYukle);
    on<IlanAkisiniDinleEvent>(_onAkisiDinle);
    on<IlanOlusturEvent>(_onIlanOlustur);
    on<IlanGuncelleEvent>(_onIlanGuncelle);
    on<IlanSilEvent>(_onIlanSil);
    on<IlanaBasvurEvent>(_onIlanaBasvur);
    on<BasvurulariYukleEvent>(_onBasvurulariYukle);
  }

  Future<void> _onIlanlariYukle(
    IlanlariYukleEvent event,
    Emitter<IlanState> emit,
  ) async {
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

  @override
  Future<void> close() {
    _akisAboneligi?.cancel();
    return super.close();
  }
}
