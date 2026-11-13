import 'package:flutter/material.dart';
import 'renkler.dart';

class AcikTema {
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
      cardTheme: CardThemeData(
        color: UygulamaRenkleri.acikYuzey,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: UygulamaRenkleri.acikKenarlik, width: 1),
        ),
      ),
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
      chipTheme: ChipThemeData(
        backgroundColor: UygulamaRenkleri.acikYuzey,
        selectedColor: UygulamaRenkleri.anaMor.withValues(alpha: 0.15),
        side: const BorderSide(color: UygulamaRenkleri.acikKenarlik),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        labelStyle: const TextStyle(fontSize: 13, color: UygulamaRenkleri.metinKoyu),
      ),
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
