import 'package:flutter/material.dart';
import '../../../cekirdek/sabitler/renkler.dart';

class TanitimSayfasiBileseni extends StatelessWidget {
  final IconData ikon;
  final String rozetMetni;
  final Color rozetRengi;
  final Gradient gradyan;
  final String baslik;
  final String aciklama;
  final List<String> maddeler;

  const TanitimSayfasiBileseni({
    super.key,
    required this.ikon,
    required this.rozetMetni,
    required this.rozetRengi,
    required this.gradyan,
    required this.baslik,
    required this.aciklama,
    required this.maddeler,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Column(
        children: [
          const SizedBox(height: 10),
          Container(
            width: 110,
            height: 110,
            decoration: BoxDecoration(
              gradient: gradyan,
              borderRadius: BorderRadius.circular(32),
              boxShadow: [
                BoxShadow(
                  color: rozetRengi.withValues(alpha: 0.35),
                  blurRadius: 28,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Icon(ikon, size: 54, color: Colors.white),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: rozetRengi.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: rozetRengi.withValues(alpha: 0.3)),
            ),
            child: Text(
              rozetMetni,
              style: TextStyle(
                color: rozetRengi,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            baslik,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              height: 1.3,
              letterSpacing: -0.5,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            aciklama,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              color: UygulamaRenkleri.metinGri,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: UygulamaRenkleri.koyuYuzey,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: UygulamaRenkleri.koyuKenarlik),
            ),
            child: Column(
              children: maddeler.map((madde) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle_rounded, size: 18, color: rozetRengi),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          madde,
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

