import 'package:flutter/material.dart';
import '../../../cekirdek/sabitler/renkler.dart';
import '../model/kategori_tanimi.dart';
import 'kategori_karti_kutusu.dart';

class InfluencerTercihleriAlani extends StatelessWidget {
  final List<String> seciliTercihler;
  final bool duzenlemeModu;
  final Function(String kategori)? onTercihDegisti;
  final VoidCallback? onDuzenleTiklandi;

  const InfluencerTercihleriAlani({
    super.key,
    required this.seciliTercihler,
    this.duzenlemeModu = false,
    this.onTercihDegisti,
    this.onDuzenleTiklandi,
  });

  void _tiklandi(BuildContext context, String baslik) {
    if (!duzenlemeModu) {
      onDuzenleTiklandi?.call();
      return;
    }
    if (!seciliTercihler.contains(baslik) && seciliTercihler.length >= 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('En fazla 5 ilgi alanı seçebilirsiniz.'), duration: Duration(seconds: 2)),
      );
      return;
    }
    onTercihDegisti?.call(baslik);
  }

  Widget _baslikSatiri() {
    return Row(
      children: [
        const Icon(Icons.interests_rounded, size: 20, color: UygulamaRenkleri.acikMor),
        const SizedBox(width: 8),
        const Text('İlgi Alanları (Max 5)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
        const Spacer(),
        if (duzenlemeModu)
          Text('${seciliTercihler.length}/5 Ana Kategori', style: const TextStyle(fontSize: 12, color: UygulamaRenkleri.acikMor, fontWeight: FontWeight.bold))
        else if (onDuzenleTiklandi != null)
          GestureDetector(
            onTap: onDuzenleTiklandi,
            child: const Text('Düzenle', style: TextStyle(fontSize: 12, color: UygulamaRenkleri.acikMor, fontWeight: FontWeight.bold)),
          ),
      ],
    );
  }

  Widget _kartIzgarasi(BuildContext context, List<KategoriTanimi> liste) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: liste.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.95,
      ),
      itemBuilder: (context, index) {
        final kat = liste[index];
        final secili = seciliTercihler.contains(kat.baslik);
        return KategoriKartiKutusu(
          kategori: kat,
          secili: secili,
          onTap: () => _tiklandi(context, kat.baslik),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final koyuMu = Theme.of(context).brightness == Brightness.dark;
    final yuzeyRengi = koyuMu ? UygulamaRenkleri.koyuYuzey : UygulamaRenkleri.acikYuzey;
    final kenarlikRengi = koyuMu ? UygulamaRenkleri.koyuKenarlik : UygulamaRenkleri.acikKenarlik;

    final goruntulenecekListe = duzenlemeModu
        ? KategoriTanimi.tumKategoriler
        : KategoriTanimi.tumKategoriler.where((k) => seciliTercihler.contains(k.baslik)).toList();

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: yuzeyRengi,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: kenarlikRengi),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _baslikSatiri(),
          const SizedBox(height: 6),
          const Text(
            'Kategorilere tıklayarak profilinizle eşleşen ilgi alanlarını seçebilirsiniz.',
            style: TextStyle(fontSize: 12, color: UygulamaRenkleri.metinGri, height: 1.4),
          ),
          const SizedBox(height: 14),
          if (!duzenlemeModu && seciliTercihler.isEmpty) ...[
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Text('Henüz ilgi alanı seçilmedi.', style: TextStyle(fontSize: 13, color: UygulamaRenkleri.metinGri)),
              ),
            ),
            if (onDuzenleTiklandi != null) ...[
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: onDuzenleTiklandi,
                  icon: const Icon(Icons.add_rounded, size: 16, color: UygulamaRenkleri.acikMor),
                  label: const Text('İlgi Alanı Belirle', style: TextStyle(fontSize: 13, color: UygulamaRenkleri.acikMor)),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    side: const BorderSide(color: UygulamaRenkleri.anaMor),
                  ),
                ),
              ),
            ],
          ] else ...[
            _kartIzgarasi(context, goruntulenecekListe),
          ],
        ],
      ),
    );
  }
}
