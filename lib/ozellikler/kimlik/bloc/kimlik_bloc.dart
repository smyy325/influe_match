// Dosya Görevi: Kimlik ve Oturum Yönetimi BLoC (Business Logic Component).
// Kullanıcı girişi, kaydolma, çıkış yapma, rol değiştirme, profil güncelleme ve hesap silme
// gibi tüm oturum işlemlerini işler ve durumları (KimlikState) yayınlar.

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../cekirdek/hata/sonuc.dart';
import '../depo/kimlik_deposu.dart';
import 'kimlik_event.dart';
import 'kimlik_state.dart';

/// KimlikBloc: Kimlik doğrulama olaylarını dinleyen ve duruma göre KimlikState üreten BLoC sınıfı.
class KimlikBloc extends Bloc<KimlikEvent, KimlikState> {
  // Bağımlılık enjeksiyonu ile alınan kimlik deposu arayüzü.
  final IKimlikDeposu kimlikDeposu;

  /// KimlikBloc Kurucu Metodu: Olay işleyicileri (event handlers) tanımlar.
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

  /// _onDurumKontrol(): Uygulama açılışında oturum durumunu denetler.
  Future<void> _onDurumKontrol(
    KimlikDurumunuKontrolEtEvent event,
    Emitter<KimlikState> emit,
  ) async {
    emit(KimlikYukleniyor());
    // Açılışta doğrudan giriş ekranını göstermek için mevcut oturum temizlenir.
    await kimlikDeposu.cikisYap();
    emit(KimlikDogrulanmadi());
  }

  /// _onGirisYap(): E-posta ve şifre ile kullanıcı girişini gerçekleştirir.
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

  /// _onKayitOl(): Yeni marka veya influencer kullanıcı kaydını oluşturur.
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

  /// _onCikisYap(): Mevcut oturumu sonlandırır ve kullanıcıyı çıkış yapılmış duruma getirir.
  Future<void> _onCikisYap(
    CikisYapEvent event,
    Emitter<KimlikState> emit,
  ) async {
    emit(KimlikYukleniyor());
    await kimlikDeposu.cikisYap();
    emit(KimlikDogrulanmadi());
  }

  /// _onRolDegistir(): Kullanıcının rolünü (Marka / Influencer) anlık değiştirir.
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

  /// _onHesabiSil(): Kullanıcının hesabını ve Firestore kaydını kalıcı olarak siler.
  Future<void> _onHesabiSil(
    HesabiSilEvent event,
    Emitter<KimlikState> emit,
  ) async {
    emit(KimlikYukleniyor());
    await kimlikDeposu.hesabiSil();
    emit(KimlikDogrulanmadi());
  }

  /// _onProfilGuncelle(): Kullanıcının ad, biyografi veya profil fotoğrafını günceller.
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

  /// _onSifreSifirlamaTalebi(): E-posta adresine şifre sıfırlama bağlantısı gönderir.
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
