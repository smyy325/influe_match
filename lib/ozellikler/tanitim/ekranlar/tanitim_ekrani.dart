import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../cekirdek/sabitler/renkler.dart';
import '../bilesenler/tanitim_sayfasi_bileseni.dart';

class TanitimEkrani extends StatefulWidget {
  const TanitimEkrani({super.key});

  @override
  State<TanitimEkrani> createState() => _TanitimEkraniState();
}

class _TanitimEkraniState extends State<TanitimEkrani> {
  final PageController _sayfaKontrolcu = PageController();
  int _aktifSayfa = 0;

  @override
  void dispose() {
    _sayfaKontrolcu.dispose();
    super.dispose();
  }

  void _giriseGit() => context.push('/giris');
  void _kayitaGit() => context.push('/kayit');

  Widget _sayfaGostergesi() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(2, (index) {
        final secili = _aktifSayfa == index;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: secili ? 28 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: secili ? UygulamaRenkleri.anaMor : UygulamaRenkleri.koyuKenarlik,
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }

  Widget _altButonlar() {
    if (_aktifSayfa == 0) {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () => _sayfaKontrolcu.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut),
          style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Markaları Keşfet', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(width: 8),
              Icon(Icons.arrow_forward_rounded, size: 20),
            ],
          ),
        ),
      );
    }
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _giriseGit,
            style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16), backgroundColor: UygulamaRenkleri.anaMor),
            child: const Text('Giriş Yap', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: _kayitaGit,
            style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16), side: const BorderSide(color: UygulamaRenkleri.acikMor)),
            child: const Text('Ücretsiz Kayıt Ol', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UygulamaRenkleri.koyuArkaPlan,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: _giriseGit,
            child: const Text('Atla', style: TextStyle(color: UygulamaRenkleri.metinGri, fontSize: 14, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _sayfaKontrolcu,
                onPageChanged: (i) => setState(() => _aktifSayfa = i),
                children: const [
                  TanitimSayfasiBileseni(
                    ikon: Icons.auto_awesome_rounded,
                    rozetMetni: 'İçerik Üreticileri İçin',
                    rozetRengi: UygulamaRenkleri.anaMor,
                    gradyan: UygulamaRenkleri.morGradyan,
                    baslik: 'Yaratıcılığınla Markaları Büyüt',
                    aciklama: 'En popüler markaların güncel kampanyalarını keşfet. Ürün hediyeli veya bütçeli projelere hemen başvur.',
                    maddeler: [
                      'İlana özel pitch & içerik fikri gönderme',
                      'Şeffaf ve anlık başvuru süreci takibi',
                      'Markalarla ilana özel canlı sohbet',
                    ],
                  ),
                  TanitimSayfasiBileseni(
                    ikon: Icons.business_center_rounded,
                    rozetMetni: 'Markalar & Ajanslar İçin',
                    rozetRengi: UygulamaRenkleri.pembe,
                    gradyan: LinearGradient(colors: [UygulamaRenkleri.pembe, UygulamaRenkleri.mercan]),
                    baslik: 'En Doğru İçerik Üreticilerini Keşfet',
                    aciklama: 'Dakikalar içinde yeni kampanya yayınla. Hedef kitlene en uygun influencer\'ların tekliflerini incele.',
                    maddeler: [
                      'Saniyeler içinde bütçeli veya hediyeli ilan açma',
                      'Gelen başvuruları tek panelden filtreleme',
                      'Yüksek etkileşimli profillerle doğrudan temas',
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(children: [_sayfaGostergesi(), const SizedBox(height: 28), _altButonlar()]),
            ),
          ],
        ),
      ),
    );
  }
}
