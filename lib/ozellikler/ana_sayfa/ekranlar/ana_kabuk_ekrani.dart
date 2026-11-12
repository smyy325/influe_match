// Dosya Görevi: Ana Kabuk Ekranı (Bottom Navigation Shell).
// Bu ekran uygulamanın alt gezinti çubuğunu (NavigationBar) barındırır,
// sekmeler arası geçişi yönetir ve IndexedStack ile durumları koruyarak 4 ana ekranı görüntüler.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../cekirdek/sabitler/renkler.dart';
import '../../kimlik/bloc/kimlik_bloc.dart';
import '../../kimlik/bloc/kimlik_state.dart';
import '../../ilanlar/bloc/ilan_bloc.dart';
import '../../ilanlar/bloc/ilan_event.dart';
import '../../ilanlar/ekranlar/basvurularim_ekrani.dart';
import '../../ilanlar/ekranlar/ilan_akisi_ekrani.dart';
import '../../profil/ekranlar/profil_ekrani.dart';
import '../../sohbet/bloc/sohbet_bloc.dart';
import '../../sohbet/bloc/sohbet_event.dart';
import '../../sohbet/ekranlar/sohbet_listesi_ekrani.dart';

/// AnaKabukEkrani: Alt gezinti çubuğu ile sekmeli navigasyonu yöneten durumlu (Stateful) widget.
class AnaKabukEkrani extends StatefulWidget {
  const AnaKabukEkrani({super.key});

  @override
  State<AnaKabukEkrani> createState() => _AnaKabukEkraniState();
}

/// _AnaKabukEkraniState: Aktif sekme indeksini ve sekme değiştiğinde çalışan veri yükleme mantığını tutan sınıf.
class _AnaKabukEkraniState extends State<AnaKabukEkrani> {
  // Seçili olan alt sekme indeksi (0: İlanlar, 1: Başvurular, 2: Sohbet, 3: Profil).
  int _seciliSekme = 0;

  // Sekmelerde görüntülenecek 4 ana sayfa ekranı.
  final List<Widget> _ekranlar = const [
    IlanAkisiEkrani(),
    BasvurularimEkrani(),
    SohbetListesiEkrani(),
    ProfilEkrani(),
  ];

  /// _sekmeDegisti(): Kullanıcı alt çubukta farklı bir sekmeye tıkladığında çalışan olay işleyici (Event Handler).
  /// Sekme değiştiğinde ilgili BLoC olaylarını (Başvuruları yükle, Sohbet odalarını yükle) tetikler.
  void _sekmeDegisti(int index) {
    // setState(): Ekranın yeniden çizilmesini sağlayarak seciliSekme indeksini günceller.
    setState(() => _seciliSekme = index);

    final kimlik = context.read<KimlikBloc>().state;
    if (kimlik is KimlikDogrulandi) {
      final k = kimlik.kullanici;
      
      // Başvurular sekmesine geçildiğinde başvuru verilerini yeniler.
      if (index == 1) {
        context.read<IlanBloc>().add(
              BasvurulariYukleEvent(
                influencerId: k.influencerMi ? k.id : null,
                markaId: k.markaMi ? k.id : null,
              ),
            );
      } 
      // Sohbet sekmesine geçildiğinde sohbet odalarını yeniler.
      else if (index == 2) {
        context.read<SohbetBloc>().add(SohbetOdalariniYukleEvent(k.id));
      }
    }
  }

  /// build(): Alt gezinti çubuğunu ve IndexedStack sayfa gövdesini oluşturan yaşam döngüsü metodu.
  @override
  Widget build(BuildContext context) {
    // Aktif kullanıcının rol bilgisini (Marka veya Influencer) BLoC üzerinden dinler.
    final kimlik = context.watch<KimlikBloc>().state;
    final kullanici = kimlik is KimlikDogrulandi ? kimlik.kullanici : null;
    final markaMi = kullanici?.markaMi ?? false;
    final koyuMu = Theme.of(context).brightness == Brightness.dark;
    
    // Tema moduna göre alt bar renk yapılandırması.
    final cubukArkaPlan = koyuMu ? UygulamaRenkleri.koyuYuzey : UygulamaRenkleri.acikYuzey;
    final kenarlikRengi = koyuMu ? UygulamaRenkleri.koyuKenarlik : UygulamaRenkleri.acikKenarlik;
    final seciliIkonRengi = koyuMu ? UygulamaRenkleri.acikMor : UygulamaRenkleri.anaMor;

    return Scaffold(
      // IndexedStack: Sekmeler değişse bile ekran durumlarını (scroll pozisyonu vb.) korur.
      body: IndexedStack(
        index: _seciliSekme,
        children: _ekranlar,
      ),
      // NavigationBar: Material 3 alt gezinti çubuğu bileşeni.
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: kenarlikRengi, width: 1)),
        ),
        child: NavigationBar(
          selectedIndex: _seciliSekme,
          onDestinationSelected: _sekmeDegisti,
          backgroundColor: cubukArkaPlan,
          indicatorColor: UygulamaRenkleri.anaMor.withValues(alpha: koyuMu ? 0.25 : 0.15),
          destinations: [
            // 1. Sekme: Kampanya İlanları Akışı
            NavigationDestination(
              icon: const Icon(Icons.explore_outlined),
              selectedIcon: Icon(Icons.explore_rounded, color: seciliIkonRengi),
              label: 'İlanlar',
            ),
            // 2. Sekme: Role göre 'Gelen Başvurular' veya 'Başvurularım'
            NavigationDestination(
              icon: const Icon(Icons.assignment_outlined),
              selectedIcon: Icon(Icons.assignment_rounded, color: seciliIkonRengi),
              label: markaMi ? 'Gelen Başvurular' : 'Başvurularım',
            ),
            // 3. Sekme: Mesajlar ve Sohbet Odaları
            NavigationDestination(
              icon: const Icon(Icons.chat_bubble_outline_rounded),
              selectedIcon: Icon(Icons.chat_bubble_rounded, color: seciliIkonRengi),
              label: 'Sohbet',
            ),
            // 4. Sekme: Kullanıcı Profil Yönetimi
            NavigationDestination(
              icon: const Icon(Icons.person_outline_rounded),
              selectedIcon: Icon(Icons.person_rounded, color: seciliIkonRengi),
              label: 'Profil',
            ),
          ],
        ),
      ),
    );
  }
}
