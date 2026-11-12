import 'package:equatable/equatable.dart';
import '../model/basvuru_modeli.dart';
import '../model/ilan_modeli.dart';

abstract class IlanEvent extends Equatable {
  const IlanEvent();
  @override
  List<Object?> get props => [];
}

class IlanlariYukleEvent extends IlanEvent {
  final String? kategori;
  final String? aramaKelimesi;
  final String? markaId;

  const IlanlariYukleEvent({this.kategori, this.aramaKelimesi, this.markaId});

  @override
  List<Object?> get props => [kategori, aramaKelimesi, markaId];
}

class IlanAkisiniDinleEvent extends IlanEvent {}

class IlanOlusturEvent extends IlanEvent {
  final IlanModeli ilan;

  const IlanOlusturEvent(this.ilan);

  @override
  List<Object?> get props => [ilan];
}

class IlanGuncelleEvent extends IlanEvent {
  final IlanModeli ilan;

  const IlanGuncelleEvent(this.ilan);

  @override
  List<Object?> get props => [ilan];
}

class IlanSilEvent extends IlanEvent {
  final String ilanId;

  const IlanSilEvent(this.ilanId);

  @override
  List<Object?> get props => [ilanId];
}

class IlanaBasvurEvent extends IlanEvent {
  final BasvuruModeli basvuru;

  const IlanaBasvurEvent(this.basvuru);

  @override
  List<Object?> get props => [basvuru];
}

class BasvurulariYukleEvent extends IlanEvent {
  final String? influencerId;
  final String? markaId;

  const BasvurulariYukleEvent({this.influencerId, this.markaId});

  @override
  List<Object?> get props => [influencerId, markaId];
}

