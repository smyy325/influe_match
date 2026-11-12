import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../cekirdek/hata/sonuc.dart';
import '../model/basvuru_modeli.dart';

class FirebaseBasvuruYardimcisi {
  final FirebaseFirestore firestore;

  FirebaseBasvuruYardimcisi(this.firestore);

  CollectionReference<Map<String, dynamic>> get basvurularRef => firestore.collection('basvurular');

  Future<Sonuc<BasvuruModeli>> ilanaBasvur(BasvuruModeli basvuru, CollectionReference<Map<String, dynamic>> ilanlarRef) async {
    try {
      await basvurularRef.doc(basvuru.id).set(basvuru.toMap(), SetOptions(merge: true));
      await ilanlarRef.doc(basvuru.ilanId).set({'basvuranInfluencerIds': FieldValue.arrayUnion([basvuru.influencerId])}, SetOptions(merge: true));
      return Basari(basvuru);
    } catch (e) {
      return Hata('Başvuru iletilemedi: $e');
    }
  }

  DateTime _tarihiCoz(dynamic val) {
    if (val == null) return DateTime.now();
    if (val is DateTime) return val;
    if (val is Timestamp) return val.toDate();
    return DateTime.tryParse(val.toString()) ?? DateTime.now();
  }

  Future<BasvuruDurumu> _durumGetir(String docId) async {
    try {
      final bDoc = await basvurularRef.doc(docId).get();
      if (bDoc.exists && bDoc.data()?['durum'] != null) {
        return BasvuruDurumu.values.firstWhere((e) => e.name == bDoc.data()!['durum'], orElse: () => BasvuruDurumu.beklemede);
      }
    } catch (_) {}
    return BasvuruDurumu.beklemede;
  }

  Future<Sonuc<List<BasvuruModeli>>> basvurulariGetir({String? influencerId, String? markaId}) async {
    try {
      final List<BasvuruModeli> basvurular = [];
      final Set<String> eklenenAnahtarlar = {};

      try {
        Query<Map<String, dynamic>> query = basvurularRef;
        if (influencerId != null && influencerId.isNotEmpty) {
          query = query.where('influencerId', isEqualTo: influencerId);
        } else if (markaId != null && markaId.isNotEmpty) {
          query = query.where('markaId', isEqualTo: markaId);
        }
        final snapshot = await query.get();
        for (final doc in snapshot.docs) {
          final data = doc.data()..['id'] = doc.id;
          final item = BasvuruModeli.fromMap(data);
          basvurular.add(item);
          eklenenAnahtarlar.add('${item.ilanId}_${item.influencerId}');
        }
      } catch (_) {}

      if (markaId != null && markaId.isNotEmpty) {
        try {
          final snap = await firestore.collection('ilanlar').where('markaId', isEqualTo: markaId).get();
          for (final doc in snap.docs) {
            final d = doc.data();
            for (final infId in List<String>.from(d['basvuranInfluencerIds'] ?? [])) {
              final key = '${doc.id}_$infId';
              if (eklenenAnahtarlar.add(key)) {
                String infAd = 'İçerik Üretici', infFoto = '';
                try {
                  final kDoc = await firestore.collection('kullanicilar').doc(infId).get();
                  if (kDoc.exists && kDoc.data() != null) {
                    infAd = kDoc.data()!['adSoyad'] ?? kDoc.data()!['ad'] ?? 'İçerik Üretici';
                    infFoto = kDoc.data()!['profilResmi'] ?? '';
                  }
                } catch (_) {}
                final durum = await _durumGetir('basvuru_${doc.id}_$infId');
                basvurular.add(BasvuruModeli(
                  id: 'basvuru_${doc.id}_$infId', ilanId: doc.id, ilanBasligi: d['baslik'] ?? 'Kampanya İlanı',
                  markaId: markaId, markaAdi: d['markaAdi'] ?? 'Marka', influencerId: infId, influencerAdi: infAd,
                  influencerProfil: infFoto, basvuruNotu: 'İş birliği başvurusu yapıldı.', durum: durum, tarih: _tarihiCoz(d['olusturulmaTarihi']),
                ));
              }
            }
          }
        } catch (_) {}
      }

      if (influencerId != null && influencerId.isNotEmpty) {
        try {
          final snap = await firestore.collection('ilanlar').where('basvuranInfluencerIds', arrayContains: influencerId).get();
          for (final doc in snap.docs) {
            final key = '${doc.id}_$influencerId';
            if (eklenenAnahtarlar.add(key)) {
              final d = doc.data();
              final durum = await _durumGetir('basvuru_${doc.id}_$influencerId');
              basvurular.add(BasvuruModeli(
                id: 'basvuru_${doc.id}_$influencerId', ilanId: doc.id, ilanBasligi: d['baslik'] ?? 'Kampanya İlanı',
                markaId: d['markaId'] ?? '', markaAdi: d['markaAdi'] ?? 'Marka', influencerId: influencerId,
                influencerAdi: 'Influencer', basvuruNotu: 'Kampanya başvurusu iletildi.', durum: durum, tarih: _tarihiCoz(d['olusturulmaTarihi']),
              ));
            }
          }
        } catch (_) {}
      }

      basvurular.sort((a, b) => b.tarih.compareTo(a.tarih));
      return Basari(basvurular);
    } catch (e) {
      return const Basari(<BasvuruModeli>[]);
    }
  }

  Future<Sonuc<BasvuruModeli>> basvuruDurumuDegistir(String basvuruId, BasvuruDurumu yeniDurum, {BasvuruModeli? basvuru}) async {
    try {
      if (basvuru != null) {
        final guncel = basvuru.copyWith(durum: yeniDurum);
        await basvurularRef.doc(basvuruId).set(guncel.toMap(), SetOptions(merge: true));
        return Basari(guncel);
      }
      await basvurularRef.doc(basvuruId).set({'durum': yeniDurum.name}, SetOptions(merge: true));
      final doc = await basvurularRef.doc(basvuruId).get();
      if (doc.exists && doc.data() != null) {
        final data = doc.data()!..['id'] = doc.id;
        return Basari(BasvuruModeli.fromMap(data));
      }
      return const Hata('Güncellenen başvuru bulunamadı.');
    } catch (e) {
      return Hata('Durum güncellenemedi: $e');
    }
  }
}
