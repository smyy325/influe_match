import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/screens/giris_ekrani.dart';
import '../../features/auth/screens/kayit_ekrani.dart';
import '../../features/chat/models/sohbet_odasi_modeli.dart';
import '../../features/chat/screens/sohbet_detay_ekrani.dart';
import '../../features/home/screens/ana_sayfa_ekrani.dart';
import '../../features/listings/models/basvuru_modeli.dart';
import '../../features/listings/models/ilan_modeli.dart';
import '../../features/listings/screens/basvuru_detay_ekrani.dart';
import '../../features/listings/screens/basvurularim_ekrani.dart';
import '../../features/listings/screens/ilan_detay_ekrani.dart';
import '../../features/listings/screens/ilan_olustur_ekrani.dart';
import '../../features/onboarding/screens/tanitim_ekrani.dart';
import '../../features/profile/screens/kullanici_profil_detay_ekrani.dart';
import '../../features/splash/screens/acilis_ekrani.dart';

final GoRouter uygulamaRotalari = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const AcilisEkrani(),
    ),
    GoRoute(
      path: '/tanitim',
      builder: (context, state) => const TanitimEkrani(),
    ),
    GoRoute(
      path: '/giris',
      builder: (context, state) => const GirisEkrani(),
    ),
    GoRoute(
      path: '/kayit',
      builder: (context, state) => const KayitEkrani(),
    ),
    GoRoute(
      path: '/ana_sayfa',
      builder: (context, state) => const AnaKabukEkrani(),
    ),
    GoRoute(
      path: '/ilan-olustur',
      builder: (context, state) => const IlanOlusturEkrani(),
    ),
    GoRoute(
      path: '/basvurularim',
      builder: (context, state) => const BasvurularimEkrani(),
    ),
    GoRoute(
      path: '/kullanici-profil/:id',
      builder: (context, state) {
        final id = state.pathParameters['id'] ?? '';
        return KullaniciProfilDetayEkrani(kullaniciId: id);
      },
    ),
    GoRoute(
      path: '/basvuru-detay',
      builder: (context, state) {
        final basvuru = state.extra as BasvuruModeli?;
        if (basvuru != null) {
          return BasvuruDetayEkrani(basvuru: basvuru);
        }
        return const Scaffold(body: Center(child: Text('Başvuru bilgisi bulunamadı.')));
      },
    ),
    GoRoute(
      path: '/ilan-detay/:id',
      builder: (context, state) {
        final ilan = state.extra as IlanModeli?;
        if (ilan != null) {
          return IlanDetayEkrani(ilan: ilan);
        }
        return const Scaffold(
          body: Center(child: Text('İlan bilgisi yüklenemedi.')),
        );
      },
    ),
    GoRoute(
      path: '/sohbet/:id',
      builder: (context, state) {
        final sohbetId = state.pathParameters['id'] ?? '';
        final oda = state.extra as SohbetOdasiModeli?;
        return SohbetDetayEkrani(
          sohbetId: sohbetId,
          oda: oda,
        );
      },
    ),
  ],
);
