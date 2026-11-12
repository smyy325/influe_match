// Dosya Görevi: Tip Güvenli Sonuc ve Hata Yönetim Sınıfı (Result Pattern).
// Dart 3 mühürlü (sealed) sınıf yapısını kullanarak asenkron veri işlemlerinde
// dönüş değerinin 'Basari' veya 'Hata' olmasını zorunlu kılar, null hatalarını önler.

// Sonuc: Tüm başarılı veya hatalı işlem sonuçlarının türediği soyut mühürlü sınıf.
sealed class Sonuc<T> {
  const Sonuc();
}

// Basari: İşlemin sorunsuz tamamlandığını ve jenerik T veri tipini taşıdığını belirten sınıf.
class Basari<T> extends Sonuc<T> {
  final T veri;
  const Basari(this.veri);
}

// Hata: İşlem sırasında bir sorun çıktığını, Türkçe mesajı ve isteğe bağlı hata detayını taşıyan sınıf.
class Hata<T> extends Sonuc<T> {
  final String mesaj;
  final dynamic hataDetayi;
  const Hata(this.mesaj, [this.hataDetayi]);
}
