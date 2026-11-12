import 'package:flutter/material.dart';
import '../../../cekirdek/sabitler/renkler.dart';
import '../model/basvuru_modeli.dart';

class BasvuruDetayAksiyonButonlari extends StatelessWidget {
  final BasvuruDurumu durum;
  final bool markaMi;
  final Function(BasvuruDurumu) onDurumDegistir;

  const BasvuruDetayAksiyonButonlari({
    super.key,
    required this.durum,
    required this.markaMi,
    required this.onDurumDegistir,
  });

  @override
  Widget build(BuildContext context) {
    if (!markaMi) {
      final metin = switch (durum) {
        BasvuruDurumu.beklemede => 'Başvurunuz marka tarafından değerlendiriliyor.',
        BasvuruDurumu.kabulEdildi => 'Tebrikler! Başvurunuz kabul edildi. Marka sizinle sohbet üzerinden iletişime geçecektir.',
        BasvuruDurumu.reddedildi => 'Bu kampanya başvurunuz bu seferlik onaylanmadı.',
      };
      final renk = switch (durum) {
        BasvuruDurumu.beklemede => UygulamaRenkleri.sariVurgu,
        BasvuruDurumu.kabulEdildi => UygulamaRenkleri.naneYesili,
        BasvuruDurumu.reddedildi => UygulamaRenkleri.mercan,
      };

      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: renk.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: renk),
        ),
        child: Text(metin, style: TextStyle(color: renk, fontWeight: FontWeight.bold, fontSize: 13), textAlign: TextAlign.center),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (durum == BasvuruDurumu.beklemede) ...[
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => onDurumDegistir(BasvuruDurumu.reddedildi),
                  icon: const Icon(Icons.close_rounded, color: UygulamaRenkleri.mercan),
                  label: const Text('Reddet', style: TextStyle(color: UygulamaRenkleri.mercan, fontWeight: FontWeight.bold)),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: const BorderSide(color: UygulamaRenkleri.mercan),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => onDurumDegistir(BasvuruDurumu.kabulEdildi),
                  icon: const Icon(Icons.check_rounded, color: Colors.white),
                  label: const Text('Kabul Et', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: UygulamaRenkleri.naneYesili,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ],
          ),
        ] else ...[
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: durum == BasvuruDurumu.kabulEdildi ? UygulamaRenkleri.naneYesili.withValues(alpha: 0.15) : UygulamaRenkleri.mercan.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: durum == BasvuruDurumu.kabulEdildi ? UygulamaRenkleri.naneYesili : UygulamaRenkleri.mercan),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(durum == BasvuruDurumu.kabulEdildi ? Icons.check_circle_rounded : Icons.cancel_rounded, color: durum == BasvuruDurumu.kabulEdildi ? UygulamaRenkleri.naneYesili : UygulamaRenkleri.mercan, size: 20),
                const SizedBox(width: 8),
                Text(
                  durum == BasvuruDurumu.kabulEdildi ? 'Başvuru Kabul Edildi' : 'Başvuru Reddedildi',
                  style: TextStyle(fontWeight: FontWeight.bold, color: durum == BasvuruDurumu.kabulEdildi ? UygulamaRenkleri.naneYesili : UygulamaRenkleri.mercan),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          TextButton(
            onPressed: () => onDurumDegistir(durum == BasvuruDurumu.kabulEdildi ? BasvuruDurumu.reddedildi : BasvuruDurumu.kabulEdildi),
            child: Text(durum == BasvuruDurumu.kabulEdildi ? 'Kararı Reddet Olarak Değiştir' : 'Kararı Kabul Et Olarak Değiştir', style: const TextStyle(color: UygulamaRenkleri.acikMor, fontSize: 13)),
          ),
        ],
      ],
    );
  }
}

