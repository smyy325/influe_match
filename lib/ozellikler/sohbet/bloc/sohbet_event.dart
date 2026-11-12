import 'package:equatable/equatable.dart';
import '../model/mesaj_modeli.dart';

abstract class SohbetEvent extends Equatable {
  const SohbetEvent();
  @override
  List<Object?> get props => [];
}

class SohbetOdalariniYukleEvent extends SohbetEvent {
  final String kullaniciId;
  const SohbetOdalariniYukleEvent(this.kullaniciId);

  @override
  List<Object?> get props => [kullaniciId];
}

class MesajlariDinleEvent extends SohbetEvent {
  final String sohbetId;
  const MesajlariDinleEvent(this.sohbetId);

  @override
  List<Object?> get props => [sohbetId];
}

class MesajGonderEvent extends SohbetEvent {
  final MesajModeli mesaj;
  const MesajGonderEvent(this.mesaj);

  @override
  List<Object?> get props => [mesaj];
}

class SohbetBaslatEvent extends SohbetEvent {
  final String ilanId;
  final String ilanBasligi;
  final String karsiTarafId;
  final String karsiTarafAdi;
  final String karsiTarafProfil;
  final String karsiTarafRol;
  final String mevcutKullaniciId;

  const SohbetBaslatEvent({
    required this.ilanId,
    required this.ilanBasligi,
    required this.karsiTarafId,
    required this.karsiTarafAdi,
    required this.karsiTarafProfil,
    required this.karsiTarafRol,
    required this.mevcutKullaniciId,
  });

  @override
  List<Object?> get props => [
        ilanId,
        ilanBasligi,
        karsiTarafId,
        karsiTarafAdi,
        karsiTarafProfil,
        karsiTarafRol,
        mevcutKullaniciId,
      ];
}

