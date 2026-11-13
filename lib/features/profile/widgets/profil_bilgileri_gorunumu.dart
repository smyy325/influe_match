import 'package:flutter/material.dart';
import '../../../core/constants/renkler.dart';
import '../../auth/models/kullanici_modeli.dart';
import 'influencer_tercihleri_alani.dart';
import 'profil_bilgi_karti.dart';
import 'profil_onay_diyaloglari.dart';
import 'profil_tema_secici_karti.dart';

class ProfilBilgileriGorunumu extends StatelessWidget {
  final KullaniciModeli kullanici;
  final VoidCallback onDuzenleTiklandi;

  const ProfilBilgileriGorunumu({
    super.key,
    required this.kullanici,
    required this.onDuzenleTiklandi,
  });

  @override
  Widget build(BuildContext context) {
    final koyuMu = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ProfilBilgiKarti(
          ikon: Icons.person_rounded,
          baslik: kullanici.influencerMi ? 'Ad - Soyad' : 'Marka / Şirket Adı',
          deger: kullanici.adSoyad,
        ),
        ProfilBilgiKarti(
          ikon: Icons.email_rounded,
          baslik: 'E-Mail',
          deger: kullanici.email,
        ),
        ProfilBilgiKarti(
          ikon: Icons.phone_rounded,
          baslik: 'Telefon Numarası',
          deger: kullanici.telefon.isNotEmpty ? kullanici.telefon : 'Belirtilmedi',
        ),
        ProfilBilgiKarti(
          ikon: Icons.location_on_rounded,
          baslik: 'Konum',
          deger: kullanici.konum.isNotEmpty ? kullanici.konum : 'Belirtilmedi',
        ),
        ProfilBilgiKarti(
          ikon: Icons.alternate_email_rounded,
          baslik: kullanici.influencerMi ? 'Sosyal Medya' : 'Web Sitesi / Hesap',
          deger: kullanici.sosyalMedyaHesabi.isNotEmpty ? kullanici.sosyalMedyaHesabi : 'Belirtilmedi',
        ),
        if (kullanici.biyografi.isNotEmpty)
          ProfilBilgiKarti(
            ikon: Icons.info_outline_rounded,
            baslik: kullanici.influencerMi ? 'Biyografi & Hakkında' : 'Marka Açıklaması',
            deger: kullanici.biyografi,
          ),
        if (kullanici.influencerMi)
          InfluencerTercihleriAlani(
            seciliTercihler: kullanici.tercihler,
            duzenlemeModu: false,
            onDuzenleTiklandi: onDuzenleTiklandi,
          ),
        const SizedBox(height: 10),
        const ProfilTemaSeciciKarti(),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: onDuzenleTiklandi,
          icon: const Icon(Icons.edit_rounded, size: 18),
          label: const Text('Bilgileri Düzenle'),
          style: ElevatedButton.styleFrom(
            backgroundColor: UygulamaRenkleri.anaMor,
            padding: const EdgeInsets.symmetric(vertical: 14),
          ),
        ),
        const SizedBox(height: 14),
        OutlinedButton.icon(
          onPressed: () => ProfilOnayDiyaloglari.cikisYap(context),
          icon: const Icon(Icons.logout_rounded, color: UygulamaRenkleri.acikMor, size: 18),
          label: Text('Çıkış Yap', style: TextStyle(color: koyuMu ? Colors.white : UygulamaRenkleri.metinKoyu)),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 14),
            side: BorderSide(color: koyuMu ? UygulamaRenkleri.koyuKenarlik : UygulamaRenkleri.acikKenarlik),
          ),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: () => ProfilOnayDiyaloglari.hesabiSil(context),
          icon: const Icon(Icons.delete_forever_rounded, color: UygulamaRenkleri.mercan, size: 18),
          label: const Text('Hesabı Sil', style: TextStyle(color: UygulamaRenkleri.mercan)),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 14),
            side: BorderSide(color: UygulamaRenkleri.mercan.withValues(alpha: 0.5)),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
