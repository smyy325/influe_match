import 'dart:async';
import '../../../core/error/sonuc.dart';
import '../models/mesaj_modeli.dart';
import '../models/sohbet_odasi_modeli.dart';

abstract class ISohbetDeposu {
  Future<Sonuc<List<SohbetOdasiModeli>>> sohbetOdalariniGetir(String kullaniciId);
  Stream<List<SohbetOdasiModeli>> sohbetOdalariniIzle(String kullaniciId);
  Stream<List<MesajModeli>> mesajlariIzle(String sohbetId);
  Future<Sonuc<MesajModeli>> mesajGonder(MesajModeli mesaj);
  Future<Sonuc<SohbetOdasiModeli>> sohbetOlusturVeyaGetir({
    required String ilanId,
    required String ilanBasligi,
    required String karsiTarafId,
    required String karsiTarafAdi,
    required String karsiTarafProfil,
    required String karsiTarafRol,
    required String mevcutKullaniciId,
  });
}

class SahteSohbetDeposu implements ISohbetDeposu {
  final Map<String, StreamController<List<MesajModeli>>> _mesajKontrolculeri = {};
  final List<SohbetOdasiModeli> _odalar = [];
  final Map<String, List<MesajModeli>> _mesajlar = {};

  @override
  Future<Sonuc<List<SohbetOdasiModeli>>> sohbetOdalariniGetir(String kullaniciId) async {
    await Future.delayed(const Duration(milliseconds: 150));
    final kullaniciOdalari = _odalar
        .where((o) => o.katilimciIds.contains(kullaniciId))
        .toList();
    return Basari(kullaniciOdalari);
  }

  @override
  Stream<List<SohbetOdasiModeli>> sohbetOdalariniIzle(String kullaniciId) {
    return Stream.value(_odalar.where((o) => o.katilimciIds.contains(kullaniciId)).toList());
  }

  @override
  Stream<List<MesajModeli>> mesajlariIzle(String sohbetId) {
    if (!_mesajKontrolculeri.containsKey(sohbetId)) {
      _mesajKontrolculeri[sohbetId] = StreamController<List<MesajModeli>>.broadcast();
    }
    final kontrolcu = _mesajKontrolculeri[sohbetId]!;
    final mevcutMesajlar = _mesajlar[sohbetId] ?? [];
    Future.microtask(() => kontrolcu.add(List.unmodifiable(mevcutMesajlar)));
    return kontrolcu.stream;
  }

  @override
  Future<Sonuc<MesajModeli>> mesajGonder(MesajModeli mesaj) async {
    await Future.delayed(const Duration(milliseconds: 100));
    if (!_mesajlar.containsKey(mesaj.sohbetId)) {
      _mesajlar[mesaj.sohbetId] = [];
    }
    _mesajlar[mesaj.sohbetId]!.add(mesaj);

    final odaIndex = _odalar.indexWhere((o) => o.id == mesaj.sohbetId);
    if (odaIndex != -1) {
      _odalar[odaIndex] = _odalar[odaIndex].copyWith(
        sonMesaj: mesaj.icerik,
        sonMesajZamani: mesaj.zaman,
      );
    }

    if (_mesajKontrolculeri.containsKey(mesaj.sohbetId)) {
      _mesajKontrolculeri[mesaj.sohbetId]!.add(List.unmodifiable(_mesajlar[mesaj.sohbetId]!));
    }

    return Basari(mesaj);
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
    final varOlan = _odalar.where((o) =>
        o.ilanId == ilanId &&
        o.katilimciIds.contains(karsiTarafId) &&
        o.katilimciIds.contains(mevcutKullaniciId));

    if (varOlan.isNotEmpty) {
      return Basari(varOlan.first);
    }

    final yeniOda = SohbetOdasiModeli(
      id: 'sohbet_${DateTime.now().millisecondsSinceEpoch}',
      ilanId: ilanId,
      ilanBasligi: ilanBasligi,
      katilimciIds: [mevcutKullaniciId, karsiTarafId],
      karsiTarafId: karsiTarafId,
      karsiTarafAdi: karsiTarafAdi,
      karsiTarafProfil: karsiTarafProfil,
      karsiTarafRol: karsiTarafRol,
      sonMesaj: 'Sohbet başlatıldı.',
      sonMesajZamani: DateTime.now(),
    );

    _odalar.insert(0, yeniOda);
    _mesajlar[yeniOda.id] = [];

    return Basari(yeniOda);
  }
}
