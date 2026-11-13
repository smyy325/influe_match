import 'package:equatable/equatable.dart';

import '../models/kullanici_modeli.dart';

abstract class KimlikEvent extends Equatable {
  const KimlikEvent();
  @override
  List<Object?> get props => [];
}

class KimlikDurumunuKontrolEtEvent extends KimlikEvent {}

class GirisYapEvent extends KimlikEvent {
  final String email;
  final String sifre;

  const GirisYapEvent({required this.email, required this.sifre});

  @override
  List<Object?> get props => [email, sifre];
}

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

class CikisYapEvent extends KimlikEvent {}

class RolDegistirEvent extends KimlikEvent {}

class ProfilGuncelleEvent extends KimlikEvent {
  final KullaniciModeli kullanici;

  const ProfilGuncelleEvent(this.kullanici);

  @override
  List<Object?> get props => [kullanici];
}

class HesabiSilEvent extends KimlikEvent {}

class SifreSifirlamaTalebiEvent extends KimlikEvent {
  final String email;
  const SifreSifirlamaTalebiEvent(this.email);

  @override
  List<Object?> get props => [email];
}
