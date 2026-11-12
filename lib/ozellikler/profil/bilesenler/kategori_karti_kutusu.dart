import 'package:flutter/material.dart';
import '../../../cekirdek/sabitler/renkler.dart';
import '../model/kategori_tanimi.dart';

class KategoriKartiKutusu extends StatelessWidget {
  final KategoriTanimi kategori;
  final bool secili;
  final VoidCallback onTap;

  const KategoriKartiKutusu({
    super.key,
    required this.kategori,
    required this.secili,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final koyuMu = Theme.of(context).brightness == Brightness.dark;
    final yuzeyRengi = koyuMu ? UygulamaRenkleri.koyuYuzey : UygulamaRenkleri.acikYuzey;
    final kenarlikRengi = koyuMu ? UygulamaRenkleri.koyuKenarlik : UygulamaRenkleri.acikKenarlik;
    final metinRengi = secili
        ? (koyuMu ? Colors.white : UygulamaRenkleri.anaMor)
        : (koyuMu ? Colors.white70 : UygulamaRenkleri.metinKoyu);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        decoration: BoxDecoration(
          color: secili ? UygulamaRenkleri.anaMor.withValues(alpha: koyuMu ? 0.2 : 0.12) : yuzeyRengi,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: secili ? (koyuMu ? UygulamaRenkleri.acikMor : UygulamaRenkleri.anaMor) : kenarlikRengi,
            width: secili ? 2 : 1,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: kategori.renk.withValues(alpha: 0.18),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(kategori.ikon, size: 24, color: kategori.renk),
                ),
                if (secili)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: UygulamaRenkleri.anaMor,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.check_rounded, size: 12, color: Colors.white),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              kategori.baslik,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11,
                fontWeight: secili ? FontWeight.bold : FontWeight.w500,
                color: metinRengi,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
