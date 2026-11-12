import 'package:flutter/material.dart';
import '../../kimlik/model/kullanici_modeli.dart';

class ProfilFormYoneticisi {
  final adSoyadKontrolcu = TextEditingController();
  final emailKontrolcu = TextEditingController();
  final telefonKontrolcu = TextEditingController();
  final konumKontrolcu = TextEditingController();
  final biyografiKontrolcu = TextEditingController();
  final sosyalMedyaKontrolcu = TextEditingController();
  List<String> seciliTercihler = [];

  void alanlariDoldur(KullaniciModeli k) {
    adSoyadKontrolcu.text = k.adSoyad;
    emailKontrolcu.text = k.email;
    telefonKontrolcu.text = k.telefon;
    konumKontrolcu.text = k.konum;
    biyografiKontrolcu.text = k.biyografi;
    sosyalMedyaKontrolcu.text = k.sosyalMedyaHesabi;
    seciliTercihler = List<String>.from(k.tercihler);
  }

  void tercihDegistir(String kat) {
    if (seciliTercihler.contains(kat)) {
      seciliTercihler.remove(kat);
    } else {
      seciliTercihler.add(kat);
    }
  }

  KullaniciModeli guncelKullanici(KullaniciModeli mevcut, String profilResmi) {
    return mevcut.copyWith(
      profilResmi: profilResmi.isNotEmpty ? profilResmi : mevcut.profilResmi,
      adSoyad: adSoyadKontrolcu.text.trim(),
      email: emailKontrolcu.text.trim(),
      telefon: telefonKontrolcu.text.trim(),
      konum: konumKontrolcu.text.trim(),
      biyografi: biyografiKontrolcu.text.trim(),
      sosyalMedyaHesabi: sosyalMedyaKontrolcu.text.trim(),
      tercihler: mevcut.influencerMi ? seciliTercihler : const [],
      dogrulanmis: true,
    );
  }

  void dispose() {
    adSoyadKontrolcu.dispose();
    emailKontrolcu.dispose();
    telefonKontrolcu.dispose();
    konumKontrolcu.dispose();
    biyografiKontrolcu.dispose();
    sosyalMedyaKontrolcu.dispose();
  }
}
