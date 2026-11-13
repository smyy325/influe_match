import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/error/sonuc.dart';
import '../models/mesaj_modeli.dart';
import '../models/sohbet_odasi_modeli.dart';
import 'sohbet_deposu.dart';
import 'sohbet_model_esleyici.dart';

class FirebaseSohbetDeposu implements ISohbetDeposu {
  final FirebaseFirestore _firestore;

  FirebaseSohbetDeposu({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _sohbetlerRef => _firestore.collection('sohbetler');

  @override
  Future<Sonuc<List<SohbetOdasiModeli>>> sohbetOdalariniGetir(String kullaniciId) async {
    try {
      var snap = await _sohbetlerRef.where('katilimciIds', arrayContains: kullaniciId).get().timeout(const Duration(seconds: 4));
      if (snap.docs.isEmpty) {
        try {
          final pSnap = await _sohbetlerRef.where('participants', arrayContains: kullaniciId).get().timeout(const Duration(seconds: 3));
          if (pSnap.docs.isNotEmpty) snap = pSnap;
        } catch (_) {}
      }
      final List<SohbetOdasiModeli> odalar = [];
      for (final doc in snap.docs) {
        var oda = SohbetModelEsleyici.odaBelgeden(doc.id, doc.data(), kullaniciId);
        if (oda.karsiTarafAdi == 'Kullanıcı' && oda.karsiTarafId.isNotEmpty) {
          try {
            final kDoc = await _firestore.collection('kullanicilar').doc(oda.karsiTarafId).get();
            if (kDoc.exists && kDoc.data() != null) {
              final ad = (kDoc.data()!['adSoyad'] ?? kDoc.data()!['ad'] ?? '').toString().trim();
              final foto = (kDoc.data()!['profilResmi'] ?? '').toString();
              if (ad.isNotEmpty) {
                oda = oda.copyWith(karsiTarafAdi: ad, karsiTarafProfil: foto);
                _sohbetlerRef.doc(doc.id).set({'katilimcilar': {oda.karsiTarafId: {'ad': ad, 'profil': foto}}}, SetOptions(merge: true)).catchError((_) {});
              }
            }
          } catch (_) {}
        }
        odalar.add(oda);
      }
      odalar.sort((a, b) => b.sonMesajZamani.compareTo(a.sonMesajZamani));
      return Basari(odalar);
    } catch (e) {
      return Basari(const <SohbetOdasiModeli>[]);
    }
  }

  @override
  Stream<List<SohbetOdasiModeli>> sohbetOdalariniIzle(String kullaniciId) {
    return _sohbetlerRef.where('katilimciIds', arrayContains: kullaniciId).snapshots().handleError((_) {}).map((snapshot) {
      final odalar = snapshot.docs.map((doc) => SohbetModelEsleyici.odaBelgeden(doc.id, doc.data(), kullaniciId)).toList();
      odalar.sort((a, b) => b.sonMesajZamani.compareTo(a.sonMesajZamani));
      return odalar;
    });
  }

  @override
  Stream<List<MesajModeli>> mesajlariIzle(String sohbetId) {
    return _sohbetlerRef.doc(sohbetId).collection('mesajlar').orderBy('zaman', descending: false).snapshots().handleError((_) {}).map((s) =>
        s.docs.map((doc) => SohbetModelEsleyici.mesajBelgeden(doc.id, sohbetId, doc.data())).toList());
  }

  @override
  Future<Sonuc<MesajModeli>> mesajGonder(MesajModeli mesaj) async {
    try {
      final docRef = _sohbetlerRef.doc(mesaj.sohbetId);
      await docRef.collection('mesajlar').doc(mesaj.id).set({
        'id': mesaj.id, 'sohbetId': mesaj.sohbetId, 'gondericiId': mesaj.gondericiId,
        'aliciId': mesaj.aliciId, 'icerik': mesaj.icerik, 'zaman': Timestamp.fromDate(mesaj.zaman), 'okunduMu': mesaj.okunduMu,
      });
      await docRef.set({'sonMesaj': mesaj.icerik, 'sonMesajZamani': Timestamp.fromDate(mesaj.zaman)}, SetOptions(merge: true)).catchError((_) {});
      return Basari(mesaj);
    } catch (e) {
      return Hata('Mesaj gönderilemedi: $e');
    }
  }

  @override
  Future<Sonuc<SohbetOdasiModeli>> sohbetOlusturVeyaGetir({
    required String ilanId,
    required String ilanBasligi,
    required String karsiTarafId,
    required String karsiTarafAdi,
    required String karsiTarafProfil,
    required String karsiTarafRol,
    required String mevcutKullaniciId,
  }) async {
    try {
      QuerySnapshot<Map<String, dynamic>>? snap;
      try {
        snap = await _sohbetlerRef.where('katilimciIds', arrayContains: mevcutKullaniciId).get();
      } catch (_) {}

      QueryDocumentSnapshot<Map<String, dynamic>>? eslesen;
      if (snap != null) {
        for (final doc in snap.docs) {
          final list = List<String>.from(doc.data()['katilimciIds'] ?? doc.data()['participants'] ?? []);
          if (list.contains(karsiTarafId)) {
            if (doc.data()['ilanId'] == ilanId) { eslesen = doc; break; }
            eslesen ??= doc;
          }
        }
      }
      if (eslesen != null) return Basari(SohbetModelEsleyici.odaBelgeden(eslesen.id, eslesen.data(), mevcutKullaniciId));

      final odaId = SohbetModelEsleyici.odaIdOlustur(ilanId: ilanId, id1: mevcutKullaniciId, id2: karsiTarafId);
      final doc = await _sohbetlerRef.doc(odaId).get();
      if (doc.exists && doc.data() != null) return Basari(SohbetModelEsleyici.odaBelgeden(doc.id, doc.data()!, mevcutKullaniciId));

      String mevcutAd = '', mevcutProfil = '';
      try {
        final mDoc = await _firestore.collection('kullanicilar').doc(mevcutKullaniciId).get();
        if (mDoc.exists && mDoc.data() != null) {
          mevcutAd = mDoc.data()!['adSoyad'] ?? mDoc.data()!['ad'] ?? '';
          mevcutProfil = mDoc.data()!['profilResmi'] ?? '';
        }
      } catch (_) {}

      var sonKarsiAdi = karsiTarafAdi, sonKarsiProfil = karsiTarafProfil;
      if (sonKarsiAdi.isEmpty || sonKarsiAdi == 'Kullanıcı') {
        try {
          final kDoc = await _firestore.collection('kullanicilar').doc(karsiTarafId).get();
          if (kDoc.exists && kDoc.data() != null) {
            sonKarsiAdi = kDoc.data()!['adSoyad'] ?? kDoc.data()!['ad'] ?? sonKarsiAdi;
            sonKarsiProfil = kDoc.data()!['profilResmi'] ?? sonKarsiProfil;
          }
        } catch (_) {}
      }

      final yeniOda = SohbetOdasiModeli(
        id: odaId, ilanId: ilanId, ilanBasligi: ilanBasligi,
        katilimciIds: [mevcutKullaniciId, karsiTarafId], karsiTarafId: karsiTarafId,
        karsiTarafAdi: sonKarsiAdi, karsiTarafProfil: sonKarsiProfil, karsiTarafRol: karsiTarafRol,
        sonMesaj: 'Sohbet başlatıldı.', sonMesajZamani: DateTime.now(),
      );

      await _sohbetlerRef.doc(odaId).set(
        SohbetModelEsleyici.odaHaritasi(yeniOda, mevcutId: mevcutKullaniciId, mevcutAd: mevcutAd, mevcutProfil: mevcutProfil),
        SetOptions(merge: true),
      );
      return Basari(yeniOda);
    } catch (e) {
      return Hata('Sohbet başlatılamadı: $e');
    }
  }
}
