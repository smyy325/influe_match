// Dosya Görevi: Sohbet Odası Özet Veri Modeli (Chat Room Model).
// Bu sınıf, Marka ile Influencer arasındaki sohbet odasını, ilişkili kampanya ilanını,
// karşı taraf bilgilerini, son mesajı ve okunmamış mesaj sayısını temsil eder.

import 'package:equatable/equatable.dart';

/// SohbetOdasiModeli: Sohbet listesinde gösterilen oda verilerini tutan model sınıfı.
class SohbetOdasiModeli extends Equatable {
  final String id;
  final String ilanId;
  final String ilanBasligi;
  final List<String> katilimciIds;
  final String karsiTarafId;
  final String karsiTarafAdi;
  final String karsiTarafProfil;
  final String karsiTarafRol; // 'Marka' veya 'Influencer'
  final String sonMesaj;
  final DateTime sonMesajZamani;
  final int okunmamisAdet;

  /// Kurucu Metod: Sohbet odasını ilklendirir.
  const SohbetOdasiModeli({
    required this.id,
    required this.ilanId,
    required this.ilanBasligi,
    required this.katilimciIds,
    required this.karsiTarafId,
    required this.karsiTarafAdi,
    this.karsiTarafProfil = '',
    this.karsiTarafRol = 'Marka',
    required this.sonMesaj,
    required this.sonMesajZamani,
    this.okunmamisAdet = 0,
  });

  /// copyWith(): Sohbet odası nesnesinin kopyasını alarak son mesaj veya okunmamış adet bilgilerini günceller.
  SohbetOdasiModeli copyWith({
    String? id,
    String? ilanId,
    String? ilanBasligi,
    List<String>? katilimciIds,
    String? karsiTarafId,
    String? karsiTarafAdi,
    String? karsiTarafProfil,
    String? karsiTarafRol,
    String? sonMesaj,
    DateTime? sonMesajZamani,
    int? okunmamisAdet,
  }) {
    return SohbetOdasiModeli(
      id: id ?? this.id,
      ilanId: ilanId ?? this.ilanId,
      ilanBasligi: ilanBasligi ?? this.ilanBasligi,
      katilimciIds: katilimciIds ?? this.katilimciIds,
      karsiTarafId: karsiTarafId ?? this.karsiTarafId,
      karsiTarafAdi: karsiTarafAdi ?? this.karsiTarafAdi,
      karsiTarafProfil: karsiTarafProfil ?? this.karsiTarafProfil,
      karsiTarafRol: karsiTarafRol ?? this.karsiTarafRol,
      sonMesaj: sonMesaj ?? this.sonMesaj,
      sonMesajZamani: sonMesajZamani ?? this.sonMesajZamani,
      okunmamisAdet: okunmamisAdet ?? this.okunmamisAdet,
    );
  }

  /// props: Equatable kıyaslama alanı listesi.
  @override
  List<Object?> get props => [
        id,
        ilanId,
        ilanBasligi,
        katilimciIds,
        karsiTarafId,
        karsiTarafAdi,
        karsiTarafProfil,
        karsiTarafRol,
        sonMesaj,
        sonMesajZamani,
        okunmamisAdet,
      ];
}
