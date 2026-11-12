// Dosya Görevi: Firebase İlan ve Başvuru Deposu (Cloud Firestore Repository).
// Bu sınıf Cloud Firestore üzerindeki 'ilanlar' ve 'basvurular' koleksiyonları ile
// kampanya oluşturma, canlı akış izleme, arama, filtreleme ve başvuru süreçlerini yönetir.

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../cekirdek/hata/sonuc.dart';
import '../model/basvuru_modeli.dart';
import '../model/ilan_modeli.dart';
import 'firebase_basvuru_yardimcisi.dart';
import 'ilan_deposu.dart';
import 'kategori_filtre_yardimcisi.dart';

/// FirebaseIlanDeposu: IIlanDeposu arayüzünü Cloud Firestore ile uygulayan veri deposu sınıfı.
class FirebaseIlanDeposu implements IIlanDeposu {
  final FirebaseFirestore _firestore;
  late final FirebaseBasvuruYardimcisi _basvuruYardimcisi;

  /// Kurucu Metod: Firestore örneğini alır ve başvuru yardımcısını ilklendirir.
  FirebaseIlanDeposu({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance {
    _basvuruYardimcisi = FirebaseBasvuruYardimcisi(_firestore);
  }

  // 'ilanlar' koleksiyon referansı getter'ı.
  CollectionReference<Map<String, dynamic>> get _ilanlarRef =>
      _firestore.collection('ilanlar');

  /// tumIlanlariIzle(): Firestore 'ilanlar' koleksiyonunu anlık canlı yayın (Stream) olarak dinler.
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

  /// ilanlariGetir(): Kategori, arama kelimesi ve marka filtresine göre Firestore ilanlarını çeker.
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

  /// ilanGetir(): Kimliğe göre tek bir ilanı Firestore'dan çeker.
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

  /// ilanOlustur(): Yeni kampanya ilanını Firestore 'ilanlar' koleksiyonuna yazar.
  @override
  Future<Sonuc<IlanModeli>> ilanOlustur(IlanModeli ilan) async {
    try {
      await _ilanlarRef.doc(ilan.id).set(ilan.toMap()).timeout(const Duration(seconds: 3));
      return Basari(ilan);
    } catch (e) {
      return Hata('İlan oluşturulamadı: $e');
    }
  }

  /// ilanGuncelle(): Var olan ilanın bilgilerini Firestore'da günceller.
  @override
  Future<Sonuc<IlanModeli>> ilanGuncelle(IlanModeli ilan) async {
    try {
      await _ilanlarRef.doc(ilan.id).update(ilan.toMap()).timeout(const Duration(seconds: 3));
      return Basari(ilan);
    } catch (e) {
      return Hata('İlan güncellenemedi: $e');
    }
  }

  /// ilaniSil(): İlan belgesini Firestore'dan siler.
  @override
  Future<Sonuc<void>> ilaniSil(String ilanId) async {
    try {
      await _ilanlarRef.doc(ilanId).delete().timeout(const Duration(seconds: 3));
      return const Basari(null);
    } catch (e) {
      return Hata('İlan silinemedi: $e');
    }
  }

  /// ilanaBasvur(): İlana başvuru yapma/reddetme işlemini alt modül üzerinden yürütür.
  @override
  Future<Sonuc<BasvuruModeli>> ilanaBasvur(BasvuruModeli basvuru) =>
      _basvuruYardimcisi.ilanaBasvur(basvuru, _ilanlarRef);

  /// basvurulariGetir(): İlana ait veya kullanıcıya ait başvuruları çeker.
  @override
  Future<Sonuc<List<BasvuruModeli>>> basvurulariGetir({String? influencerId, String? markaId}) =>
      _basvuruYardimcisi.basvurulariGetir(influencerId: influencerId, markaId: markaId);

  /// basvuruDurumuDegistir(): Başvuru kararını (Kabul/Ret) Firestore'da günceller.
  @override
  Future<Sonuc<BasvuruModeli>> basvuruDurumuDegistir(String basvuruId, BasvuruDurumu yeniDurum, {BasvuruModeli? basvuru}) =>
      _basvuruYardimcisi.basvuruDurumuDegistir(basvuruId, yeniDurum, basvuru: basvuru);
}
