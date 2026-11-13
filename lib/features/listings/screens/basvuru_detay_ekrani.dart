import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/renkler.dart';
import '../../../core/dependency/servis_konfigurasyonu.dart';
import '../../../core/error/sonuc.dart';
import '../../auth/bloc/kimlik_bloc.dart';
import '../../auth/bloc/kimlik_state.dart';
import '../../chat/repository/sohbet_deposu.dart';
import '../bloc/ilan_bloc.dart';
import '../bloc/ilan_event.dart';
import '../models/basvuru_modeli.dart';
import '../repository/ilan_deposu.dart';
import '../widgets/basvuru_detay_aksiyon_butonlari.dart';
import '../widgets/basvuru_detay_ilan_karti.dart';
import '../widgets/basvuru_detay_influencer_karti.dart';

class BasvuruDetayEkrani extends StatefulWidget {
  final BasvuruModeli basvuru;

  const BasvuruDetayEkrani({super.key, required this.basvuru});

  @override
  State<BasvuruDetayEkrani> createState() => _BasvuruDetayEkraniState();
}

class _BasvuruDetayEkraniState extends State<BasvuruDetayEkrani> {
  late BasvuruDurumu _durum;

  @override
  void initState() {
    super.initState();
    _durum = widget.basvuru.durum;
  }

  Future<void> _durumGuncelle(BasvuruDurumu yeniDurum) async {
    setState(() => _durum = yeniDurum);
    final sonuc = await bulucu<IIlanDeposu>().basvuruDurumuDegistir(
      widget.basvuru.id,
      yeniDurum,
      basvuru: widget.basvuru.copyWith(durum: yeniDurum),
    );
    if (mounted) {
      if (sonuc is Basari) {
        final kimlik = context.read<KimlikBloc>().state;
        if (kimlik is KimlikDogrulandi) {
          final k = kimlik.kullanici;
          context.read<IlanBloc>().add(BasvurulariYukleEvent(influencerId: k.influencerMi ? k.id : null, markaId: k.markaMi ? k.id : null));
        }
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(yeniDurum == BasvuruDurumu.kabulEdildi ? 'Başvuru onaylandı!' : 'Başvuru reddedildi.'),
          backgroundColor: yeniDurum == BasvuruDurumu.kabulEdildi ? UygulamaRenkleri.naneYesili : UygulamaRenkleri.mercan,
        ));
      }
    }
  }

  Future<void> _sohbetAc() async {
    final kimlik = context.read<KimlikBloc>().state;
    final mevcutId = kimlik is KimlikDogrulandi ? kimlik.kullanici.id : '';
    final sonuc = await bulucu<ISohbetDeposu>().sohbetOlusturVeyaGetir(
      ilanId: widget.basvuru.ilanId,
      ilanBasligi: widget.basvuru.ilanBasligi,
      karsiTarafId: widget.basvuru.influencerId,
      karsiTarafAdi: widget.basvuru.influencerAdi,
      karsiTarafProfil: widget.basvuru.influencerProfil,
      karsiTarafRol: 'Influencer',
      mevcutKullaniciId: mevcutId,
    );
    if (mounted) {
      if (sonuc case Basari(:final veri)) {
        context.push('/sohbet/${veri.id}', extra: veri);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final kimlik = context.watch<KimlikBloc>().state;
    final markaMi = kimlik is KimlikDogrulandi ? kimlik.kullanici.markaMi : false;

    return Scaffold(
      appBar: AppBar(title: const Text('Başvuru Değerlendirmesi')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            BasvuruDetayIlanKarti(basvuru: widget.basvuru),
            const SizedBox(height: 20),
            BasvuruDetayInfluencerKarti(basvuru: widget.basvuru, onMesajlas: _sohbetAc),
            const SizedBox(height: 28),
            BasvuruDetayAksiyonButonlari(
              durum: _durum,
              markaMi: markaMi,
              onDurumDegistir: _durumGuncelle,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
