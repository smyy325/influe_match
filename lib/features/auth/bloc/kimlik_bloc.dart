import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/error/sonuc.dart';
import '../repository/kimlik_deposu.dart';
import 'kimlik_event.dart';
import 'kimlik_state.dart';

class KimlikBloc extends Bloc<KimlikEvent, KimlikState> {
  final IKimlikDeposu kimlikDeposu;

  KimlikBloc({required this.kimlikDeposu}) : super(KimlikBaslangic()) {
    on<KimlikDurumunuKontrolEtEvent>(_onDurumKontrol);
    on<GirisYapEvent>(_onGirisYap);
    on<KayitOlEvent>(_onKayitOl);
    on<CikisYapEvent>(_onCikisYap);
    on<RolDegistirEvent>(_onRolDegistir);
    on<ProfilGuncelleEvent>(_onProfilGuncelle);
    on<HesabiSilEvent>(_onHesabiSil);
    on<SifreSifirlamaTalebiEvent>(_onSifreSifirlamaTalebi);
  }

  Future<void> _onDurumKontrol(
    KimlikDurumunuKontrolEtEvent event,
    Emitter<KimlikState> emit,
  ) async {
    emit(KimlikYukleniyor());
    await kimlikDeposu.cikisYap();
    emit(KimlikDogrulanmadi());
  }

  Future<void> _onGirisYap(
    GirisYapEvent event,
    Emitter<KimlikState> emit,
  ) async {
    emit(KimlikYukleniyor());
    final sonuc = await kimlikDeposu.girisYap(event.email, event.sifre);
    switch (sonuc) {
      case Basari(:final veri):
        emit(KimlikDogrulandi(veri));
      case Hata(:final mesaj):
        emit(KimlikHatasi(mesaj));
    }
  }

  Future<void> _onKayitOl(
    KayitOlEvent event,
    Emitter<KimlikState> emit,
  ) async {
    emit(KimlikYukleniyor());
    final sonuc = await kimlikDeposu.kayitOl(
      adSoyad: event.adSoyad,
      email: event.email,
      sifre: event.sifre,
      rol: event.rol,
    );
    switch (sonuc) {
      case Basari(:final veri):
        emit(KimlikDogrulandi(veri));
      case Hata(:final mesaj):
        emit(KimlikHatasi(mesaj));
    }
  }

  Future<void> _onCikisYap(
    CikisYapEvent event,
    Emitter<KimlikState> emit,
  ) async {
    emit(KimlikYukleniyor());
    await kimlikDeposu.cikisYap();
    emit(KimlikDogrulanmadi());
  }

  Future<void> _onRolDegistir(
    RolDegistirEvent event,
    Emitter<KimlikState> emit,
  ) async {
    final sonuc = await kimlikDeposu.rolDegistir();
    switch (sonuc) {
      case Basari(:final veri):
        emit(KimlikDogrulandi(veri));
      case Hata(:final mesaj):
        emit(KimlikHatasi(mesaj));
    }
  }

  Future<void> _onHesabiSil(
    HesabiSilEvent event,
    Emitter<KimlikState> emit,
  ) async {
    emit(KimlikYukleniyor());
    await kimlikDeposu.hesabiSil();
    emit(KimlikDogrulanmadi());
  }

  Future<void> _onProfilGuncelle(
    ProfilGuncelleEvent event,
    Emitter<KimlikState> emit,
  ) async {
    final sonuc = await kimlikDeposu.profilGuncelle(event.kullanici);
    switch (sonuc) {
      case Basari(:final veri):
        emit(KimlikDogrulandi(veri));
      case Hata(:final mesaj):
        emit(KimlikHatasi(mesaj));
    }
  }

  Future<void> _onSifreSifirlamaTalebi(
    SifreSifirlamaTalebiEvent event,
    Emitter<KimlikState> emit,
  ) async {
    emit(KimlikYukleniyor());
    final sonuc = await kimlikDeposu.sifreSifirlamaEpostasiGonder(event.email);
    switch (sonuc) {
      case Basari():
        emit(const SifreSifirlamaEpostasiGonderildi('Şifre sıfırlama bağlantısı e-posta adresinize gönderildi.'));
      case Hata(:final mesaj):
        emit(KimlikHatasi(mesaj));
    }
  }
}
