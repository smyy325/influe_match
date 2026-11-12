// Dosya Görevi: GoRouter Uygulama Rotaları ve Sayfa Yönlendirme Konfigürasyonu (App Router).
// Bu dosya uygulama içindeki ekran geçişlerini, parametreli rotaları (ör. /kullanici-profil/:id)
// ve nesne taşıyan extra parametreli sayfaları GoRouter paketi ile yapılandırır.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../ozellikler/acilis/ekranlar/acilis_ekrani.dart';
import '../../ozellikler/ana_sayfa/ekranlar/ana_kabuk_ekrani.dart';
import '../../ozellikler/ilanlar/ekranlar/basvuru_detay_ekrani.dart';
import '../../ozellikler/ilanlar/ekranlar/basvurularim_ekrani.dart';
import '../../ozellikler/ilanlar/ekranlar/ilan_detay_ekrani.dart';
import '../../ozellikler/ilanlar/ekranlar/ilan_olustur_ekrani.dart';
import '../../ozellikler/ilanlar/model/basvuru_modeli.dart';
import '../../ozellikler/ilanlar/model/ilan_modeli.dart';
import '../../ozellikler/kimlik/ekranlar/giris_ekrani.dart';
import '../../ozellikler/kimlik/ekranlar/kayit_ekrani.dart';
import '../../ozellikler/profil/ekranlar/kullanici_profil_detay_ekrani.dart';
import '../../ozellikler/sohbet/ekranlar/sohbet_detay_ekrani.dart';
import '../../ozellikler/sohbet/model/sohbet_odasi_modeli.dart';
import '../../ozellikler/tanitim/ekranlar/tanitim_ekrani.dart';

/// uygulamaRotalari: Tüm ekran rotalarını ve parametre eşleşmelerini tanımlayan GoRouter nesnesi.
final GoRouter uygulamaRotalari = GoRouter(
  initialLocation: '/',
  routes: [
    // 1. Rota: Açılış (Splash) Ekranı
    GoRoute(
      path: '/',
      builder: (context, state) => const AcilisEkrani(),
    ),
    // 2. Rota: Tanıtım (Onboarding) Ekranı
    GoRoute(
      path: '/tanitim',
      builder: (context, state) => const TanitimEkrani(),
    ),
    // 3. Rota: Giriş Yap Ekranı
    GoRoute(
      path: '/giris',
      builder: (context, state) => const GirisEkrani(),
    ),
    // 4. Rota: Ücretsiz Kayıt Ol Ekranı
    GoRoute(
      path: '/kayit',
      builder: (context, state) => const KayitEkrani(),
    ),
    // 5. Rota: Ana Kabuk (Bottom Navigation) Ekranı
    GoRoute(
      path: '/ana_sayfa',
      builder: (context, state) => const AnaKabukEkrani(),
    ),
    // 6. Rota: Yeni İlan Oluşturma Ekranı
    GoRoute(
      path: '/ilan-olustur',
      builder: (context, state) => const IlanOlusturEkrani(),
    ),
    // 7. Rota: Başvurularım & Süreç Listesi Ekranı
    GoRoute(
      path: '/basvurularim',
      builder: (context, state) => const BasvurularimEkrani(),
    ),
    // 8. Rota: Parametreli Kullanıcı Profil Detay Ekranı
    GoRoute(
      path: '/kullanici-profil/:id',
      builder: (context, state) {
        final id = state.pathParameters['id'] ?? '';
        return KullaniciProfilDetayEkrani(kullaniciId: id);
      },
    ),
    // 9. Rota: Extra nesne parametreli Başvuru Detay Ekranı
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
    // 10. Rota: Extra nesne parametreli İlan Detay Ekranı
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
    // 11. Rota: Canlı Sohbet Detay Ekranı
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
