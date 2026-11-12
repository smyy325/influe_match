// Dosya Görevi: Kullanıcı Veri Modeli (User Data Model).
// Bu sınıf, platformdaki Marka ve Influencer kullanıcılarının profillerini,
// rolünü, tercihlerini ve iletişim bilgilerini temsil eden değişmez (Immutable) veri nesnesidir.

import 'package:equatable/equatable.dart';

/// Rol: Kullanıcının platformdaki yetki ve ekran görünümünü belirleyen rol sabiti enum'u.
enum Rol { marka, influencer }

/// KullaniciModeli: Kullanıcı verilerini tutan ve Equatable ile eşitlik kıyaslaması yapılan model sınıfı.
class KullaniciModeli extends Equatable {
  final String id;
  final String adSoyad;
  final String email;
  final Rol rol;
  final String profilResmi;
  final String biyografi;
  final String sektorVeyaNis;
  final String takipciSayisi;
  final String konum;
  final String sosyalMedyaHesabi;
  final String telefon;
  final bool dogrulanmis;
  final List<String> tercihler;

  /// Kurucu Metod (Constructor): Kullanıcı modelini varsayılan değerlerle ilklendirir.
  const KullaniciModeli({
    required this.id,
    required this.adSoyad,
    required this.email,
    required this.rol,
    this.profilResmi = '',
    this.biyografi = '',
    this.sektorVeyaNis = 'Genel & Yaşam Tarzı',
    this.takipciSayisi = '10K+',
    this.konum = 'İstanbul, TR',
    this.sosyalMedyaHesabi = '@influematch',
    this.telefon = '',
    this.dogrulanmis = false,
    this.tercihler = const [],
  });

  /// markaMi: Kullanıcının marka rolünde olup olmadığını dönen yardımcı getter.
  bool get markaMi => rol == Rol.marka;

  /// influencerMi: Kullanıcının içerik üreticisi rolünde olup olmadığını dönen yardımcı getter.
  bool get influencerMi => rol == Rol.influencer;

  /// profilTamamlandiMi: Profil zorunlu alanlarının doldurulup doldurulmadığını kontrol eder.
  bool get profilTamamlandiMi =>
      dogrulanmis || (adSoyad.trim().isNotEmpty && email.trim().isNotEmpty && telefon.trim().isNotEmpty);

  /// copyWith(): Mevcut nesnenin kopyasını alarak sadece değişen alanları güncellemeye yarayan metod.
  KullaniciModeli copyWith({
    String? id,
    String? adSoyad,
    String? email,
    Rol? rol,
    String? profilResmi,
    String? biyografi,
    String? sektorVeyaNis,
    String? takipciSayisi,
    String? konum,
    String? sosyalMedyaHesabi,
    String? telefon,
    bool? dogrulanmis,
    List<String>? tercihler,
  }) {
    return KullaniciModeli(
      id: id ?? this.id,
      adSoyad: adSoyad ?? this.adSoyad,
      email: email ?? this.email,
      rol: rol ?? this.rol,
      profilResmi: profilResmi ?? this.profilResmi,
      biyografi: biyografi ?? this.biyografi,
      sektorVeyaNis: sektorVeyaNis ?? this.sektorVeyaNis,
      takipciSayisi: takipciSayisi ?? this.takipciSayisi,
      konum: konum ?? this.konum,
      sosyalMedyaHesabi: sosyalMedyaHesabi ?? this.sosyalMedyaHesabi,
      telefon: telefon ?? this.telefon,
      dogrulanmis: dogrulanmis ?? this.dogrulanmis,
      tercihler: tercihler ?? this.tercihler,
    );
  }

  /// toMap(): Kullanıcı modelini Firestore/JSON formatına (Map<String, dynamic>) dönüştürür.
  Map<String, dynamic> toMap() => {
        'id': id,
        'adSoyad': adSoyad,
        'email': email,
        'rol': rol.name,
        'profilResmi': profilResmi,
        'biyografi': biyografi,
        'sektorVeyaNis': sektorVeyaNis,
        'takipciSayisi': takipciSayisi,
        'konum': konum,
        'sosyalMedyaHesabi': sosyalMedyaHesabi,
        'telefon': telefon,
        'dogrulanmis': dogrulanmis,
        'tercihler': tercihler,
      };

  /// fromMap(): Firestore/JSON Map verisinden KullaniciModeli nesnesi oluşturan fabrika (factory) metodu.
  factory KullaniciModeli.fromMap(Map<String, dynamic> map) {
    return KullaniciModeli(
      id: map['id'] ?? '',
      adSoyad: map['adSoyad'] ?? '',
      email: map['email'] ?? '',
      rol: map['rol'] == 'marka' ? Rol.marka : Rol.influencer,
      profilResmi: map['profilResmi'] ?? '',
      biyografi: map['biyografi'] ?? '',
      sektorVeyaNis: map['sektorVeyaNis'] ?? 'Genel',
      takipciSayisi: map['takipciSayisi'] ?? '10K+',
      konum: map['konum'] ?? 'İstanbul, TR',
      sosyalMedyaHesabi: map['sosyalMedyaHesabi'] ?? '@kullanici',
      telefon: map['telefon'] ?? '',
      dogrulanmis: map['dogrulanmis'] ?? false,
      tercihler: List<String>.from(map['tercihler'] ?? []),
    );
  }

  /// props: Equatable eşitlik kontrolünde kıyaslanacak alan değişkenlerinin listesi.
  @override
  List<Object?> get props => [
        id,
        adSoyad,
        email,
        rol,
        profilResmi,
        biyografi,
        sektorVeyaNis,
        takipciSayisi,
        konum,
        sosyalMedyaHesabi,
        telefon,
        dogrulanmis,
        tercihler,
      ];
}
