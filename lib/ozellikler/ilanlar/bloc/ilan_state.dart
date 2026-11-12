import 'package:equatable/equatable.dart';
import '../model/basvuru_modeli.dart';
import '../model/ilan_modeli.dart';

sealed class IlanState extends Equatable {
  const IlanState();
  @override
  List<Object?> get props => [];
}

class IlanBaslangic extends IlanState {}

class IlanYukleniyor extends IlanState {}

class IlanlarYuklendi extends IlanState {
  final List<IlanModeli> ilanlar;
  final List<BasvuruModeli> basvurular;
  final String seciliKategori;

  const IlanlarYuklendi({
    this.ilanlar = const [],
    this.basvurular = const [],
    this.seciliKategori = 'Tümü',
  });

  IlanlarYuklendi copyWith({
    List<IlanModeli>? ilanlar,
    List<BasvuruModeli>? basvurular,
    String? seciliKategori,
  }) {
    return IlanlarYuklendi(
      ilanlar: ilanlar ?? this.ilanlar,
      basvurular: basvurular ?? this.basvurular,
      seciliKategori: seciliKategori ?? this.seciliKategori,
    );
  }

  @override
  List<Object?> get props => [ilanlar, basvurular, seciliKategori];
}

class IlanIslemiBasarili extends IlanState {
  final String mesaj;
  const IlanIslemiBasarili(this.mesaj);

  @override
  List<Object?> get props => [mesaj];
}

class BasvurularYuklendi extends IlanlarYuklendi {
  const BasvurularYuklendi(
    List<BasvuruModeli> basvurular, {
    super.ilanlar = const [],
    super.seciliKategori = 'Tümü',
  }) : super(basvurular: basvurular);
}

class IlanHatasi extends IlanState {
  final String mesaj;
  const IlanHatasi(this.mesaj);

  @override
  List<Object?> get props => [mesaj];
}
