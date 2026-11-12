class KategoriFiltreYardimcisi {
  static bool eslesiyor(String ilanKategori, String? seciliKategori) {
    if (seciliKategori == null || seciliKategori.isEmpty || seciliKategori == 'Tümü') {
      return true;
    }
    final k1 = _normalize(ilanKategori);
    final k2 = _normalize(seciliKategori);
    if (k1 == k2) return true;
    if (k1.contains(k2) || k2.contains(k1)) return true;
    return false;
  }

  static String _normalize(String s) {
    return s
        .toLowerCase()
        .replaceAll('&', 've')
        .replaceAll('_', '')
        .replaceAll('-', '')
        .replaceAll(' ', '')
        .replaceAll('ı', 'i')
        .replaceAll('ğ', 'g')
        .replaceAll('ü', 'u')
        .replaceAll('ş', 's')
        .replaceAll('ö', 'o')
        .replaceAll('ç', 'c');
  }
}

