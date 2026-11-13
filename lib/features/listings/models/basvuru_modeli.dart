import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

enum BasvuruDurumu { beklemede, kabulEdildi, reddedildi }

class BasvuruModeli extends Equatable {
  final String id;
  final String ilanId;
  final String ilanBasligi;
  final String markaId;
  final String markaAdi;
  final String influencerId;
  final String influencerAdi;
  final String influencerProfil;
  final String basvuruNotu;
  final BasvuruDurumu durum;
  final DateTime tarih;

  const BasvuruModeli({
    required this.id,
    required this.ilanId,
    required this.ilanBasligi,
    this.markaId = '',
    required this.markaAdi,
    required this.influencerId,
    required this.influencerAdi,
    this.influencerProfil = '',
    required this.basvuruNotu,
    this.durum = BasvuruDurumu.beklemede,
    required this.tarih,
  });

  BasvuruModeli copyWith({
    String? id,
    String? ilanId,
    String? ilanBasligi,
    String? markaId,
    String? markaAdi,
    String? influencerId,
    String? influencerAdi,
    String? influencerProfil,
    String? basvuruNotu,
    BasvuruDurumu? durum,
    DateTime? tarih,
  }) {
    return BasvuruModeli(
      id: id ?? this.id,
      ilanId: ilanId ?? this.ilanId,
      ilanBasligi: ilanBasligi ?? this.ilanBasligi,
      markaId: markaId ?? this.markaId,
      markaAdi: markaAdi ?? this.markaAdi,
      influencerId: influencerId ?? this.influencerId,
      influencerAdi: influencerAdi ?? this.influencerAdi,
      influencerProfil: influencerProfil ?? this.influencerProfil,
      basvuruNotu: basvuruNotu ?? this.basvuruNotu,
      durum: durum ?? this.durum,
      tarih: tarih ?? this.tarih,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'ilanId': ilanId,
      'ilanBasligi': ilanBasligi,
      'markaId': markaId,
      'markaAdi': markaAdi,
      'influencerId': influencerId,
      'influencerAdi': influencerAdi,
      'influencerProfil': influencerProfil,
      'basvuruNotu': basvuruNotu,
      'durum': durum.name,
      'tarih': tarih.toIso8601String(),
    };
  }

  factory BasvuruModeli.fromMap(Map<String, dynamic> map) {
    return BasvuruModeli(
      id: map['id'] ?? '',
      ilanId: map['ilanId'] ?? '',
      ilanBasligi: map['ilanBasligi'] ?? '',
      markaId: map['markaId'] ?? '',
      markaAdi: map['markaAdi'] ?? '',
      influencerId: map['influencerId'] ?? '',
      influencerAdi: map['influencerAdi'] ?? '',
      influencerProfil: map['influencerProfil'] ?? '',
      basvuruNotu: map['basvuruNotu'] ?? '',
      durum: BasvuruDurumu.values.firstWhere(
        (e) => e.name == map['durum'],
        orElse: () => BasvuruDurumu.beklemede,
      ),
      tarih: map['tarih'] is DateTime
          ? map['tarih'] as DateTime
          : (map['tarih'] is Timestamp
              ? (map['tarih'] as Timestamp).toDate()
              : (map['tarih'] != null ? DateTime.tryParse(map['tarih'].toString()) ?? DateTime.now() : DateTime.now())),
    );
  }

  @override
  List<Object?> get props => [
        id,
        ilanId,
        ilanBasligi,
        markaId,
        markaAdi,
        influencerId,
        influencerAdi,
        influencerProfil,
        basvuruNotu,
        durum,
        tarih,
      ];
}
