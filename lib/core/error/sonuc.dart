sealed class Sonuc<T> {
  const Sonuc();
}

class Basari<T> extends Sonuc<T> {
  final T veri;
  const Basari(this.veri);
}

class Hata<T> extends Sonuc<T> {
  final String mesaj;
  final dynamic hataDetayi;
  const Hata(this.mesaj, [this.hataDetayi]);
}
