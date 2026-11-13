import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/renkler.dart';
import '../../../core/helpers/resim_saglayici_yardimcisi.dart';
import '../models/basvuru_modeli.dart';
class BasvuruDetayInfluencerKarti extends StatelessWidget {
  final BasvuruModeli basvuru;
  final VoidCallback onMesajlas;

  const BasvuruDetayInfluencerKarti({
    super.key,
    required this.basvuru,
    required this.onMesajlas,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      future: FirebaseFirestore.instance.collection('kullanicilar').doc(basvuru.influencerId).get(),
      builder: (context, snapshot) {
        final data = snapshot.data?.data() ?? {};
        final biyografi = data['biyografi'] ?? '';
        final takipci = data['takipciSayisi'] ?? '10K+';
        final sosyalMedya = data['sosyalMedyaHesabi'] ?? '@influencer';
        final konum = data['konum'] ?? 'Türkiye';
        final profilFoto = (data['profilResmi'] ?? basvuru.influencerProfil).toString();
        final fotoSaglayici = ResimSaglayiciYardimcisi.saglayici(profilFoto);
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
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () => context.push('/kullanici-profil/${basvuru.influencerId}'),
                      borderRadius: BorderRadius.circular(12),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 26,
                            backgroundImage: fotoSaglayici,
                            backgroundColor: UygulamaRenkleri.anaMor.withValues(alpha: 0.2),
                            child: fotoSaglayici == null
                                ? Text(
                                    basvuru.influencerAdi.isNotEmpty ? basvuru.influencerAdi[0].toUpperCase() : 'I',
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: UygulamaRenkleri.acikMor),
                                  )
                                : null,
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Flexible(child: Text(basvuru.influencerAdi, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
                                    const SizedBox(width: 4),
                                    const Icon(Icons.chevron_right_rounded, size: 16, color: UygulamaRenkleri.acikMor),
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '$sosyalMedya • $takipci • $konum',
                                  style: const TextStyle(fontSize: 12, color: UygulamaRenkleri.metinGri),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  IconButton.filledTonal(
                    icon: const Icon(Icons.chat_bubble_outline_rounded, size: 20),
                    onPressed: onMesajlas,
                  ),
                ],
              ),
              if (biyografi.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(biyografi, style: const TextStyle(fontSize: 13, color: Colors.white70, height: 1.4)),
              ],
              const SizedBox(height: 14),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: koyuMu ? UygulamaRenkleri.koyuArkaPlan : UygulamaRenkleri.acikKenarlik.withValues(alpha: 0.35),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Başvuru Pitch Notu:', style: TextStyle(fontSize: 11, color: UygulamaRenkleri.metinGri, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Text(basvuru.basvuruNotu, style: const TextStyle(fontSize: 13, height: 1.4)),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

