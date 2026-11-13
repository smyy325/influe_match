import 'package:equatable/equatable.dart';
import '../models/mesaj_modeli.dart';
import '../models/sohbet_odasi_modeli.dart';

sealed class SohbetState extends Equatable {
  const SohbetState();
  @override
  List<Object?> get props => [];
}

class SohbetBaslangic extends SohbetState {}

class SohbetYukleniyor extends SohbetState {}

class SohbetOdalariYuklendi extends SohbetState {
  final List<SohbetOdasiModeli> odalar;
  final String? aktifSohbetId;
  final List<MesajModeli> aktifMesajlar;

  const SohbetOdalariYuklendi({
    this.odalar = const [],
    this.aktifSohbetId,
    this.aktifMesajlar = const [],
  });

  @override
  List<Object?> get props => [odalar, aktifSohbetId, aktifMesajlar];
}

class MesajlarYuklendi extends SohbetOdalariYuklendi {
  final String sohbetId;
  final List<MesajModeli> mesajlar;

  const MesajlarYuklendi({
    required this.sohbetId,
    required this.mesajlar,
    super.odalar = const [],
  }) : super(aktifSohbetId: sohbetId, aktifMesajlar: mesajlar);

  @override
  List<Object?> get props => [sohbetId, mesajlar, odalar];
}

class SohbetHatasi extends SohbetState {
  final String mesaj;
  const SohbetHatasi(this.mesaj);

  @override
  List<Object?> get props => [mesaj];
}
