// Dosya Görevi: Tekil Sohbet Mesaj Veri Modeli (ChatMessage Model).
// Bu sınıf, sohbet odası içerisindeki gönderici, alıcı, metin içeriği,
// gönderilme zamanı ve okundu durumunu temsil eden değişmez veri modelidir.

import 'package:equatable/equatable.dart';

/// MesajModeli: Tek bir mesajın verilerini tutan ve Equatable ile eşitlik kontrolü yapılan model.
class MesajModeli extends Equatable {
  final String id;
  final String sohbetId;
  final String gondericiId;
  final String aliciId;
  final String icerik;
  final DateTime zaman;
  final bool okunduMu;

  /// Kurucu Metod: Mesaj nesnesini oluşturur.
  const MesajModeli({
    required this.id,
    required this.sohbetId,
    required this.gondericiId,
    required this.aliciId,
    required this.icerik,
    required this.zaman,
    this.okunduMu = false,
  });

  /// toMap(): Mesaj nesnesini Firestore kaydı için Map<String, dynamic> yapısına çevirir.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'sohbetId': sohbetId,
      'gondericiId': gondericiId,
      'aliciId': aliciId,
      'icerik': icerik,
      'zaman': zaman.toIso8601String(),
      'okunduMu': okunduMu,
    };
  }

  /// fromMap(): Firestore Map verisinden MesajModeli nesnesi oluşturan fabrika metodu.
  factory MesajModeli.fromMap(Map<String, dynamic> map) {
    return MesajModeli(
      id: map['id'] ?? '',
      sohbetId: map['sohbetId'] ?? '',
      gondericiId: map['gondericiId'] ?? '',
      aliciId: map['aliciId'] ?? '',
      icerik: map['icerik'] ?? '',
      zaman: map['zaman'] != null ? DateTime.parse(map['zaman']) : DateTime.now(),
      okunduMu: map['okunduMu'] ?? false,
    );
  }

  /// props: Equatable kıyaslama alanı listesi.
  @override
  List<Object?> get props => [id, sohbetId, gondericiId, aliciId, icerik, zaman, okunduMu];
}
