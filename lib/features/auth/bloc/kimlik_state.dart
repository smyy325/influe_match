import 'package:equatable/equatable.dart';
import '../models/kullanici_modeli.dart';

sealed class KimlikState extends Equatable {
  const KimlikState();
  @override
  List<Object?> get props => [];

  get kullanici => null;
}

class KimlikBaslangic extends KimlikState {}

class KimlikYukleniyor extends KimlikState {}

class KimlikDogrulandi extends KimlikState {
  final KullaniciModeli kullanici;
  const KimlikDogrulandi(this.kullanici);

  @override
  List<Object?> get props => [kullanici];
}

class KimlikDogrulanmadi extends KimlikState {}

class KimlikHatasi extends KimlikState {
  final String mesaj;
  const KimlikHatasi(this.mesaj);

  @override
  List<Object?> get props => [mesaj];
}

class SifreSifirlamaEpostasiGonderildi extends KimlikState {
  final String mesaj;
  const SifreSifirlamaEpostasiGonderildi(this.mesaj);

  @override
  List<Object?> get props => [mesaj];
}
