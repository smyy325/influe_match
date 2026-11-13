import 'dart:async';

import '../../../core/error/sonuc.dart';
import '../models/kullanici_modeli.dart';

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

class SahteKimlikDeposu implements IKimlikDeposu {
  final _kullaniciKontrolcu = StreamController<KullaniciModeli?>.broadcast();
  KullaniciModeli? _aktifKullanici;

  @override
  Stream<KullaniciModeli?> get kullaniciAkisi => _kullaniciKontrolcu.stream;

  @override
  Future<KullaniciModeli?> mevcutKullaniciyiGetir() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _aktifKullanici;
  }

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

  @override
  Future<Sonuc<void>> cikisYap() async {
    await Future.delayed(const Duration(milliseconds: 200));
    _aktifKullanici = null;
    _kullaniciKontrolcu.add(null);
    return const Basari(null);
  }

  @override
  Future<Sonuc<KullaniciModeli>> profilGuncelle(KullaniciModeli guncelKullanici) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _aktifKullanici = guncelKullanici;
    _kullaniciKontrolcu.add(_aktifKullanici);
    return Basari(_aktifKullanici!);
  }

  @override
  Future<Sonuc<void>> hesabiSil() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _aktifKullanici = null;
    _kullaniciKontrolcu.add(null);
    return const Basari(null);
  }

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

  @override
  Future<Sonuc<void>> sifreSifirlamaEpostasiGonder(String email) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return const Basari(null);
  }
}
