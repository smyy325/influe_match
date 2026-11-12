// Dosya Görevi: Material 3 Koyu Tema Yapılandırması (Dark Theme Data).
// Bu sınıf gece modu için arka plan, kart, buton, giriş kutusu (Input), chip ve AppBar
// bileşenlerinin koyu renk standartlarını ThemeData nesnesi olarak üretir.

import 'package:flutter/material.dart';
import 'renkler.dart';

/// KoyuTema: Koyu tema ThemeData ayarlarını barındıran sınıf.
class KoyuTema {
  /// tema: Material 3 koyu tema konfigürasyonunu döndüren statik getter.
  static ThemeData get tema {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: UygulamaRenkleri.koyuArkaPlan,
      primaryColor: UygulamaRenkleri.anaMor,
      colorScheme: const ColorScheme.dark(
        primary: UygulamaRenkleri.anaMor,
        secondary: UygulamaRenkleri.pembe,
        surface: UygulamaRenkleri.koyuYuzey,
        error: UygulamaRenkleri.mercan,
      ),
      // Üst Çubuk (AppBar) Stili
      appBarTheme: const AppBarTheme(
        backgroundColor: UygulamaRenkleri.koyuArkaPlan,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          letterSpacing: -0.5,
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      // Kart Bileşeni Stili
      cardTheme: CardThemeData(
        color: UygulamaRenkleri.koyuKart,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: UygulamaRenkleri.koyuKenarlik, width: 1),
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
          foregroundColor: Colors.white,
          side: const BorderSide(color: UygulamaRenkleri.koyuKenarlik),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      // Metin Giriş Kutusu (TextField) Stili
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: UygulamaRenkleri.koyuYuzey,
        hintStyle: const TextStyle(color: UygulamaRenkleri.metinGri, fontSize: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: UygulamaRenkleri.koyuKenarlik),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: UygulamaRenkleri.koyuKenarlik),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: UygulamaRenkleri.anaMor, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      // Kategori Çip Stili
      chipTheme: ChipThemeData(
        backgroundColor: UygulamaRenkleri.koyuYuzey,
        selectedColor: UygulamaRenkleri.anaMor.withValues(alpha: 0.25),
        side: const BorderSide(color: UygulamaRenkleri.koyuKenarlik),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        labelStyle: const TextStyle(fontSize: 13, color: Colors.white),
      ),
      // Alt Navigasyon Çubuğu Stili
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: UygulamaRenkleri.koyuYuzey,
        selectedItemColor: UygulamaRenkleri.acikMor,
        unselectedItemColor: UygulamaRenkleri.metinGri,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
    );
  }
}
