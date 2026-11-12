import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../cekirdek/sabitler/renkler.dart';
import '../../kimlik/bloc/kimlik_bloc.dart';
import '../../kimlik/bloc/kimlik_state.dart';
import '../bloc/ilan_bloc.dart';
import '../bloc/ilan_state.dart';
import '../bilesenler/ilan_detay_aksiyon_butonlari.dart';
import '../bilesenler/ilan_detay_icerik.dart';
import '../bilesenler/ilan_detay_marka_karti.dart';
import '../model/basvuru_modeli.dart';
import '../model/ilan_modeli.dart';

class IlanDetayEkrani extends StatelessWidget {
  final IlanModeli ilan;

  const IlanDetayEkrani({super.key, required this.ilan});

  @override
  Widget build(BuildContext context) {
    final kimlikState = context.watch<KimlikBloc>().state;
    final kullanici = kimlikState is KimlikDogrulandi ? kimlikState.kullanici : null;
    final ilanState = context.watch<IlanBloc>().state;
    BasvuruModeli? mevcutBasvuru;
    if (ilanState is IlanlarYuklendi && kullanici != null) {
      try {
        if (kullanici.markaMi) {
          mevcutBasvuru = ilanState.basvurular.firstWhere((b) => b.ilanId == ilan.id);
        } else {
          mevcutBasvuru = ilanState.basvurular.firstWhere(
            (b) => b.ilanId == ilan.id && b.influencerId == kullanici.id,
          );
        }
      } catch (_) {}
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('İlan Detayı'),
      ),
      body: BlocListener<IlanBloc, IlanState>(
        listener: (context, state) {
          if (state is IlanIslemiBasarili) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.mesaj), backgroundColor: UygulamaRenkleri.naneYesili),
            );
          } else if (state is IlanHatasi) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.mesaj), backgroundColor: UygulamaRenkleri.mercan),
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IlanDetayMarkaKarti(ilan: ilan, kullanici: kullanici),
              const SizedBox(height: 20),
              IlanDetayIcerik(ilan: ilan),
              const SizedBox(height: 32),
              IlanDetayAksiyonButonlari(
                ilan: ilan,
                kullanici: kullanici,
                mevcutBasvuru: mevcutBasvuru,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
