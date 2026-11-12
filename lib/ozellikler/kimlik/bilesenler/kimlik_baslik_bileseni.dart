import 'package:flutter/material.dart';
import '../../../cekirdek/sabitler/renkler.dart';

class KimlikBaslikBileseni extends StatelessWidget {
  final String baslik;
  final String altBaslik;

  const KimlikBaslikBileseni({
    super.key,
    required this.baslik,
    required this.altBaslik,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: UygulamaRenkleri.morGradyan,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: UygulamaRenkleri.anaMor.withValues(alpha: 0.35),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const Icon(Icons.hub_rounded, size: 42, color: Colors.white),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          baslik,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          altBaslik,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 14, color: UygulamaRenkleri.metinGri),
        ),
      ],
    );
  }
}

