// Dosya Görevi: Material 3 Açık Tema Yapılandırması (Light Theme Data).
// Bu sınıf gündüz modu için arka plan, kart, buton, giriş kutusu (Input), chip ve AppBar
// bileşenlerinin stil ve renk standartlarını ThemeData nesnesi olarak üretir.

import 'package:flutter/material.dart';
import 'renkler.dart';

/// AcikTema: Açık tema ThemeData ayarlarını barındıran sınıf.
class AcikTema {
  /// tema: Material 3 açık tema konfigürasyonunu döndüren statik getter.
  static ThemeData get tema {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: UygulamaRenkleri.acikArkaPlan,
      primaryColor: UygulamaRenkleri.anaMor,
      colorScheme: const ColorScheme.light(
        primary: UygulamaRenkleri.anaMor,
        secondary: UygulamaRenkleri.pembe,
        surface: UygulamaRenkleri.acikYuzey,
        error: UygulamaRenkleri.mercan,
      ),
      // Üst Çubuk (AppBar) Stili
      appBarTheme: const AppBarTheme(
        backgroundColor: UygulamaRenkleri.acikArkaPlan,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: UygulamaRenkleri.metinKoyu,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          letterSpacing: -0.5,
        ),
        iconTheme: IconThemeData(color: UygulamaRenkleri.metinKoyu),
      ),
      // Kart Bileşeni Stili
      cardTheme: CardThemeData(
        color: UygulamaRenkleri.acikYuzey,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: UygulamaRenkleri.acikKenarlik, width: 1),
        ),
      ),
      // Dolgulu Buton Stili
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: UygulamaRenkleri.anaMor,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      // Çerçeveli Buton Stili
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: UygulamaRenkleri.metinKoyu,
          side: const BorderSide(color: UygulamaRenkleri.acikKenarlik),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      // Metin Giriş Kutusu (TextField) Stili
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: UygulamaRenkleri.acikYuzey,
        hintStyle: const TextStyle(color: UygulamaRenkleri.metinGri, fontSize: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: UygulamaRenkleri.acikKenarlik),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: UygulamaRenkleri.acikKenarlik),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: UygulamaRenkleri.anaMor, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      // Kategori Çip Stili
      chipTheme: ChipThemeData(
        backgroundColor: UygulamaRenkleri.acikYuzey,
        selectedColor: UygulamaRenkleri.anaMor.withValues(alpha: 0.15),
        side: const BorderSide(color: UygulamaRenkleri.acikKenarlik),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        labelStyle: const TextStyle(fontSize: 13, color: UygulamaRenkleri.metinKoyu),
      ),
      // Alt Navigasyon Çubuğu Stili
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: UygulamaRenkleri.acikYuzey,
        selectedItemColor: UygulamaRenkleri.anaMor,
        unselectedItemColor: UygulamaRenkleri.metinGri,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
    );
  }
}
