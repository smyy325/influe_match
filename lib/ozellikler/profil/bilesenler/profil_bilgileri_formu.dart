import 'package:flutter/material.dart';
import '../../../cekirdek/sabitler/renkler.dart';
import 'influencer_tercihleri_alani.dart';
import 'profil_bilgi_karti.dart';
import 'profil_onay_diyaloglari.dart';

class ProfilBilgileriFormu extends StatelessWidget {
  final TextEditingController adSoyadKontrolcu;
  final TextEditingController emailKontrolcu;
  final TextEditingController telefonKontrolcu;
  final TextEditingController konumKontrolcu;
  final TextEditingController sosyalMedyaKontrolcu;
  final TextEditingController biyografiKontrolcu;
  final bool influencerMi;
  final List<String> seciliTercihler;
  final Function(String) onTercihDegisti;

  const ProfilBilgileriFormu({
    super.key,
    required this.adSoyadKontrolcu,
    required this.emailKontrolcu,
    required this.telefonKontrolcu,
    required this.konumKontrolcu,
    required this.sosyalMedyaKontrolcu,
    required this.biyografiKontrolcu,
    this.influencerMi = false,
    this.seciliTercihler = const [],
    required this.onTercihDegisti,
  });

  Widget _metinAlani({
    required String etiket,
    required TextEditingController kontrolcu,
    required String ipucu,
    required IconData ikon,
    TextInputType? tip,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProfilFormEtiketi(etiket),
        TextField(
          controller: kontrolcu,
          keyboardType: tip,
          maxLines: maxLines,
          decoration: InputDecoration(hintText: ipucu, prefixIcon: Icon(ikon, size: 20)),
        ),
        const SizedBox(height: 14),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _metinAlani(etiket: influencerMi ? 'Ad - Soyad' : 'Marka / Şirket Adı', kontrolcu: adSoyadKontrolcu, ipucu: 'Adınız', ikon: Icons.person_outline_rounded),
        _metinAlani(etiket: 'E-Mail', kontrolcu: emailKontrolcu, ipucu: 'E-posta adresiniz', ikon: Icons.email_outlined, tip: TextInputType.emailAddress),
        _metinAlani(etiket: 'Telefon', kontrolcu: telefonKontrolcu, ipucu: '+90 5XX XXX XX XX', ikon: Icons.phone_outlined, tip: TextInputType.phone),
        _metinAlani(etiket: 'Konum', kontrolcu: konumKontrolcu, ipucu: 'Örn: İstanbul / Beşiktaş', ikon: Icons.location_on_outlined),
        _metinAlani(etiket: influencerMi ? 'Sosyal Medya' : 'Web Sitesi / Hesap', kontrolcu: sosyalMedyaKontrolcu, ipucu: 'Örn: @kullaniciadi', ikon: Icons.alternate_email_rounded),
        _metinAlani(etiket: influencerMi ? 'Biyografi' : 'Marka Hakkında', kontrolcu: biyografiKontrolcu, ipucu: 'Bahsedin...', ikon: Icons.description_outlined, maxLines: 3),
        if (influencerMi)
          InfluencerTercihleriAlani(
            seciliTercihler: seciliTercihler,
            duzenlemeModu: true,
            onTercihDegisti: onTercihDegisti,
          ),
        const SizedBox(height: 18),
        OutlinedButton.icon(
          onPressed: () => ProfilOnayDiyaloglari.cikisYap(context),
          icon: const Icon(Icons.logout_rounded, color: UygulamaRenkleri.acikMor, size: 18),
          label: const Text('Çıkış Yap', style: TextStyle(color: Colors.white)),
          style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14), side: const BorderSide(color: UygulamaRenkleri.koyuKenarlik)),
        ),
        const SizedBox(height: 10),
        OutlinedButton.icon(
          onPressed: () => ProfilOnayDiyaloglari.hesabiSil(context),
          icon: const Icon(Icons.delete_forever_rounded, color: UygulamaRenkleri.mercan, size: 18),
          label: const Text('Hesabı Sil', style: TextStyle(color: UygulamaRenkleri.mercan)),
          style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14), side: BorderSide(color: UygulamaRenkleri.mercan.withValues(alpha: 0.5))),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
