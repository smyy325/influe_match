import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/error/sonuc.dart';
import '../models/basvuru_modeli.dart';
import '../models/ilan_modeli.dart';
import 'firebase_basvuru_yardimcisi.dart';
import 'ilan_deposu.dart';
import 'kategori_filtre_yardimcisi.dart';

class FirebaseIlanDeposu implements IIlanDeposu {
  final FirebaseFirestore _firestore;
  late final FirebaseBasvuruYardimcisi _basvuruYardimcisi;

  FirebaseIlanDeposu({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance {
    _basvuruYardimcisi = FirebaseBasvuruYardimcisi(_firestore);
  }

  CollectionReference<Map<String, dynamic>> get _ilanlarRef =>
      _firestore.collection('ilanlar');

  @override
  Stream<List<IlanModeli>> tumIlanlariIzle() {
    return _ilanlarRef
        .orderBy('olusturulmaTarihi', descending: true)
        .snapshots()
        .handleError((_) {})
        .map((snapshot) => snapshot.docs.map((doc) {
              final data = doc.data();
              data['id'] = doc.id;
              return IlanModeli.fromMap(data);
            }).toList());
  }

  @override
  Future<Sonuc<List<IlanModeli>>> ilanlariGetir({String? kategori, String? aramaKelimesi, String? markaId}) async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot;
      try {
        Query<Map<String, dynamic>> q = _ilanlarRef;
        if (markaId != null && markaId.isNotEmpty) {
          q = q.where('markaId', isEqualTo: markaId);
        }
        snapshot = await q.get().timeout(const Duration(seconds: 4));
      } catch (_) {
        snapshot = await _ilanlarRef.get().timeout(const Duration(seconds: 4));
      }

      var ilanlar = snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return IlanModeli.fromMap(data);
      }).toList();

      if (markaId != null && markaId.isNotEmpty) {
        ilanlar = ilanlar.where((i) => i.markaId == markaId).toList();
      }

      if (kategori != null && kategori != 'Tümü' && kategori.isNotEmpty) {
        ilanlar = ilanlar.where((i) => KategoriFiltreYardimcisi.eslesiyor(i.kategori, kategori)).toList();
      }

      if (aramaKelimesi != null && aramaKelimesi.trim().isNotEmpty) {
        final q = aramaKelimesi.toLowerCase();
        ilanlar = ilanlar.where((i) =>
            i.baslik.toLowerCase().contains(q) ||
            i.aciklama.toLowerCase().contains(q) ||
            i.markaAdi.toLowerCase().contains(q)).toList();
      }

      ilanlar.sort((a, b) => b.olusturulmaTarihi.compareTo(a.olusturulmaTarihi));
      return Basari(ilanlar);
    } catch (e) {
      return Basari(const <IlanModeli>[]);
    }
  }

  @override
  Future<Sonuc<IlanModeli>> ilanGetir(String ilanId) async {
    try {
      final doc = await _ilanlarRef.doc(ilanId).get().timeout(const Duration(seconds: 3));
      if (!doc.exists || doc.data() == null) return const Hata('İlan bulunamadı.');
      final data = doc.data()!;
      data['id'] = doc.id;
      return Basari(IlanModeli.fromMap(data));
    } catch (e) {
      return Hata('İlan getirilemedi: $e');
    }
  }

  @override
  Future<Sonuc<IlanModeli>> ilanOlustur(IlanModeli ilan) async {
    try {
      await _ilanlarRef.doc(ilan.id).set(ilan.toMap()).timeout(const Duration(seconds: 3));
      return Basari(ilan);
    } catch (e) {
      return Hata('İlan oluşturulamadı: $e');
    }
  }

  @override
  Future<Sonuc<IlanModeli>> ilanGuncelle(IlanModeli ilan) async {
    try {
      await _ilanlarRef.doc(ilan.id).update(ilan.toMap()).timeout(const Duration(seconds: 3));
      return Basari(ilan);
    } catch (e) {
      return Hata('İlan güncellenemedi: $e');
    }
  }

  @override
  Future<Sonuc<void>> ilaniSil(String ilanId) async {
    try {
      await _ilanlarRef.doc(ilanId).delete().timeout(const Duration(seconds: 3));
      return const Basari(null);
    } catch (e) {
      return Hata('İlan silinemedi: $e');
    }
  }

  @override
  Future<Sonuc<BasvuruModeli>> ilanaBasvur(BasvuruModeli basvuru) =>
      _basvuruYardimcisi.ilanaBasvur(basvuru, _ilanlarRef);

  @override
  Future<Sonuc<List<BasvuruModeli>>> basvurulariGetir({String? influencerId, String? markaId}) =>
      _basvuruYardimcisi.basvurulariGetir(influencerId: influencerId, markaId: markaId);

  @override
  Future<Sonuc<BasvuruModeli>> basvuruDurumuDegistir(String basvuruId, BasvuruDurumu yeniDurum, {BasvuruModeli? basvuru}) =>
      _basvuruYardimcisi.basvuruDurumuDegistir(basvuruId, yeniDurum, basvuru: basvuru);
}
