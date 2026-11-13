import 'dart:async';
import '../../../core/error/sonuc.dart';
import '../models/basvuru_modeli.dart';
import '../models/ilan_modeli.dart';
import 'kategori_filtre_yardimcisi.dart';

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

class SahteIlanDeposu implements IIlanDeposu {
  final _ilanlarKontrolcu = StreamController<List<IlanModeli>>.broadcast();

  final List<IlanModeli> _ilanlar = [];
  final List<BasvuruModeli> _basvurular = [];

  @override
  Stream<List<IlanModeli>> tumIlanlariIzle() {
    Future.microtask(() => _ilanlarKontrolcu.add(List.unmodifiable(_ilanlar)));
    return _ilanlarKontrolcu.stream;
  }

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

  @override
  Future<Sonuc<IlanModeli>> ilanOlustur(IlanModeli ilan) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _ilanlar.insert(0, ilan);
    _ilanlarKontrolcu.add(List.unmodifiable(_ilanlar));
    return Basari(ilan);
  }

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

  @override
  Future<Sonuc<void>> ilaniSil(String ilanId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _ilanlar.removeWhere((i) => i.id == ilanId);
    _ilanlarKontrolcu.add(List.unmodifiable(_ilanlar));
    return const Basari(null);
  }

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

  @override
  Future<Sonuc<List<BasvuruModeli>>> basvurulariGetir({String? influencerId, String? markaId}) async {
    await Future.delayed(const Duration(milliseconds: 150));
    var sonuc = List<BasvuruModeli>.from(_basvurular);
    if (influencerId != null) {
      sonuc = sonuc.where((b) => b.influencerId == influencerId).toList();
    }
    return Basari(sonuc);
  }

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
