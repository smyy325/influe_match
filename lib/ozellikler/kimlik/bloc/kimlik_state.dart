// Dosya Görevi: Kimlik Doğrulama ve Oturum Durumları (States).
// BLoC tarafında işlenen olayların (Events) sonucunda kullanıcı arayüzüne (UI)
// aktarılan ve ekranın görünümünü belirleyen durum sınıflarıdır.

import 'package:equatable/equatable.dart';
import '../model/kullanici_modeli.dart';

/// KimlikState: Tüm kimlik durumlarının türediği mühürlü (sealed) taban durum sınıfı.
sealed class KimlikState extends Equatable {
  const KimlikState();
  @override
  List<Object?> get props => [];
}

/// KimlikBaslangic: BLoC ilk oluşturulduğundaki henüz hiçbir işlemin başlamadığı ilk durum.
class KimlikBaslangic extends KimlikState {}

/// KimlikYukleniyor: Oturum açma, kayıt olma vb. asenkron işlemler devam ederken gösterilen yüklenme durumu.
class KimlikYukleniyor extends KimlikState {}

/// KimlikDogrulandi: Kullanıcının başarıyla oturum açtığını ve aktif kullanıcı verisini tutan durum.
class KimlikDogrulandi extends KimlikState {
  final KullaniciModeli kullanici;
  const KimlikDogrulandi(this.kullanici);

  @override
  List<Object?> get props => [kullanici];
}

/// KimlikDogrulanmadi: Oturum açmış geçerli bir kullanıcının olmadığını belirten durum (Giriş ekranı açılır).
class KimlikDogrulanmadi extends KimlikState {}

/// KimlikHatasi: Oturum işlemleri esnasında bir hata oluştuğunda hata mesajını taşıyan durum.
class KimlikHatasi extends KimlikState {
  final String mesaj;
  const KimlikHatasi(this.mesaj);

  @override
  List<Object?> get props => [mesaj];
}

/// SifreSifirlamaEpostasiGonderildi: Şifre sıfırlama bağlantısının başarıyla iletildiğini belirten durum.
class SifreSifirlamaEpostasiGonderildi extends KimlikState {
  final String mesaj;
  const SifreSifirlamaEpostasiGonderildi(this.mesaj);

  @override
  List<Object?> get props => [mesaj];
}
