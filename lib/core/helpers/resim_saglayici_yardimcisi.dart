import 'dart:convert';
import 'package:flutter/material.dart';

class ResimSaglayiciYardimcisi {
  static ImageProvider? saglayici(String? url) {
    if (url == null || url.trim().isEmpty) return null;
    final temiz = url.trim();

    if (temiz.startsWith('data:image')) {
      try {
        final comma = temiz.indexOf(',');
        final b64 = comma != -1 ? temiz.substring(comma + 1) : temiz;
        return MemoryImage(base64Decode(b64));
      } catch (_) {
        return null;
      }
    }

    if (temiz.startsWith('http://') || temiz.startsWith('https://')) {
      return NetworkImage(temiz);
    }

    if (temiz.length > 100 && !temiz.contains(' ') && !temiz.startsWith('/')) {
      try {
        return MemoryImage(base64Decode(temiz));
      } catch (_) {
        return null;
      }
    }

    return null;
  }

  static bool gecerliMi(String? url) => saglayici(url) != null;
}
