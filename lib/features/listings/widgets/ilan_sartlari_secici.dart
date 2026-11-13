import 'package:flutter/material.dart';

import '../../../core/constants/renkler.dart';

class IlanSartlariSecici extends StatelessWidget {
  final List<String> sartlar;
  final TextEditingController yeniSartKontrolcu;
  final VoidCallback onSartEkle;
  final void Function(int index) onSartSil;

  const IlanSartlariSecici({
    super.key,
    required this.sartlar,
    required this.yeniSartKontrolcu,
    required this.onSartEkle,
    required this.onSartSil,
  });

  @override
  Widget build(BuildContext context) {
    final koyuMu = Theme.of(context).brightness == Brightness.dark;
    final kartRengi = koyuMu ? UygulamaRenkleri.koyuYuzey : UygulamaRenkleri.acikYuzey;
    final kenarlikRengi = koyuMu ? UygulamaRenkleri.koyuKenarlik : UygulamaRenkleri.acikKenarlik;
    final metinRengi = koyuMu ? Colors.white : UygulamaRenkleri.metinKoyu;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Katılım Şartları & Beklentiler',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            Text(
              '${sartlar.length} Şart',
              style: TextStyle(fontSize: 12, color: koyuMu ? UygulamaRenkleri.acikMor : UygulamaRenkleri.anaMor, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: yeniSartKontrolcu,
                decoration: const InputDecoration(
                  hintText: 'Şart ekle (örn: #etiket kullanımı)',
                  isDense: true,
                ),
                onSubmitted: (_) => onSartEkle(),
              ),
            ),
            const SizedBox(width: 8),
            IconButton.filled(
              onPressed: onSartEkle,
              style: IconButton.styleFrom(
                backgroundColor: UygulamaRenkleri.anaMor,
                foregroundColor: Colors.white,
              ),
              icon: const Icon(Icons.add_rounded),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...sartlar.asMap().entries.map((entry) {
          final idx = entry.key;
          final sart = entry.value;
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: kartRengi,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: kenarlikRengi),
            ),
            child: Row(
              children: [
                const Icon(Icons.check_rounded, size: 16, color: UygulamaRenkleri.naneYesili),
                const SizedBox(width: 8),
                Expanded(child: Text(sart, style: TextStyle(fontSize: 13, color: metinRengi, fontWeight: FontWeight.w500))),
                IconButton(
                  icon: const Icon(Icons.close_rounded, size: 16, color: UygulamaRenkleri.metinGri),
                  onPressed: () => onSartSil(idx),
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}
