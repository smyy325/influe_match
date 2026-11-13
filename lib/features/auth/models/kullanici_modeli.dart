import 'package:equatable/equatable.dart';

enum Rol { marka, influencer }

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

  bool get markaMi => rol == Rol.marka;

  bool get influencerMi => rol == Rol.influencer;

  bool get profilTamamlandiMi =>
      dogrulanmis || (adSoyad.trim().isNotEmpty && email.trim().isNotEmpty && telefon.trim().isNotEmpty);

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
