import 'package:flutter/material.dart';

import '../../../core/constants/renkler.dart';

class IlanBilgileriFormu extends StatelessWidget {
  final TextEditingController baslikKontrolcu;
  final TextEditingController aciklamaKontrolcu;
  final TextEditingController hedefInfluencerKontrolcu;
  final String seciliKategori;
  final String seciliPlatform;
  final String seciliButceTuru;
  final List<String> kategoriler;
  final List<String> platformlar;
  final List<String> butceModelleri;
  final ValueChanged<String?> onKategoriDegisti;
  final ValueChanged<String?> onPlatformDegisti;
  final ValueChanged<String?> onButceDegisti;

  const IlanBilgileriFormu({
    super.key,
    required this.baslikKontrolcu,
    required this.aciklamaKontrolcu,
    required this.hedefInfluencerKontrolcu,
    required this.seciliKategori,
    required this.seciliPlatform,
    required this.seciliButceTuru,
    required this.kategoriler,
    required this.platformlar,
    required this.butceModelleri,
    required this.onKategoriDegisti,
    required this.onPlatformDegisti,
    required this.onButceDegisti,
  });

  @override
  Widget build(BuildContext context) {
    final koyuMu = Theme.of(context).brightness == Brightness.dark;
    final dropdownRengi = koyuMu ? UygulamaRenkleri.koyuYuzey : UygulamaRenkleri.acikYuzey;
    final metinRengi = koyuMu ? Colors.white : UygulamaRenkleri.metinKoyu;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text('Kampanya Başlığı', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        const SizedBox(height: 6),
        TextFormField(
          controller: baslikKontrolcu,
          validator: (v) => v == null || v.trim().isEmpty ? 'Başlık zorunludur' : null,
          decoration: const InputDecoration(hintText: 'Örn: Yeni Parfüm Lansmanı İçin Reels İş Birliği'),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            const Text('Hedef Influencer', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: UygulamaRenkleri.sariVurgu.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: UygulamaRenkleri.sariVurgu.withValues(alpha: 0.5)),
              ),
              child: const Text('Opsiyonel / Özel Teklif', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: UygulamaRenkleri.sariVurgu)),
            ),
          ],
        ),
        const SizedBox(height: 4),
        const Text(
          'Belirli bir kullanıcıya özel ilan açmak için adını girin (Örn: Sümeyye). Sadece o influencer görür.',
          style: TextStyle(fontSize: 11, color: UygulamaRenkleri.metinGri),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: hedefInfluencerKontrolcu,
          decoration: const InputDecoration(
            hintText: 'Örn: Sümeyye (Boş bırakılırsa tüm influencer\'lar görür)',
            prefixIcon: Icon(Icons.person_pin_rounded, color: UygulamaRenkleri.sariVurgu),
          ),
        ),
        const SizedBox(height: 16),
        const Text('Kategori', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          initialValue: seciliKategori,
          dropdownColor: dropdownRengi,
          items: kategoriler.map((k) => DropdownMenuItem(value: k, child: Text(k, style: TextStyle(color: metinRengi)))).toList(),
          onChanged: onKategoriDegisti,
        ),
        const SizedBox(height: 16),
        const Text('Hedef Platform', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          initialValue: seciliPlatform,
          dropdownColor: dropdownRengi,
          items: platformlar.map((p) => DropdownMenuItem(value: p, child: Text(p, style: TextStyle(color: metinRengi)))).toList(),
          onChanged: onPlatformDegisti,
        ),
        const SizedBox(height: 16),
        const Text('İş Birliği & Bütçe Modeli', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          initialValue: seciliButceTuru,
          dropdownColor: dropdownRengi,
          items: butceModelleri.map((b) => DropdownMenuItem(value: b, child: Text(b, style: TextStyle(color: metinRengi)))).toList(),
          onChanged: onButceDegisti,
        ),
        const SizedBox(height: 16),
        const Text('Kampanya Açıklaması & Brief', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        const SizedBox(height: 6),
        TextFormField(
          controller: aciklamaKontrolcu,
          maxLines: 4,
          validator: (v) => v == null || v.trim().length < 15 ? 'Lütfen en az 15 karakterlik açıklama giriniz' : null,
          decoration: const InputDecoration(hintText: 'Influencer\'lardan beklentiniz, ürün özellikleri ve video konsepti...'),
        ),
      ],
    );
  }
}
