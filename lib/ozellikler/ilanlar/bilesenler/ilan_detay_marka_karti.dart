import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../cekirdek/bagimlilik/servis_konfigurasyonu.dart';
import '../../../cekirdek/hata/sonuc.dart';
import '../../../cekirdek/sabitler/renkler.dart';
import '../../../cekirdek/yardimcilar/resim_saglayici_yardimcisi.dart';
import '../../kimlik/model/kullanici_modeli.dart';
import '../../sohbet/bloc/sohbet_bloc.dart';
import '../../sohbet/bloc/sohbet_event.dart';
import '../../sohbet/depo/sohbet_deposu.dart';
import '../model/ilan_modeli.dart';

class IlanDetayMarkaKarti extends StatelessWidget {
  final IlanModeli ilan;
  final KullaniciModeli? kullanici;

  const IlanDetayMarkaKarti({
    super.key,
    required this.ilan,
    required this.kullanici,
  });

  Future<void> _sohbetAc(BuildContext context) async {
    if (kullanici == null) return;
    final sonuc = await bulucu<ISohbetDeposu>().sohbetOlusturVeyaGetir(
      ilanId: ilan.id,
      ilanBasligi: ilan.baslik,
      karsiTarafId: ilan.markaId,
      karsiTarafAdi: ilan.markaAdi,
      karsiTarafProfil: ilan.markaLogoUrl,
      karsiTarafRol: 'Marka',
      mevcutKullaniciId: kullanici!.id,
    );
    if (context.mounted) {
      if (sonuc case Basari(:final veri)) {
        context.read<SohbetBloc>().add(MesajlariDinleEvent(veri.id));
        context.push('/sohbet/${veri.id}', extra: veri);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final kendiIlaniMi = kullanici != null && ilan.markaId == kullanici!.id;
    final fotoSaglayici = ResimSaglayiciYardimcisi.saglayici(ilan.markaLogoUrl);
    final koyuMu = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: koyuMu ? UygulamaRenkleri.koyuYuzey : UygulamaRenkleri.acikYuzey,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: koyuMu ? UygulamaRenkleri.koyuKenarlik : UygulamaRenkleri.acikKenarlik),
      ),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () {
                if (ilan.markaId.isNotEmpty) {
                  context.push('/kullanici-profil/${ilan.markaId}');
                }
              },
              borderRadius: BorderRadius.circular(12),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 26,
                    backgroundImage: fotoSaglayici,
                    backgroundColor: UygulamaRenkleri.anaMor.withValues(alpha: 0.2),
                    child: fotoSaglayici == null
                        ? Text(
                            ilan.markaAdi.isNotEmpty ? ilan.markaAdi[0].toUpperCase() : 'M',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: UygulamaRenkleri.acikMor),
                          )
                        : null,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(child: Text(ilan.markaAdi, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
                            const SizedBox(width: 4),
                            const Icon(Icons.verified_rounded, size: 16, color: UygulamaRenkleri.acikMor),
                            const Icon(Icons.chevron_right_rounded, size: 16, color: UygulamaRenkleri.metinGri),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(ilan.kategori, style: const TextStyle(fontSize: 12, color: UygulamaRenkleri.metinGri)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (!kendiIlaniMi && kullanici != null)
            IconButton.filledTonal(
              icon: const Icon(Icons.chat_bubble_outline_rounded, size: 20),
              onPressed: () => _sohbetAc(context),
            ),
        ],
      ),
    );
  }
}
