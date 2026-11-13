import 'package:flutter/material.dart';
import 'renkler.dart';

class KoyuTema {
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
      cardTheme: CardThemeData(
        color: UygulamaRenkleri.koyuKart,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: UygulamaRenkleri.koyuKenarlik, width: 1),
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
          foregroundColor: Colors.white,
          side: const BorderSide(color: UygulamaRenkleri.koyuKenarlik),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
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
      chipTheme: ChipThemeData(
        backgroundColor: UygulamaRenkleri.koyuYuzey,
        selectedColor: UygulamaRenkleri.anaMor.withValues(alpha: 0.25),
        side: const BorderSide(color: UygulamaRenkleri.koyuKenarlik),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        labelStyle: const TextStyle(fontSize: 13, color: Colors.white),
      ),
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
