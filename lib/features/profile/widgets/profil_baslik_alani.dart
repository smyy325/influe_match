import 'dart:io';
import 'package:flutter/material.dart';
import '../../../core/constants/renkler.dart';
import '../../auth/models/kullanici_modeli.dart';
import 'profil_resim_yardimcisi.dart';

class ProfilBaslikAlani extends StatelessWidget {
  final KullaniciModeli kullanici;
  final String seciliFotoUrl;
  final File? secilenDosya;
  final Function(String base64, File dosya) onFotoSecildi;
  final VoidCallback onFotoSilindi;

  const ProfilBaslikAlani({
    super.key,
    required this.kullanici,
    required this.seciliFotoUrl,
    required this.secilenDosya,
    required this.onFotoSecildi,
    required this.onFotoSilindi,
  });

  @override
  Widget build(BuildContext context) {
    final saglayici = ProfilResimYardimcisi.resimSaglayici(
      secilenDosya: secilenDosya,
      seciliFotoUrl: seciliFotoUrl,
      yedekFotoUrl: kullanici.profilResmi,
    );
    final fotoVar = seciliFotoUrl.isNotEmpty ||
        secilenDosya != null ||
        kullanici.profilResmi.isNotEmpty;

    return Column(
      children: [
        GestureDetector(
          onTap: () => ProfilResimYardimcisi.fotoSecimMenusu(
            context: context,
            fotoVarMi: fotoVar,
            onSecildi: onFotoSecildi,
            onSilindi: onFotoSilindi,
          ),
          child: Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  gradient: UygulamaRenkleri.morGradyan,
                  shape: BoxShape.circle,
                ),
                child: CircleAvatar(
                  radius: 46,
                  backgroundImage: saglayici,
                  backgroundColor: Theme.of(context).cardColor,
                  child: saglayici == null
                      ? const Icon(Icons.person_rounded, size: 48, color: Colors.white38)
                      : null,
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: UygulamaRenkleri.anaMor,
                    shape: BoxShape.circle,
                    border: Border.all(color: Theme.of(context).scaffoldBackgroundColor, width: 2),
                  ),
                  child: const Icon(Icons.add_photo_alternate_rounded, size: 16, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Text(
          kullanici.adSoyad.isNotEmpty ? kullanici.adSoyad : 'Kullanıcı Adı',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        if (kullanici.profilTamamlandiMi)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: UygulamaRenkleri.anaMor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: UygulamaRenkleri.anaMor.withValues(alpha: 0.3),
              ),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.verified_rounded, size: 16, color: UygulamaRenkleri.acikMor),
                SizedBox(width: 6),
                Text(
                  'Doğrulanmış Profil',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: UygulamaRenkleri.acikMor,
                  ),
                ),
              ],
            ),
          )
        else
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: UygulamaRenkleri.sariVurgu.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  size: 15,
                  color: UygulamaRenkleri.sariVurgu,
                ),
                SizedBox(width: 6),
                Text(
                  'Profili Tamamlayın (Rozet İçin)',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: UygulamaRenkleri.sariVurgu,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
