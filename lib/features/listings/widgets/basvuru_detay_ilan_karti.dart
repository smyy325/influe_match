import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/renkler.dart';
import '../models/basvuru_modeli.dart';

class BasvuruDetayIlanKarti extends StatelessWidget {
  final BasvuruModeli basvuru;

  const BasvuruDetayIlanKarti({super.key, required this.basvuru});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      future: FirebaseFirestore.instance.collection('ilanlar').doc(basvuru.ilanId).get(),
      builder: (context, snapshot) {
        final data = snapshot.data?.data() ?? {};
        final aciklama = data['aciklama'] ?? 'İlan detayları yükleniyor...';
        final kategori = data['kategori'] ?? 'Genel';
        final platform = data['platform'] ?? 'Instagram';
        final butce = data['butceTuru'] ?? 'İş Birliği';
        final koyuMu = Theme.of(context).brightness == Brightness.dark;

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: koyuMu ? UygulamaRenkleri.koyuYuzey : UygulamaRenkleri.acikYuzey,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: koyuMu ? UygulamaRenkleri.koyuKenarlik : UygulamaRenkleri.acikKenarlik),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Kampanya İlanı', style: TextStyle(fontSize: 12, color: UygulamaRenkleri.metinGri, fontWeight: FontWeight.bold)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: UygulamaRenkleri.anaMor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(kategori, style: const TextStyle(fontSize: 11, color: UygulamaRenkleri.acikMor, fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(basvuru.ilanBasligi, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              Text(aciklama, style: const TextStyle(fontSize: 13, color: UygulamaRenkleri.metinGri, height: 1.4), maxLines: 3, overflow: TextOverflow.ellipsis),
              const SizedBox(height: 10),
              Wrap(
                spacing: 12,
                runSpacing: 6,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.hub_outlined, size: 14, color: UygulamaRenkleri.acikMor),
                      const SizedBox(width: 4),
                      Text(platform, style: const TextStyle(fontSize: 12, color: Colors.white70)),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.handshake_outlined, size: 14, color: UygulamaRenkleri.sariVurgu),
                      const SizedBox(width: 4),
                      Text(butce, style: const TextStyle(fontSize: 12, color: UygulamaRenkleri.sariVurgu)),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

