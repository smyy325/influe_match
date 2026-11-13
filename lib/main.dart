import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'core/constants/temalar.dart';
import 'core/dependency/servis_konfigurasyonu.dart';
import 'core/routing/uygulama_rotalari.dart';
import 'core/theme/tema_cubit.dart';
import 'features/auth/bloc/kimlik_bloc.dart';
import 'features/auth/bloc/kimlik_event.dart';
import 'features/chat/bloc/sohbet_bloc.dart';
import 'features/listings/bloc/ilan_bloc.dart';
import 'features/listings/bloc/ilan_event.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting('tr_TR', null);

  await servisleriBaslat();

  runApp(const InflueMatchUygulamasi());
}

class InflueMatchUygulamasi extends StatelessWidget {
  const InflueMatchUygulamasi({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TemaCubit>(
          create: (_) => bulucu<TemaCubit>(),
        ),
        BlocProvider<KimlikBloc>(
          create: (_) => bulucu<KimlikBloc>()..add(KimlikDurumunuKontrolEtEvent()),
        ),
        BlocProvider<IlanBloc>(
          create: (_) => bulucu<IlanBloc>()
            ..add(const IlanlariYukleEvent())
            ..add(IlanAkisiniDinleEvent()),
        ),
        BlocProvider<SohbetBloc>(
          create: (_) => bulucu<SohbetBloc>(),
        ),
      ],
      child: BlocBuilder<TemaCubit, ThemeMode>(
        builder: (context, temaModu) {
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
