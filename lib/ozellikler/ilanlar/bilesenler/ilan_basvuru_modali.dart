import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../../cekirdek/sabitler/renkler.dart';
import '../bloc/ilan_bloc.dart';
import '../bloc/ilan_event.dart';
import '../model/basvuru_modeli.dart';
import '../model/ilan_modeli.dart';

class IlanBasvuruModali {
  static void goster({
    required BuildContext context,
    required IlanModeli ilan,
    required String influencerId,
    required String influencerAdi,
    required String influencerProfil,
  }) {
    final notKontrolcu = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).cardTheme.color,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (modalContext) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 24,
            bottom: MediaQuery.of(modalContext).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'İş Birliği Başvurusu Yap',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.pop(modalContext),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Text(
                'Markaya kendinizi ve bu kampanya için aklınızdaki içerik fikrini kısaca anlatın.',
                style: TextStyle(fontSize: 13, color: UygulamaRenkleri.metinGri),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: notKontrolcu,
                maxLines: 4,
                decoration: const InputDecoration(
                  hintText: 'Örn: Merhaba, profilimde benzer konseptlerde Reels içerikleri üretiyorum. Kitlemle bu ürünü buluşturmaktan mutluluk duyarım...',
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                icon: const Icon(Icons.send_rounded, size: 18),
                label: const Text('Başvuruyu Gönder'),
                onPressed: () {
                  final not = notKontrolcu.text.trim();
                  if (not.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Lütfen kısa bir başvuru notu giriniz.')),
                    );
                    return;
                  }

                  final basvuru = BasvuruModeli(
                    id: const Uuid().v4(),
                    ilanId: ilan.id,
                    ilanBasligi: ilan.baslik,
                    markaId: ilan.markaId,
                    markaAdi: ilan.markaAdi,
                    influencerId: influencerId,
                    influencerAdi: influencerAdi,
                    influencerProfil: influencerProfil,
                    basvuruNotu: not,
                    tarih: DateTime.now(),
                  );

                  context.read<IlanBloc>().add(IlanaBasvurEvent(basvuru));
                  Navigator.pop(modalContext);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

