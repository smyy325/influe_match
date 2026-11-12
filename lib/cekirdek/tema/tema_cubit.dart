// Dosya Görevi: Uygulama Teması Yönetimi Cubit (Light / Dark Theme Controller).
// BLoC mimarisinin daha hafif bir türü olan Cubit yapısını kullanarak
// uygulamanın Açık ve Koyu tema modları arasındaki geçişi dinamik olarak yönetir.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// TemaCubit: Uygulama genelindeki ThemeMode (dark, light) durumunu tutan ve değiştiren Cubit sınıfı.
class TemaCubit extends Cubit<ThemeMode> {
  // Varsayılan olarak Koyu Tema (ThemeMode.dark) ile başlatılır.
  TemaCubit() : super(ThemeMode.dark);

  /// koyuModMu: Mevcut tema durumunun koyu mod olup olmadığını dönen yardımcı getter.
  bool get koyuModMu => state == ThemeMode.dark;

  /// temaDegistir(): Parametreye göre temayı açık veya koyu mod olarak günceller.
  void temaDegistir(bool koyu) {
    emit(koyu ? ThemeMode.dark : ThemeMode.light);
  }

  /// temaGecisYap(): Mevcut temayı tersine çevirerek (Koyu -> Açık veya Açık -> Koyu) geçiş yapar.
  void temaGecisYap() {
    emit(state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark);
  }
}
