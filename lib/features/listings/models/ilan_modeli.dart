import 'package:equatable/equatable.dart';

enum IlanDurumu { taslak, yayinda, kapandi }

class IlanModeli extends Equatable {
  final String id;
  final String markaId;
  final String markaAdi;
  final String markaLogoUrl;
  final String baslik;
  final String aciklama;
  final String kategori;
  final String platform;
  final String butceTuru;
  final List<String> sartlar;
  final IlanDurumu durum;
  final DateTime olusturulmaTarihi;
  final List<String> basvuranInfluencerIds;
  final String hedefInfluencer;

  const IlanModeli({
    required this.id,
    required this.markaId,
    required this.markaAdi,
    this.markaLogoUrl = '',
    required this.baslik,
    required this.aciklama,
    required this.kategori,
    this.platform = 'Instagram & TikTok',
    this.butceTuru = 'Özel Anlaşmalı & Ürün Hediyeli',
    required this.sartlar,
    this.durum = IlanDurumu.yayinda,
    required this.olusturulmaTarihi,
    this.basvuranInfluencerIds = const [],
    this.hedefInfluencer = '',
  });

  bool get yayindaMi => durum == IlanDurumu.yayinda;

  bool get taslakMi => durum == IlanDurumu.taslak;

  bool get kapandiMi => durum == IlanDurumu.kapandi;

  bool get ozelIlanMi => hedefInfluencer.trim().isNotEmpty;

  IlanModeli copyWith({
    String? id,
    String? markaId,
    String? markaAdi,
    String? markaLogoUrl,
    String? baslik,
    String? aciklama,
    String? kategori,
    String? platform,
    String? butceTuru,
    List<String>? sartlar,
    IlanDurumu? durum,
    DateTime? olusturulmaTarihi,
    List<String>? basvuranInfluencerIds,
    String? hedefInfluencer,
  }) {
    return IlanModeli(
      id: id ?? this.id,
      markaId: markaId ?? this.markaId,
      markaAdi: markaAdi ?? this.markaAdi,
      markaLogoUrl: markaLogoUrl ?? this.markaLogoUrl,
      baslik: baslik ?? this.baslik,
      aciklama: aciklama ?? this.aciklama,
      kategori: kategori ?? this.kategori,
      platform: platform ?? this.platform,
      butceTuru: butceTuru ?? this.butceTuru,
      sartlar: sartlar ?? this.sartlar,
      durum: durum ?? this.durum,
      olusturulmaTarihi: olusturulmaTarihi ?? this.olusturulmaTarihi,
      basvuranInfluencerIds: basvuranInfluencerIds ?? this.basvuranInfluencerIds,
      hedefInfluencer: hedefInfluencer ?? this.hedefInfluencer,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'markaId': markaId,
      'markaAdi': markaAdi,
      'markaLogoUrl': markaLogoUrl,
      'baslik': baslik,
      'aciklama': aciklama,
      'kategori': kategori,
      'platform': platform,
      'butceTuru': butceTuru,
      'sartlar': sartlar,
      'durum': durum.name,
      'olusturulmaTarihi': olusturulmaTarihi.toIso8601String(),
      'basvuranInfluencerIds': basvuranInfluencerIds,
      'hedefInfluencer': hedefInfluencer,
    };
  }

  factory IlanModeli.fromMap(Map<String, dynamic> map) {
    return IlanModeli(
      id: map['id'] ?? '',
      markaId: map['markaId'] ?? '',
      markaAdi: map['markaAdi'] ?? '',
      markaLogoUrl: map['markaLogoUrl'] ?? '',
      baslik: map['baslik'] ?? '',
      aciklama: map['aciklama'] ?? '',
      kategori: map['kategori'] ?? 'Genel',
      platform: map['platform'] ?? 'Instagram',
      butceTuru: map['butceTuru'] ?? 'İş Birliği',
      sartlar: List<String>.from(map['sartlar'] ?? []),
      durum: IlanDurumu.values.firstWhere((e) => e.name == map['durum'], orElse: () => IlanDurumu.yayinda),
      olusturulmaTarihi: map['olusturulmaTarihi'] != null ? DateTime.parse(map['olusturulmaTarihi']) : DateTime.now(),
      basvuranInfluencerIds: List<String>.from(map['basvuranInfluencerIds'] ?? []),
      hedefInfluencer: map['hedefInfluencer'] ?? '',
    );
  }

  @override
  List<Object?> get props => [
        id,
        markaId,
        markaAdi,
        markaLogoUrl,
        baslik,
        aciklama,
        kategori,
        platform,
        butceTuru,
        sartlar,
        durum,
        olusturulmaTarihi,
        basvuranInfluencerIds,
        hedefInfluencer,
      ];
}
