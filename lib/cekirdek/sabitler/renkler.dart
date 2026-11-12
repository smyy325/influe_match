// Dosya Görevi: Uygulama Renk Paleti ve Gradyan Sabitleri (App Color Palette).
// Bu sınıf uygulama genelinde kullanılan mor, mercan, nane yeşili, kart ve arka plan
// renk kodlarını ve renk gradyanlarını (LinearGradient) tek noktadan yönetir.

import 'package:flutter/material.dart';

/// UygulamaRenkleri: Tüm renk sabitlerini statik (static const) olarak barındıran sınıf.
class UygulamaRenkleri {
  // Ana Markalama Renkleri (Mor Palet)
  static const Color anaMor = Color(0xFF6C5CE7);
  static const Color acikMor = Color(0xFFA29BFE);
  static const Color koyuMor = Color(0xFF4834D4);

  // Vurgu ve Durum Renkleri (Hata, Onay, Uyarı)
  static const Color mercan = Color(0xFFFF7675);     // Reddet / Hata durumu
  static const Color pembe = Color(0xFFFD79A8);      // İkincil marka vurgusu
  static const Color naneYesili = Color(0xFF00B894); // Kabul / Onay durumu
  static const Color sariVurgu = Color(0xFFFDCB6E);  // VIP Özel İlan / Beklemede

  // Koyu Tema Arka Plan ve Yüzey Renkleri
  static const Color koyuArkaPlan = Color(0xFF0F111A);
  static const Color koyuYuzey = Color(0xFF1A1D2E);
  static const Color koyuKart = Color(0xFF22263B);
  static const Color koyuKenarlik = Color(0xFF2E344D);

  // Açık Tema Arka Plan ve Yüzey Renkleri
  static const Color acikArkaPlan = Color(0xFFF8F9FE);
  static const Color acikYuzey = Color(0xFFFFFFFF);
  static const Color acikKenarlik = Color(0xFFE2E8F0);

  // Metin ve İkon Renkleri
  static const Color metinBeyaz = Color(0xFFFFFFFF);
  static const Color metinGri = Color(0xFF94A3B8);
  static const Color metinKoyu = Color(0xFF1E293B);

  // Doğrusal Renk Geçişleri (Gradyanlar)
  static const LinearGradient morGradyan = LinearGradient(
    colors: [anaMor, pembe],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient kartGradyan = LinearGradient(
    colors: [Color(0xFF232742), Color(0xFF1A1D2E)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
