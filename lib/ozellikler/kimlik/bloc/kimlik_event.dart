// Dosya Görevi: Kimlik Doğrulama ve Oturum İşlemleri Olayları (Events).
// BLoC mimarisinde kullanıcı etkileşimleri (giriş yap, kaydol, çıkış yap vb.)
// bu olay sınıfları aracılığıyla KimlikBloc bileşenine tetikleyici (Input) olarak iletilir.

import 'package:equatable/equatable.dart';
import '../model/kullanici_modeli.dart';

/// KimlikEvent: Tüm kimlik doğrulama olaylarının türediği soyut (abstract) taban sınıf.
/// Equatable: Nesne karşılaştırmalarında bellek adresi yerine alan değerlerini kıyaslamak için kullanılır.
abstract class KimlikEvent extends Equatable {
  const KimlikEvent();
  @override
  List<Object?> get props => [];
}

/// KimlikDurumunuKontrolEtEvent: Uygulama açılışında mevcut oturum durumunu sorgulayan olay.
class KimlikDurumunuKontrolEtEvent extends KimlikEvent {}

/// GirisYapEvent: E-posta ve şifre bilgileri ile giriş yapma isteğini ileten olay.
class GirisYapEvent extends KimlikEvent {
  final String email;
  final String sifre;

  const GirisYapEvent({required this.email, required this.sifre});

  @override
  List<Object?> get props => [email, sifre];
}

/// KayitOlEvent: Ad, e-posta, şifre ve seçilen rol ile yeni hesap oluşturma isteği.
class KayitOlEvent extends KimlikEvent {
  final String adSoyad;
  final String email;
  final String sifre;
  final Rol rol;

  const KayitOlEvent({
    required this.adSoyad,
    required this.email,
    required this.sifre,
    required this.rol,
  });

  @override
  List<Object?> get props => [adSoyad, email, sifre, rol];
}

/// CikisYapEvent: Kullanıcı oturumunu kapatma olayı.
class CikisYapEvent extends KimlikEvent {}

/// RolDegistirEvent: Kullanıcı rolünü Marka <-> Influencer arasında değiştirme olayı.
class RolDegistirEvent extends KimlikEvent {}

/// ProfilGuncelleEvent: Kullanıcının profil bilgilerini güncelleme isteği.
class ProfilGuncelleEvent extends KimlikEvent {
  final KullaniciModeli kullanici;

  const ProfilGuncelleEvent(this.kullanici);

  @override
  List<Object?> get props => [kullanici];
}

/// HesabiSilEvent: Kullanıcı hesabını ve Firestore verilerini silme olayı.
class HesabiSilEvent extends KimlikEvent {}

/// SifreSifirlamaTalebiEvent: Şifre sıfırlama e-postası gönderme isteği.
class SifreSifirlamaTalebiEvent extends KimlikEvent {
  final String email;
  const SifreSifirlamaTalebiEvent(this.email);

  @override
  List<Object?> get props => [email];
}
