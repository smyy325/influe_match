import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TemaCubit extends Cubit<ThemeMode> {
  TemaCubit() : super(ThemeMode.dark);

  bool get koyuModMu => state == ThemeMode.dark;

  void temaDegistir(bool koyu) {
    emit(koyu ? ThemeMode.dark : ThemeMode.light);
  }

  void temaGecisYap() {
    emit(state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark);
  }
}
