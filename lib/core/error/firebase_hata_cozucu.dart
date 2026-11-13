class FirebaseHataCozucu {
  static String cevir(String kod, [String? detay]) {
    return switch (kod) {
      'user-not-found' => 'Bu e-posta adresine kayıtlı bir kullanıcı bulunamadı.',
      'wrong-password' => 'Hatalı şifre girdiniz.',
      'email-already-in-use' => 'Bu e-posta adresi zaten kullanımda.',
      'invalid-email' => 'Lütfen geçerli bir e-posta adresi giriniz.',
      'weak-password' => 'Şifreniz çok zayıf. En az 6 karakter kullanın.',
      'network-request-failed' => 'İnternet bağlantınızı kontrol ediniz.',
      'operation-not-allowed' => 'E-posta/Şifre sağlayıcısı etkinleştirilmemiş.',
      'internal-error' => 'Firebase bağlantı veya yapılandırma hatası.',
      'too-many-requests' => 'Çok fazla deneme yapıldı. Lütfen bekleyiniz.',
      _ => 'İşlem sırasında bir hata oluştu ($kod)${detay != null ? ': $detay' : ''}.',
    };
  }
}
