import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/renkler.dart';
import '../../auth/bloc/kimlik_bloc.dart';
import '../../auth/bloc/kimlik_state.dart';
import '../../chat/bloc/sohbet_bloc.dart';
import '../../chat/bloc/sohbet_event.dart';
import '../../chat/screens/sohbet_listesi_ekrani.dart';
import '../../listings/bloc/ilan_bloc.dart';
import '../../listings/bloc/ilan_event.dart';
import '../../listings/screens/basvurularim_ekrani.dart';
import '../../listings/screens/ilan_akisi_ekrani.dart';
import '../../profile/screens/profil_ekrani.dart';

class AnaKabukEkrani extends StatefulWidget {
  const AnaKabukEkrani({super.key});

  @override
  State<AnaKabukEkrani> createState() => _AnaKabukEkraniState();
}

class _AnaKabukEkraniState extends State<AnaKabukEkrani> {
  int _seciliSekme = 0;

  late final List<Widget> _ekranlar;

  @override
  void initState() {
    super.initState();
    _ekranlar = [
      const IlanAkisiEkrani(),
      BasvurularimEkrani(
        onIlanaGit: () => _sekmeDegisti(0),
      ),
      const SohbetListesiEkrani(),
      const ProfilEkrani(),
    ];
  }

  void _sekmeDegisti(int index) {
    setState(() => _seciliSekme = index);

    final kimlik = context.read<KimlikBloc>().state;
    if (kimlik is KimlikDogrulandi) {
      final k = kimlik.kullanici;
      
      if (index == 1) {
        context.read<IlanBloc>().add(
              BasvurulariYukleEvent(
                influencerId: k.influencerMi ? k.id : null,
                markaId: k.markaMi ? k.id : null,
              ),
            );
      } 
      else if (index == 2) {
        context.read<SohbetBloc>().add(SohbetOdalariniYukleEvent(k.id));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final kimlik = context.watch<KimlikBloc>().state;
    final kullanici = kimlik is KimlikDogrulandi ? kimlik.kullanici : null;
    final markaMi = kullanici?.markaMi ?? false;
    final koyuMu = Theme.of(context).brightness == Brightness.dark;
    
    final cubukArkaPlan = koyuMu ? UygulamaRenkleri.koyuYuzey : UygulamaRenkleri.acikYuzey;
    final kenarlikRengi = koyuMu ? UygulamaRenkleri.koyuKenarlik : UygulamaRenkleri.acikKenarlik;
    final seciliIkonRengi = koyuMu ? UygulamaRenkleri.acikMor : UygulamaRenkleri.anaMor;

    return Scaffold(
      body: IndexedStack(
        index: _seciliSekme,
        children: _ekranlar,
      ),
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
            NavigationDestination(
              icon: const Icon(Icons.explore_outlined),
              selectedIcon: Icon(Icons.explore_rounded, color: seciliIkonRengi),
              label: 'İlanlar',
            ),
            NavigationDestination(
              icon: const Icon(Icons.assignment_outlined),
              selectedIcon: Icon(Icons.assignment_rounded, color: seciliIkonRengi),
              label: markaMi ? 'Gelen Başvurular' : 'Başvurularım',
            ),
            NavigationDestination(
              icon: const Icon(Icons.chat_bubble_outline_rounded),
              selectedIcon: Icon(Icons.chat_bubble_rounded, color: seciliIkonRengi),
              label: 'Sohbet',
            ),
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
