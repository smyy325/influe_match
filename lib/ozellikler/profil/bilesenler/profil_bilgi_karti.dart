import 'package:flutter/material.dart';
import '../../../cekirdek/sabitler/renkler.dart';

class ProfilBilgiKarti extends StatelessWidget {
  final IconData ikon;
  final String baslik;
  final String deger;

  const ProfilBilgiKarti({
    super.key,
    required this.ikon,
    required this.baslik,
    required this.deger,
  });

  @override
  Widget build(BuildContext context) {
    final koyuMu = Theme.of(context).brightness == Brightness.dark;
    final kartRengi = koyuMu ? UygulamaRenkleri.koyuYuzey : UygulamaRenkleri.acikYuzey;
    final kenarlikRengi = koyuMu ? UygulamaRenkleri.koyuKenarlik : UygulamaRenkleri.acikKenarlik;
    final metinRengi = koyuMu ? Colors.white : UygulamaRenkleri.metinKoyu;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: kartRengi,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kenarlikRengi),
      ),
      child: Row(
        children: [
          Icon(ikon, size: 20, color: koyuMu ? UygulamaRenkleri.acikMor : UygulamaRenkleri.anaMor),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  baslik,
                  style: const TextStyle(fontSize: 11, color: UygulamaRenkleri.metinGri, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 2),
                Text(
                  deger,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: metinRengi),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProfilOzetKutusu extends StatelessWidget {
  final String baslik;
  final Widget icerik;

  const ProfilOzetKutusu({super.key, required this.baslik, required this.icerik});

  @override
  Widget build(BuildContext context) {
    final koyuMu = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: koyuMu ? UygulamaRenkleri.koyuYuzey : UygulamaRenkleri.acikYuzey,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: koyuMu ? UygulamaRenkleri.koyuKenarlik : UygulamaRenkleri.acikKenarlik),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            baslik,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: koyuMu ? Colors.white : UygulamaRenkleri.metinKoyu),
          ),
          const SizedBox(height: 8),
          icerik,
        ],
      ),
    );
  }
}

class ProfilRozetCipi extends StatelessWidget {
  final String metin;
  final Color renk;

  const ProfilRozetCipi({super.key, required this.metin, required this.renk});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: renk.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: renk.withValues(alpha: 0.3)),
      ),
      child: Text(metin, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: renk)),
    );
  }
}

class ProfilFormEtiketi extends StatelessWidget {
  final String metin;

  const ProfilFormEtiketi(this.metin, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(metin, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
    );
  }
}
