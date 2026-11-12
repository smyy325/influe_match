import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../cekirdek/sabitler/renkler.dart';
import '../model/ilan_modeli.dart';

class IlanDetayIcerik extends StatelessWidget {
  final IlanModeli ilan;

  const IlanDetayIcerik({super.key, required this.ilan});

  @override
  Widget build(BuildContext context) {
    final tarihFormat = DateFormat('dd MMMM yyyy', 'tr_TR');
    final formattedDate = tarihFormat.format(ilan.olusturulmaTarihi);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          ilan.baslik,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, height: 1.3),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: UygulamaRenkleri.anaMor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                ilan.platform,
                style: const TextStyle(fontSize: 12, color: UygulamaRenkleri.acikMor, fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(width: 10),
            Text(formattedDate, style: const TextStyle(fontSize: 12, color: UygulamaRenkleri.metinGri)),
          ],
        ),
        const SizedBox(height: 20),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: UygulamaRenkleri.kartGradyan,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: UygulamaRenkleri.koyuKenarlik),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: UygulamaRenkleri.sariVurgu.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.handshake_rounded, color: UygulamaRenkleri.sariVurgu),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('İş Birliği & Hak Ediş Modeli', style: TextStyle(fontSize: 12, color: UygulamaRenkleri.metinGri)),
                    const SizedBox(height: 2),
                    Text(ilan.butceTuru, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        const Text('Kampanya Açıklaması', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text(ilan.aciklama, style: const TextStyle(fontSize: 14, height: 1.6, color: Color(0xFFD1D5DB))),
        const SizedBox(height: 24),
        const Text('Katılım Şartları & Beklentiler', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        ...ilan.sartlar.map(
          (sart) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.check_circle_rounded, size: 18, color: UygulamaRenkleri.naneYesili),
                const SizedBox(width: 10),
                Expanded(child: Text(sart, style: const TextStyle(fontSize: 14, height: 1.4))),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

