import 'package:flutter/material.dart';

class UygulamaRenkleri {
  static const Color anaMor = Color(0xFF6C5CE7);
  static const Color acikMor = Color(0xFFA29BFE);
  static const Color koyuMor = Color(0xFF4834D4);

  static const Color mercan = Color(0xFFFF7675);
  static const Color pembe = Color(0xFFFD79A8);
  static const Color naneYesili = Color(0xFF00B894);
  static const Color sariVurgu = Color(0xFFFDCB6E);

  static const Color koyuArkaPlan = Color(0xFF0F111A);
  static const Color koyuYuzey = Color(0xFF1A1D2E);
  static const Color koyuKart = Color(0xFF22263B);
  static const Color koyuKenarlik = Color(0xFF2E344D);

  static const Color acikArkaPlan = Color(0xFFF8F9FE);
  static const Color acikYuzey = Color(0xFFFFFFFF);
  static const Color acikKenarlik = Color(0xFFE2E8F0);

  static const Color metinBeyaz = Color(0xFFFFFFFF);
  static const Color metinGri = Color(0xFF94A3B8);
  static const Color metinKoyu = Color(0xFF1E293B);

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
