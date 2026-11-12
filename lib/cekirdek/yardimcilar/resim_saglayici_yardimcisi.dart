// Dosya Görevi: Görsel Sağlayıcı ve Dönüştürücü Yardımcısı (Image Provider Helper).
// Bu sınıf profil fotoğrafları veya marka logoları için URL'in formatını (Base64 data URL,
// ham Base64 string veya HTTP/HTTPS URL) tespit eder ve uygun ImageProvider nesnesini üretir.

import 'dart:convert';
import 'package:flutter/material.dart';

/// ResimSaglayiciYardimcisi: Farklı formatlardaki görsel kaynaklarını dönüştüren yardımcı sınıf.
class ResimSaglayiciYardimcisi {
  /// saglayici(): Verilen String yolunun türüne göre MemoryImage veya NetworkImage döndürür.
  static ImageProvider? saglayici(String? url) {
    if (url == null || url.trim().isEmpty) return null;
    final temiz = url.trim();

    // 1. Durum: Base64 Data URL formatı (ör. data:image/png;base64,...)
    if (temiz.startsWith('data:image')) {
      try {
        final comma = temiz.indexOf(',');
        final b64 = comma != -1 ? temiz.substring(comma + 1) : temiz;
        return MemoryImage(base64Decode(b64));
      } catch (_) {
        return null;
      }
    }

    // 2. Durum: İnternet URL formatı (http veya https)
    if (temiz.startsWith('http://') || temiz.startsWith('https://')) {
      return NetworkImage(temiz);
    }

    // 3. Durum: Ham Base64 karakter dizisi
    if (temiz.length > 100 && !temiz.contains(' ') && !temiz.startsWith('/')) {
      try {
        return MemoryImage(base64Decode(temiz));
      } catch (_) {
        return null;
      }
    }

    return null;
  }

  /// gecerliMi(): Görsel yolunun geçerli bir ImageProvider üretip üretmediğini denetler.
  static bool gecerliMi(String? url) => saglayici(url) != null;
}
