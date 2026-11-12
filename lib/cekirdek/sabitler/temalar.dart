// Dosya Görevi: Uygulama Tema Sağlayıcısı (Theme Provider).
// Açık ve koyu ThemeData yapılandırmalarını dışarıya sunan statik köprü sınıfı.

import 'package:flutter/material.dart';
import 'acik_tema.dart';
import 'koyu_tema.dart';

/// UygulamaTemasi: AcikTema ve KoyuTema sınıflarından ThemeData alarak MaterialApp'e bağlar.
class UygulamaTemasi {
  /// koyuTema: Material 3 Koyu tema ayarlarını döndürür.
  static ThemeData get koyuTema => KoyuTema.tema;

  /// acikTema: Material 3 Açık tema ayarlarını döndürür.
  static ThemeData get acikTema => AcikTema.tema;
}
