# SKILL: Modern Flutter Clean BLoC Generator (Türkçe)

Bu doküman, **InflueMatch** projesine yeni bir özellik veya modül eklenirken **BLoC/Cubit**, **GetIt**, **Sonuc Modeli (Dart 3 Sealed Classes)**, **Clean Architecture**, **Açık/Koyu Tema Uyumluluğu** ve **150 Satır Sınırı** kurallarına %100 uyumlu kod üretilmesini garanti eden geliştirici yönergesidir.

---

## 1. Temel Mimari Standartları

1. **Katı 150 Satır Sınırı (Hard Constraint):**
   - `lib/` altındaki **hiçbir Dart dosyası 150 satırı aşamaz**.
   - Büyük formlar, diyaloglar veya kartlar `bilesenler/` klasörü altına bağımsız mikro bileşenler olarak ayrıştırılır.
2. **Türkçe Snake_Case İsimlendirme:**
   - Dizin ve dosya adlarında İngilizce veya karma isimlendirme yapılmaz; Türkçe ASCII `snake_case` kullanılır (örn: `ilan_karti.dart`, `kullanici_profil_detay_ekrani.dart`).
3. **Katmanlı Klasör Yapısı (Feature-First):**
   - `model/` (Veri ve Varlık Modelleri, Equatable)
   - `depo/` (Repository arayüzü ve Firebase implementasyonu)
   - `bloc/` (Event, State, BLoC veya Cubit)
   - `bilesenler/` (Yeniden kullanılabilir UI parçaları)
   - `ekranlar/` (Ana Scaffold sayfaları)
4. **Dart 3 Sonuc Deseni:**
   - Hata yönetiminde harici paket yerine Dart 3 yerel `Sonuc<T>` (`Basari<T>` ve `Hata<T>`) sealed class yapısı kullanılır.
5. **Açık & Koyu Tema Desteği:**
   - Bileşenlerde zemin veya metin rengi sabit kodlanmaz (`Colors.white` veya `koyuYuzey` doğrudan verilmez).
   - `final koyuMu = Theme.of(context).brightness == Brightness.dark;` kontrolü veya `Theme.of(context)` renkleri kullanılır.

---

## 2. Şablon Kod Yapıları

### 1. Sonuc Deseni (`cekirdek/hata/sonuc.dart`)

```dart
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
```

### 2. GetIt Bağımlılık Kaydı (`cekirdek/bagimlilik/servis_konfigurasyonu.dart`)

```dart
import 'package:get_it/get_it.dart';

final bulucu = GetIt.instance;

Future<void> servisleriBaslat() async {
  // 1. Depolar (Repositories)
  bulucu.registerLazySingleton<IIlanDeposu>(() => FirebaseIlanDeposu());

  // 2. BLoC & Cubit'ler
  bulucu.registerLazySingleton<TemaCubit>(() => TemaCubit());
  bulucu.registerFactory<IlanBloc>(() => IlanBloc(ilanDeposu: bulucu()));
}
```

### 3. Cubit Şablonu (Örn: Tema Durumu)

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TemaCubit extends Cubit<ThemeMode> {
  TemaCubit() : super(ThemeMode.dark);

  bool get koyuModMu => state == ThemeMode.dark;

  void temaDegistir(bool koyu) {
    emit(koyu ? ThemeMode.dark : ThemeMode.light);
  }
}
```

### 4. BLoC Pattern Matching UI Kullanımı

```dart
return BlocBuilder<IlanBloc, IlanState>(
  builder: (context, state) {
    return switch (state) {
      IlanYukleniyor() => const Center(child: CircularProgressIndicator()),
      IlanlarYuklendi(:final ilanlar) => ListView.builder(
          itemCount: ilanlar.length,
          itemBuilder: (ctx, i) => IlanKarti(ilan: ilanlar[i]),
        ),
      IlanHatasi(:final mesaj) => Center(child: Text(mesaj)),
      _ => const SizedBox.shrink(),
    };
  },
);
```

### 5. Tema Duyarlı Bileşen Şablonu

```dart
@override
Widget build(BuildContext context) {
  final koyuMu = Theme.of(context).brightness == Brightness.dark;
  final kartRengi = koyuMu ? UygulamaRenkleri.koyuYuzey : UygulamaRenkleri.acikYuzey;
  final kenarlikRengi = koyuMu ? UygulamaRenkleri.koyuKenarlik : UygulamaRenkleri.acikKenarlik;
  final metinRengi = koyuMu ? Colors.white : UygulamaRenkleri.metinKoyu;

  return Container(
    decoration: BoxDecoration(
      color: kartRengi,
      border: Border.all(color: kenarlikRengi),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Text(baslik, style: TextStyle(color: metinRengi)),
  );
}
```
