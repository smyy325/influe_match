import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../cekirdek/sabitler/renkler.dart';
import '../../kimlik/bloc/kimlik_bloc.dart';
import '../../kimlik/bloc/kimlik_state.dart';
import '../../kimlik/model/kullanici_modeli.dart';
import '../bloc/sohbet_bloc.dart';
import '../bloc/sohbet_event.dart';
import '../bloc/sohbet_state.dart';
import '../bilesenler/sohbet_satiri_bileseni.dart';
import '../model/sohbet_odasi_modeli.dart';

class SohbetListesiEkrani extends StatefulWidget {
  const SohbetListesiEkrani({super.key});

  @override
  State<SohbetListesiEkrani> createState() => _SohbetListesiEkraniState();
}

class _SohbetListesiEkraniState extends State<SohbetListesiEkrani> {
  @override
  void initState() {
    super.initState();
    final kimlikState = context.read<KimlikBloc>().state;
    final kullanici = kimlikState is KimlikDogrulandi ? kimlikState.kullanici : null;
    _yenile(kullanici);
  }

  void _yenile(KullaniciModeli? kullanici) {
    if (kullanici != null) {
      context.read<SohbetBloc>().add(SohbetOdalariniYukleEvent(kullanici.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    final kimlikState = context.watch<KimlikBloc>().state;
    final kullanici = kimlikState is KimlikDogrulandi ? kimlikState.kullanici : null;

    return Scaffold(
      appBar: AppBar(title: const Text('Mesajlar & İş Birlikleri')),
      body: RefreshIndicator(
        onRefresh: () async => _yenile(kullanici),
        child: BlocBuilder<SohbetBloc, SohbetState>(
          builder: (context, state) {
            if (state is SohbetYukleniyor) {
              return const Center(child: CircularProgressIndicator());
            }

            if (kullanici != null && state is SohbetBaslangic) {
              WidgetsBinding.instance.addPostFrameCallback((_) => _yenile(kullanici));
              return const Center(child: CircularProgressIndicator());
            }

            final odalar = state is SohbetOdalariYuklendi ? state.odalar : <SohbetOdasiModeli>[];

            if (odalar.isEmpty) {
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.25),
                  const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.chat_bubble_outline_rounded, size: 56, color: UygulamaRenkleri.metinGri),
                        SizedBox(height: 12),
                        Text('Henüz aktif bir mesajlaşmanız bulunmuyor.', style: TextStyle(color: UygulamaRenkleri.metinGri)),
                      ],
                    ),
                  ),
                ],
              );
            }

            return ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: odalar.length,
              separatorBuilder: (context, index) => const Divider(
                height: 1,
                color: UygulamaRenkleri.koyuKenarlik,
                indent: 72,
              ),
              itemBuilder: (context, index) {
                final oda = odalar[index];
                return SohbetSatiriBileseni(
                  oda: oda,
                  onTap: () {
                    context.push('/sohbet/${oda.id}', extra: oda);
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
