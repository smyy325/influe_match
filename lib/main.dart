// Dosya Görevi: Uygulamanın ana başlangıç noktası (Entry Point).
// Bu dosya Firebase/GetIt bağımlılıklarını başlatır, Global BLoC sağlayıcılarını kurar
// ve tema ile GoRouter rotalarını Material Uygulama seviyesinde bağlar.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'cekirdek/bagimlilik/servis_konfigurasyonu.dart';
import 'cekirdek/sabitler/temalar.dart';
import 'cekirdek/tema/tema_cubit.dart';
import 'cekirdek/yonlendirme/uygulama_rotalari.dart';
import 'ozellikler/ilanlar/bloc/ilan_bloc.dart';
import 'ozellikler/ilanlar/bloc/ilan_event.dart';
import 'ozellikler/kimlik/bloc/kimlik_bloc.dart';
import 'ozellikler/kimlik/bloc/kimlik_event.dart';
import 'ozellikler/sohbet/bloc/sohbet_bloc.dart';

/// main(): Uygulama çalıştırıldığında ilk olarak yürütülen asenkron ana fonksiyon.
void main() async {
  // Widget ağacının Flutter motoru ile düzgün şekilde ilklendirildiğini garanti eder.
  WidgetsFlutterBinding.ensureInitialized();

  // Türkçe tarih ve saat formatlamasını (tr_TR) aktif eder.
  await initializeDateFormatting('tr_TR', null);

  // Bağımlılık Enjeksiyonu (GetIt) servisini ve depolarını ilklendirir.
  await servisleriBaslat();

  // Kök widget olan InflueMatchUygulamasi sınıfını çalıştırır.
  runApp(const InflueMatchUygulamasi());
}

/// InflueMatchUygulamasi: Uygulamanın en üst seviyedeki durumsuz (Stateless) kök widget'ı.
class InflueMatchUygulamasi extends StatelessWidget {
  const InflueMatchUygulamasi({super.key});

  /// build(): Widget'ın ekrandaki yapısını ve BLoC sağlayıcılarını oluşturan yaşam döngüsü metodu.
  @override
  Widget build(BuildContext context) {
    // MultiBlocProvider: Tüm uygulama genelinde erişilebilir olan BLoC yapılarını yukarıda tanımlar.
    return MultiBlocProvider(
      providers: [
        // Tema yönetimi için TemaCubit sağlayıcısı.
        BlocProvider<TemaCubit>(
          create: (_) => bulucu<TemaCubit>(),
        ),
        // Oturum ve kimlik doğrulama işlemleri için KimlikBloc sağlayıcısı.
        BlocProvider<KimlikBloc>(
          create: (_) => bulucu<KimlikBloc>()..add(KimlikDurumunuKontrolEtEvent()),
        ),
        // Kampanya ilanları ve akış yönetimi için IlanBloc sağlayıcısı.
        BlocProvider<IlanBloc>(
          create: (_) => bulucu<IlanBloc>()
            ..add(const IlanlariYukleEvent())
            ..add(IlanAkisiniDinleEvent()),
        ),
        // Sohbet ve canlı mesajlaşma işlemleri için SohbetBloc sağlayıcısı.
        BlocProvider<SohbetBloc>(
          create: (_) => bulucu<SohbetBloc>(),
        ),
      ],
      // BlocBuilder: Tema modundaki değişiklikleri dinleyerek uygulamanın renk temasını anlık günceller.
      child: BlocBuilder<TemaCubit, ThemeMode>(
        builder: (context, temaModu) {
          // MaterialApp.router: GoRouter yönlendirme altyapısı ile entegre Material uygulaması.
          return MaterialApp.router(
            title: 'InflueMatch',
            debugShowCheckedModeBanner: false,
            theme: UygulamaTemasi.acikTema,
            darkTheme: UygulamaTemasi.koyuTema,
            themeMode: temaModu,
            routerConfig: uygulamaRotalari,
          );
        },
      ),
    );
  }
}
