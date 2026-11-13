import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/mesaj_modeli.dart';
import '../models/sohbet_odasi_modeli.dart';

class SohbetModelEsleyici {
  static String odaIdOlustur({
    required String ilanId,
    required String id1,
    required String id2,
  }) {
    final list = [id1, id2]..sort();
    final temizIlan = ilanId.replaceAll(RegExp(r'[^a-zA-Z0-9_]'), '_');
    return 'sohbet_${temizIlan}_${list[0]}_${list[1]}';
  }

  static SohbetOdasiModeli odaBelgeden(
    String id,
    Map<String, dynamic> data, [
    String? mevcutKullaniciId,
  ]) {
    final katilimcilar = data['katilimcilar'] as Map<String, dynamic>?;
    final katilimciList = List<String>.from(data['katilimciIds'] ?? data['participants'] ?? []);
    String karsiId = '';
    if (mevcutKullaniciId != null && katilimciList.isNotEmpty) {
      karsiId = katilimciList.firstWhere((kId) => kId != mevcutKullaniciId, orElse: () => data['karsiTarafId'] ?? '');
    } else {
      karsiId = data['karsiTarafId'] ?? '';
    }

    String karsiAdi = '', karsiProfil = '', karsiRol = data['karsiTarafRol'] ?? 'Influencer';

    if (katilimcilar != null && karsiId.isNotEmpty && katilimcilar.containsKey(karsiId)) {
      final info = Map<String, dynamic>.from(katilimcilar[karsiId] is Map ? katilimcilar[karsiId] : {});
      final ad = info['ad']?.toString() ?? '';
      if (ad.trim().isNotEmpty) karsiAdi = ad.trim();
      final profil = info['profil']?.toString() ?? '';
      if (profil.trim().isNotEmpty) karsiProfil = profil.trim();
      final rol = info['rol']?.toString() ?? '';
      if (rol.trim().isNotEmpty) karsiRol = rol.trim();
    }

    if (karsiAdi.isEmpty && data['karsiTarafId'] != mevcutKullaniciId) {
      karsiAdi = data['karsiTarafAdi'] ?? '';
      karsiProfil = data['karsiTarafProfil'] ?? '';
    }

    return SohbetOdasiModeli(
      id: id,
      ilanId: data['ilanId'] ?? '',
      ilanBasligi: data['ilanBasligi'] ?? '',
      katilimciIds: katilimciList,
      karsiTarafId: karsiId,
      karsiTarafAdi: karsiAdi.isNotEmpty ? karsiAdi : 'Kullanıcı',
      karsiTarafProfil: karsiProfil,
      karsiTarafRol: karsiRol,
      sonMesaj: data['sonMesaj'] ?? '',
      sonMesajZamani: data['sonMesajZamani'] != null
          ? (data['sonMesajZamani'] is Timestamp
              ? (data['sonMesajZamani'] as Timestamp).toDate()
              : DateTime.tryParse(data['sonMesajZamani'].toString()) ?? DateTime.now())
          : DateTime.now(),
      okunmamisAdet: data['okunmamisAdet'] ?? 0,
    );
  }

  static Map<String, dynamic> odaHaritasi(
    SohbetOdasiModeli oda, {
    String? mevcutId,
    String? mevcutAd,
    String? mevcutProfil,
    String? mevcutRol,
  }) {
    final Map<String, dynamic> katilimcilar = {};
    if (mevcutId != null && mevcutId.isNotEmpty) {
      katilimcilar[mevcutId] = {
        'ad': mevcutAd ?? '',
        'profil': mevcutProfil ?? '',
        'rol': mevcutRol ?? '',
      };
    }
    if (oda.karsiTarafId.isNotEmpty) {
      katilimcilar[oda.karsiTarafId] = {
        'ad': oda.karsiTarafAdi,
        'profil': oda.karsiTarafProfil,
        'rol': oda.karsiTarafRol,
      };
    }

    return {
      'id': oda.id,
      'ilanId': oda.ilanId,
      'ilanBasligi': oda.ilanBasligi,
      'katilimciIds': oda.katilimciIds,
      'participants': oda.katilimciIds,
      'karsiTarafId': oda.karsiTarafId,
      'karsiTarafAdi': oda.karsiTarafAdi,
      'karsiTarafProfil': oda.karsiTarafProfil,
      'karsiTarafRol': oda.karsiTarafRol,
      if (katilimcilar.isNotEmpty) 'katilimcilar': katilimcilar,
      'sonMesaj': oda.sonMesaj,
      'sonMesajZamani': Timestamp.fromDate(oda.sonMesajZamani),
      'okunmamisAdet': oda.okunmamisAdet,
    };
  }

  static MesajModeli mesajBelgeden(String id, String sohbetId, Map<String, dynamic> data) {
    return MesajModeli(
      id: id,
      sohbetId: sohbetId,
      gondericiId: data['gondericiId'] ?? '',
      aliciId: data['aliciId'] ?? '',
      icerik: data['icerik'] ?? '',
      zaman: data['zaman'] != null
          ? (data['zaman'] is Timestamp
              ? (data['zaman'] as Timestamp).toDate()
              : DateTime.tryParse(data['zaman'].toString()) ?? DateTime.now())
          : DateTime.now(),
      okunduMu: data['okunduMu'] ?? false,
    );
  }
}
