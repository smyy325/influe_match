import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/renkler.dart';
import '../../../core/dependency/servis_konfigurasyonu.dart';
import '../../../core/error/sonuc.dart';
import '../../../core/helpers/resim_saglayici_yardimcisi.dart';
import '../../chat/bloc/sohbet_bloc.dart';
import '../../chat/bloc/sohbet_event.dart';
import '../../chat/repository/sohbet_deposu.dart';
import '../models/basvuru_modeli.dart';
import 'basvuru_notu_kutusu.dart';

class BasvuruKarti extends StatelessWidget {
  final BasvuruModeli basvuru;
  final bool markaMi;
  final String mevcutKullaniciId;

  const BasvuruKarti({
    super.key,
    required this.basvuru,
    required this.markaMi,
    required this.mevcutKullaniciId,
  });

  Color _durumRengi(BasvuruDurumu durum) => switch (durum) {
        BasvuruDurumu.beklemede => UygulamaRenkleri.sariVurgu,
        BasvuruDurumu.kabulEdildi => UygulamaRenkleri.naneYesili,
        BasvuruDurumu.reddedildi => UygulamaRenkleri.mercan,
      };

  String _durumMetni(BasvuruDurumu durum) => switch (durum) {
        BasvuruDurumu.beklemede => 'Değerlendiriliyor',
        BasvuruDurumu.kabulEdildi => 'Kabul Edildi',
        BasvuruDurumu.reddedildi => 'Reddedildi',
      };

  Future<void> _sohbetAc(BuildContext context) async {
    final karsiId = markaMi ? basvuru.influencerId : (basvuru.markaId.isNotEmpty ? basvuru.markaId : 'marka_101');
    final karsiAdi = markaMi ? basvuru.influencerAdi : basvuru.markaAdi;
    final karsiProfil = basvuru.influencerProfil;
    final karsiRol = markaMi ? 'Influencer' : 'Marka';

    final sonuc = await bulucu<ISohbetDeposu>().sohbetOlusturVeyaGetir(
      ilanId: basvuru.ilanId,
      ilanBasligi: basvuru.ilanBasligi,
      karsiTarafId: karsiId,
      karsiTarafAdi: karsiAdi,
      karsiTarafProfil: karsiProfil,
      karsiTarafRol: karsiRol,
      mevcutKullaniciId: mevcutKullaniciId,
    );

    if (context.mounted) {
      if (sonuc case Basari(:final veri)) {
        context.read<SohbetBloc>().add(MesajlariDinleEvent(veri.id));
        context.push('/sohbet/${veri.id}', extra: veri);
      }
    }
  }

  void _profiliAc(BuildContext context) {
    final hedefId = markaMi ? basvuru.influencerId : basvuru.markaId;
    if (hedefId.isNotEmpty) {
      context.push('/kullanici-profil/$hedefId');
    }
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('dd MMM yyyy, HH:mm', 'tr_TR').format(basvuru.tarih);
    final durumRenk = _durumRengi(basvuru.durum);
    final fotoSaglayici = ResimSaglayiciYardimcisi.saglayici(basvuru.influencerProfil);
    final gorunenAd = markaMi ? basvuru.influencerAdi : basvuru.markaAdi;

    return Card(
      child: InkWell(
        onTap: markaMi ? () => context.push('/basvuru-detay', extra: basvuru) : null,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () => _profiliAc(context),
                    child: CircleAvatar(
                      radius: 20,
                      backgroundImage: markaMi ? fotoSaglayici : null,
                      backgroundColor: UygulamaRenkleri.anaMor.withValues(alpha: 0.2),
                      child: (markaMi && fotoSaglayici != null)
                          ? null
                          : Text(gorunenAd.isNotEmpty ? gorunenAd[0].toUpperCase() : 'U',
                              style: const TextStyle(fontWeight: FontWeight.bold, color: UygulamaRenkleri.acikMor)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _profiliAc(context),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(child: Text(gorunenAd, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14))),
                              const SizedBox(width: 4),
                              const Icon(Icons.open_in_new_rounded, size: 12, color: UygulamaRenkleri.metinGri),
                            ],
                          ),
                          Text(basvuru.ilanBasligi, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12, color: UygulamaRenkleri.metinGri)),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: durumRenk.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: durumRenk),
                    ),
                    child: Text(_durumMetni(basvuru.durum), style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: durumRenk)),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              BasvuruNotuKutusu(not: basvuru.basvuruNotu),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(formattedDate, style: const TextStyle(fontSize: 11, color: UygulamaRenkleri.metinGri)),
                  TextButton.icon(
                    onPressed: () => _sohbetAc(context),
                    icon: const Icon(Icons.chat_bubble_outline_rounded, size: 16),
                    label: const Text('Mesajlaş', style: TextStyle(fontSize: 12)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
