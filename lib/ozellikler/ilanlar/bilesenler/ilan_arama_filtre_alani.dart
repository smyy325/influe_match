import 'package:flutter/material.dart';
import '../../../cekirdek/sabitler/renkler.dart';

class IlanAramaFiltreAlani extends StatelessWidget {
  final TextEditingController aramaKontrolcu;
  final String seciliKategori;
  final List<String> kategoriler;
  final VoidCallback onAramaDegisti;
  final ValueChanged<String> onKategoriSecildi;

  const IlanAramaFiltreAlani({
    super.key,
    required this.aramaKontrolcu,
    required this.seciliKategori,
    required this.kategoriler,
    required this.onAramaDegisti,
    required this.onKategoriSecildi,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Column(
        children: [
          TextField(
            controller: aramaKontrolcu,
            onChanged: (val) => onAramaDegisti(),
            decoration: InputDecoration(
              hintText: 'Marka, kampanya veya anahtar kelime ara...',
              prefixIcon: const Icon(Icons.search_rounded),
              suffixIcon: aramaKontrolcu.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear_rounded, size: 18),
                      onPressed: () {
                        aramaKontrolcu.clear();
                        onAramaDegisti();
                      },
                    )
                  : null,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 38,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: kategoriler.length,
              separatorBuilder: (context, index) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final kat = kategoriler[index];
                final secili = seciliKategori == kat;
                return ChoiceChip(
                  label: Text(kat),
                  selected: secili,
                  selectedColor: UygulamaRenkleri.anaMor,
                  onSelected: (selected) {
                    if (selected) {
                      onKategoriSecildi(kat);
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

