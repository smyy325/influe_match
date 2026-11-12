import 'package:flutter/material.dart';
import '../../../cekirdek/sabitler/renkler.dart';

class BasvuruNotuKutusu extends StatelessWidget {
  final String not;

  const BasvuruNotuKutusu({super.key, required this.not});

  @override
  Widget build(BuildContext context) {
    final koyuMu = Theme.of(context).brightness == Brightness.dark;
    final arkaplan = koyuMu ? UygulamaRenkleri.koyuYuzey : UygulamaRenkleri.acikKenarlik.withValues(alpha: 0.35);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: arkaplan,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Başvuru Pitch Notu:',
            style: TextStyle(fontSize: 11, color: UygulamaRenkleri.metinGri, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          Text(not, style: const TextStyle(fontSize: 13, height: 1.4)),
        ],
      ),
    );
  }
}
