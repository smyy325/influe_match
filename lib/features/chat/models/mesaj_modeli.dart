import 'package:equatable/equatable.dart';
class MesajModeli extends Equatable {
  final String id;
  final String sohbetId;
  final String gondericiId;
  final String aliciId;
  final String icerik;
  final DateTime zaman;
  final bool okunduMu;

  const MesajModeli({
    required this.id,
    required this.sohbetId,
    required this.gondericiId,
    required this.aliciId,
    required this.icerik,
    required this.zaman,
    this.okunduMu = false,
  });

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

  @override
  List<Object?> get props => [id, sohbetId, gondericiId, aliciId, icerik, zaman, okunduMu];
}
