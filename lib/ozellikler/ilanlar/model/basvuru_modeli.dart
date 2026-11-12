// Dosya Görevi: Kampanya Başvuru ve Özel Teklif Yanıt Veri Modeli.
// Bu sınıf, içerik üreticilerinin ilanlara yaptığı başvuruları, gönderilen pitch notlarını,
// başvuru durumunu (Beklemede, Kabul Edildi, Reddedildi) ve tarih bilgisini tutar.

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

/// BasvuruDurumu: Başvurunun değerlendirme aşamasını (beklemede, kabulEdildi, reddedildi) temsil eden enum.
enum BasvuruDurumu { beklemede, kabulEdildi, reddedildi }

/// BasvuruModeli: Başvuru verilerini taşıyan ve kıyaslanan model sınıfı.
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

  /// Kurucu Metod: Başvuru verilerini ilklendirir.
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

  /// copyWith(): Başvuru nesnesini kopyalayarak durum (Kabul/Ret) güncellemelerini kolaylaştırır.
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

  /// toMap(): Başvuru verisini Firestore kaydı için Map formatına dönüştürür.
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

  /// fromMap(): Firestore Map verisinden BasvuruModeli nesnesi oluşturur.
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

  /// props: Equatable kıyaslama alanı listesi.
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
