// Dosya Görevi: İlan ve Başvuru Depo Arayüzü (Repository Interface) ve Sahte (Mock) İlan Deposu.
// IIlanDeposu arayüzü ilan ekleme, listeleme, silme, canlı izleme ve başvurma metodlarını tanımlar.
// SahteIlanDeposu sınıfı ise Firebase olmadan yerel hafızadaki sahte ilan ve başvurularla çalışmayı sağlar.

import 'dart:async';
import '../../../cekirdek/hata/sonuc.dart';
import '../model/basvuru_modeli.dart';
import '../model/ilan_modeli.dart';
import 'kategori_filtre_yardimcisi.dart';

/// IIlanDeposu: İlan veri işlemleri için soyut kontrat arayüzü.
abstract class IIlanDeposu {
  Stream<List<IlanModeli>> tumIlanlariIzle();
  Future<Sonuc<List<IlanModeli>>> ilanlariGetir({String? kategori, String? aramaKelimesi, String? markaId});
  Future<Sonuc<IlanModeli>> ilanGetir(String ilanId);
  Future<Sonuc<IlanModeli>> ilanOlustur(IlanModeli ilan);
  Future<Sonuc<IlanModeli>> ilanGuncelle(IlanModeli ilan);
  Future<Sonuc<void>> ilaniSil(String ilanId);
  Future<Sonuc<BasvuruModeli>> ilanaBasvur(BasvuruModeli basvuru);
  Future<Sonuc<List<BasvuruModeli>>> basvurulariGetir({String? influencerId, String? markaId});
  Future<Sonuc<BasvuruModeli>> basvuruDurumuDegistir(String basvuruId, BasvuruDurumu yeniDurum, {BasvuruModeli? basvuru});
}

/// SahteIlanDeposu: Testler ve çevrim dışı çalışma durumunda sahte veri sağlayan depo uygulaması.
class SahteIlanDeposu implements IIlanDeposu {
  // İlan güncellemelerini yayınlayan canlı akış denetleyicisi.
  final _ilanlarKontrolcu = StreamController<List<IlanModeli>>.broadcast();

  // Yerel hafızadaki sahte ilan ve başvuru listeleri.
  final List<IlanModeli> _ilanlar = [];
  final List<BasvuruModeli> _basvurular = [];

  /// tumIlanlariIzle(): Yerel ilan listesini canlı yayın akışı (Stream) olarak sunar.
  @override
  Stream<List<IlanModeli>> tumIlanlariIzle() {
    Future.microtask(() => _ilanlarKontrolcu.add(List.unmodifiable(_ilanlar)));
    return _ilanlarKontrolcu.stream;
  }

  /// ilanlariGetir(): Filtre parametrelerine göre sahte ilan listesini filtreleyerek döner.
  @override
  Future<Sonuc<List<IlanModeli>>> ilanlariGetir({String? kategori, String? aramaKelimesi, String? markaId}) async {
    await Future.delayed(const Duration(milliseconds: 150));
    var sonuc = List<IlanModeli>.from(_ilanlar);

    if (markaId != null && markaId.isNotEmpty) {
      sonuc = sonuc.where((i) => i.markaId == markaId).toList();
    }

    if (kategori != null && kategori != 'Tümü' && kategori.isNotEmpty) {
      sonuc = sonuc.where((i) => KategoriFiltreYardimcisi.eslesiyor(i.kategori, kategori)).toList();
    }

    if (aramaKelimesi != null && aramaKelimesi.trim().isNotEmpty) {
      final q = aramaKelimesi.toLowerCase();
      sonuc = sonuc.where((i) =>
          i.baslik.toLowerCase().contains(q) ||
          i.aciklama.toLowerCase().contains(q) ||
          i.markaAdi.toLowerCase().contains(q)).toList();
    }

    return Basari(sonuc);
  }

  /// ilanGetir(): Kimliğe göre tek bir sahte ilanı getirir.
  @override
  Future<Sonuc<IlanModeli>> ilanGetir(String ilanId) async {
    await Future.delayed(const Duration(milliseconds: 100));
    try {
      final ilan = _ilanlar.firstWhere((i) => i.id == ilanId);
      return Basari(ilan);
    } catch (e) {
      return const Hata('İlan bulunamadı.');
    }
  }

  /// ilanOlustur(): Yeni sahte ilanı yerel listenin başına ekler.
  @override
  Future<Sonuc<IlanModeli>> ilanOlustur(IlanModeli ilan) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _ilanlar.insert(0, ilan);
    _ilanlarKontrolcu.add(List.unmodifiable(_ilanlar));
    return Basari(ilan);
  }

  /// ilanGuncelle(): Sahte ilan bilgilerini yeniler.
  @override
  Future<Sonuc<IlanModeli>> ilanGuncelle(IlanModeli guncelIlan) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final index = _ilanlar.indexWhere((i) => i.id == guncelIlan.id);
    if (index != -1) {
      _ilanlar[index] = guncelIlan;
      _ilanlarKontrolcu.add(List.unmodifiable(_ilanlar));
      return Basari(guncelIlan);
    }
    return const Hata('Güncellenecek ilan bulunamadı.');
  }

  /// ilaniSil(): Sahte ilanı listeden siler.
  @override
  Future<Sonuc<void>> ilaniSil(String ilanId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _ilanlar.removeWhere((i) => i.id == ilanId);
    _ilanlarKontrolcu.add(List.unmodifiable(_ilanlar));
    return const Basari(null);
  }

  /// ilanaBasvur(): İlana yeni bir başvuru veya ret kararı kaydeder.
  @override
  Future<Sonuc<BasvuruModeli>> ilanaBasvur(BasvuruModeli basvuru) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final ilanIndex = _ilanlar.indexWhere((i) => i.id == basvuru.ilanId);
    if (ilanIndex != -1) {
      final mevcutIlan = _ilanlar[ilanIndex];
      if (mevcutIlan.basvuranInfluencerIds.contains(basvuru.influencerId)) {
        return const Hata('Bu ilana zaten başvuru yaptınız.');
      }
      final guncelList = List<String>.from(mevcutIlan.basvuranInfluencerIds)..add(basvuru.influencerId);
      _ilanlar[ilanIndex] = mevcutIlan.copyWith(basvuranInfluencerIds: guncelList);
      _basvurular.insert(0, basvuru);
      _ilanlarKontrolcu.add(List.unmodifiable(_ilanlar));
      return Basari(basvuru);
    }
    return const Hata('İlan bulunamadığı için başvuru alınamadı.');
  }

  /// basvurulariGetir(): Sahte başvuru listesini getirir.
  @override
  Future<Sonuc<List<BasvuruModeli>>> basvurulariGetir({String? influencerId, String? markaId}) async {
    await Future.delayed(const Duration(milliseconds: 150));
    var sonuc = List<BasvuruModeli>.from(_basvurular);
    if (influencerId != null) {
      sonuc = sonuc.where((b) => b.influencerId == influencerId).toList();
    }
    return Basari(sonuc);
  }

  /// basvuruDurumuDegistir(): Başvurunun durumunu (Kabul/Ret) günceller.
  @override
  Future<Sonuc<BasvuruModeli>> basvuruDurumuDegistir(String basvuruId, BasvuruDurumu yeniDurum, {BasvuruModeli? basvuru}) async {
    await Future.delayed(const Duration(milliseconds: 150));
    final index = _basvurular.indexWhere((b) => b.id == basvuruId);
    if (index != -1) {
      final guncel = _basvurular[index].copyWith(durum: yeniDurum);
      _basvurular[index] = guncel;
      return Basari(guncel);
    }
    if (basvuru != null) {
      final guncel = basvuru.copyWith(durum: yeniDurum);
      _basvurular.insert(0, guncel);
      return Basari(guncel);
    }
    return const Hata('Başvuru bulunamadı.');
  }
}
