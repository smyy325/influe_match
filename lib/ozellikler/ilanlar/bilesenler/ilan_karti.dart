import 'package:flutter/material.dart';
import '../../../cekirdek/sabitler/renkler.dart';
import '../../../cekirdek/yardimcilar/resim_saglayici_yardimcisi.dart';
import '../model/basvuru_modeli.dart';
import '../model/ilan_modeli.dart';

class IlanKarti extends StatelessWidget {
  final IlanModeli ilan;
  final bool basvurduMu;
  final BasvuruDurumu? basvuruDurumu;
  final VoidCallback onTap;

  const IlanKarti({
    super.key,
    required this.ilan,
    required this.basvurduMu,
    this.basvuruDurumu,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final logoSaglayici = ResimSaglayiciYardimcisi.saglayici(ilan.markaLogoUrl);
    final ozelIlan = ilan.ozelIlanMi;
    final koyuMu = Theme.of(context).brightness == Brightness.dark;
    final kartRengi = ozelIlan ? (koyuMu ? const Color(0xFF2B220C) : const Color(0xFFFFFBEB)) : null;
    final kenarlik = ozelIlan ? UygulamaRenkleri.sariVurgu : (koyuMu ? UygulamaRenkleri.koyuKenarlik : UygulamaRenkleri.acikKenarlik);
    final reddedildi = basvuruDurumu == BasvuruDurumu.reddedildi;
    final rozetRengi = reddedildi ? UygulamaRenkleri.mercan : UygulamaRenkleri.naneYesili;

    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      color: kartRengi,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: kenarlik, width: ozelIlan ? 1.5 : 1)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 20, backgroundImage: logoSaglayici, backgroundColor: UygulamaRenkleri.anaMor.withValues(alpha: 0.2),
                    child: logoSaglayici == null
                        ? Text(ilan.markaAdi.isNotEmpty ? ilan.markaAdi[0].toUpperCase() : 'M', style: const TextStyle(fontWeight: FontWeight.bold, color: UygulamaRenkleri.acikMor))
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(child: Text(ilan.markaAdi, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14), overflow: TextOverflow.ellipsis)),
                            const SizedBox(width: 4),
                            const Icon(Icons.verified_rounded, size: 15, color: UygulamaRenkleri.acikMor),
                          ],
                        ),
                        Text(ilan.platform, style: const TextStyle(fontSize: 12, color: UygulamaRenkleri.metinGri)),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: UygulamaRenkleri.anaMor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: UygulamaRenkleri.anaMor.withValues(alpha: 0.3)),
                    ),
                    child: Text(ilan.kategori, style: const TextStyle(fontSize: 11, color: UygulamaRenkleri.acikMor, fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(ilan.baslik, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, height: 1.3)),
              const SizedBox(height: 6),
              Text(ilan.aciklama, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 13, color: UygulamaRenkleri.metinGri, height: 1.4)),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.handshake_outlined, size: 16, color: UygulamaRenkleri.sariVurgu),
                      const SizedBox(width: 6),
                      Text(ilan.butceTuru, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: UygulamaRenkleri.sariVurgu)),
                    ],
                  ),
                  if (basvurduMu || basvuruDurumu != null)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: rozetRengi.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: rozetRengi),
                      ),
                      child: Row(
                        children: [
                          Icon(reddedildi ? Icons.cancel_rounded : Icons.check_circle_rounded, size: 14, color: rozetRengi),
                          const SizedBox(width: 4),
                          Text(
                            reddedildi ? 'Reddedildi' : 'Başvuruldu',
                            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: rozetRengi),
                          ),
                        ],
                      ),
                    )
                  else
                    const Row(
                      children: [
                        Text('Detaylar', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: UygulamaRenkleri.acikMor)),
                        SizedBox(width: 4),
                        Icon(Icons.arrow_forward_ios_rounded, size: 12, color: UygulamaRenkleri.acikMor),
                      ],
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
