import 'package:flutter/material.dart';

import '../../../core/constants/renkler.dart';

class IlanAkisiAppBari extends StatelessWidget implements PreferredSizeWidget {
  final bool markaMi;

  const IlanAkisiAppBari({super.key, required this.markaMi});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: UygulamaRenkleri.morGradyan,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.hub_rounded, size: 20, color: Colors.white),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('InflueMatch', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text(
                markaMi ? 'Marka Yönetim Paneli' : 'İçerik Üretici Keşif Akışı',
                style: const TextStyle(fontSize: 11, color: UygulamaRenkleri.metinGri),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
