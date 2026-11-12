// Dosya Görevi: Kimlik Doğrulama Depo Arayüzü (Repository Interface) ve Sahte (Mock) Depo Uygulaması.
// IKimlikDeposu arayüzü oturum yönetiminde kullanılan tüm metod imzalarını tanımlar.
// SahteKimlikDeposu sınıfı ise test ve offline ortamlarda Firebase olmadan sahte verilerle çalışır.

import 'dart:async';
import '../../../cekirdek/hata/sonuc.dart';
import '../model/kullanici_modeli.dart';

/// IKimlikDeposu: Kimlik deposu için kontrat (Interface) arayüzü.
abstract class IKimlikDeposu {
  Future<Sonuc<KullaniciModeli>> girisYap(String email, String sifre);
  Future<Sonuc<KullaniciModeli>> kayitOl({
    required String adSoyad,
    required String email,
    required String sifre,
    required Rol rol,
  });
  Future<Sonuc<void>> cikisYap();
  Future<KullaniciModeli?> mevcutKullaniciyiGetir();
  Future<Sonuc<KullaniciModeli>> profilGuncelle(KullaniciModeli guncelKullanici);
  Future<Sonuc<KullaniciModeli>> rolDegistir();
  Future<Sonuc<void>> hesabiSil();
  Future<Sonuc<void>> sifreSifirlamaEpostasiGonder(String email);
  Stream<KullaniciModeli?> get kullaniciAkisi;
}

/// SahteKimlikDeposu: Test ve yerel ortamlarda Firebase bağımlılığı olmadan çalışan Sahte Depo (Mock Repository).
class SahteKimlikDeposu implements IKimlikDeposu {
  // Kullanıcı yayın akışını tutan canlı StreamController.
  final _kullaniciKontrolcu = StreamController<KullaniciModeli?>.broadcast();
  KullaniciModeli? _aktifKullanici;

  @override
  Stream<KullaniciModeli?> get kullaniciAkisi => _kullaniciKontrolcu.stream;

  /// mevcutKullaniciyiGetir(): Sahte bellekte tutulan aktif kullanıcıyı döner.
  @override
  Future<KullaniciModeli?> mevcutKullaniciyiGetir() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _aktifKullanici;
  }

  /// girisYap(): Sahte giriş işlemi yapar ve e-postaya göre örnek kullanıcı verisi üretir.
  @override
  Future<Sonuc<KullaniciModeli>> girisYap(String email, String sifre) async {
    await Future.delayed(const Duration(milliseconds: 600));
    if (email.isEmpty || sifre.isEmpty) {
      return const Hata('E-posta ve şifre boş bırakılamaz.');
    }
    _aktifKullanici = KullaniciModeli(
      id: 'kullanici_001',
      adSoyad: email.contains('marka') ? 'Aura Studios' : 'Defne Kaya',
      email: email,
      rol: email.contains('marka') ? Rol.marka : Rol.influencer,
      profilResmi: '',
      biyografi: 'Yaratıcı içerik üreticisi ve marka iş birlikleri.',
      sektorVeyaNis: 'Dijital İletişim',
      takipciSayisi: '85K',
      konum: 'İstanbul, Türkiye',
    );
    _kullaniciKontrolcu.add(_aktifKullanici);
    return Basari(_aktifKullanici!);
  }

  /// kayitOl(): Yeni sahte kullanıcı kaydını oluşturur.
  @override
  Future<Sonuc<KullaniciModeli>> kayitOl({
    required String adSoyad,
    required String email,
    required String sifre,
    required Rol rol,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));
    _aktifKullanici = KullaniciModeli(
      id: 'kullanici_${DateTime.now().millisecondsSinceEpoch}',
      adSoyad: adSoyad,
      email: email,
      rol: rol,
      profilResmi: '',
      biyografi: 'Profilinizi düzenleyerek biyografinizi ekleyin.',
    );
    _kullaniciKontrolcu.add(_aktifKullanici);
    return Basari(_aktifKullanici!);
  }

  /// cikisYap(): Sahte oturumu kapatır.
  @override
  Future<Sonuc<void>> cikisYap() async {
    await Future.delayed(const Duration(milliseconds: 200));
    _aktifKullanici = null;
    _kullaniciKontrolcu.add(null);
    return const Basari(null);
  }

  /// profilGuncelle(): Sahte kullanıcı profil bilgilerini yeniler.
  @override
  Future<Sonuc<KullaniciModeli>> profilGuncelle(KullaniciModeli guncelKullanici) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _aktifKullanici = guncelKullanici;
    _kullaniciKontrolcu.add(_aktifKullanici);
    return Basari(_aktifKullanici!);
  }

  /// hesabiSil(): Sahte hesabı ve oturumu temizler.
  @override
  Future<Sonuc<void>> hesabiSil() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _aktifKullanici = null;
    _kullaniciKontrolcu.add(null);
    return const Basari(null);
  }

  /// rolDegistir(): Sahte kullanıcının rolünü (Marka / Influencer) tersine çevirir.
  @override
  Future<Sonuc<KullaniciModeli>> rolDegistir() async {
    if (_aktifKullanici == null) {
      return const Hata('Oturum açmış kullanıcı bulunamadı.');
    }
    final yeniRol = _aktifKullanici!.rol == Rol.marka ? Rol.influencer : Rol.marka;
    _aktifKullanici = _aktifKullanici!.copyWith(rol: yeniRol);
    _kullaniciKontrolcu.add(_aktifKullanici);
    return Basari(_aktifKullanici!);
  }

  /// sifreSifirlamaEpostasiGonder(): Sahte şifre sıfırlama işlemi.
  @override
  Future<Sonuc<void>> sifreSifirlamaEpostasiGonder(String email) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return const Basari(null);
  }
}
