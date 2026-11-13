import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/renkler.dart';
import '../models/mesaj_modeli.dart';

class MesajBalonuBileseni extends StatelessWidget {
  final MesajModeli mesaj;
  final bool benimMesajim;

  const MesajBalonuBileseni({
    super.key,
    required this.mesaj,
    required this.benimMesajim,
  });

  @override
  Widget build(BuildContext context) {
    final saatFormat = DateFormat('HH:mm');
    final formattedSaat = saatFormat.format(mesaj.zaman);
    final koyuMu = Theme.of(context).brightness == Brightness.dark;

    final balonRengi = benimMesajim
        ? UygulamaRenkleri.anaMor
        : (koyuMu ? UygulamaRenkleri.koyuKart : UygulamaRenkleri.acikYuzey);
    final kenarlikRengi = benimMesajim
        ? Colors.transparent
        : (koyuMu ? UygulamaRenkleri.koyuKenarlik : UygulamaRenkleri.acikKenarlik);
    final metinRengi = benimMesajim
        ? Colors.white
        : (koyuMu ? Colors.white : UygulamaRenkleri.metinKoyu);

    return Align(
      alignment: benimMesajim ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.76,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: balonRengi,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(benimMesajim ? 16 : 4),
            bottomRight: Radius.circular(benimMesajim ? 4 : 16),
          ),
          border: Border.all(color: kenarlikRengi),
        ),
        child: Column(
          crossAxisAlignment: benimMesajim ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              mesaj.icerik,
              style: TextStyle(fontSize: 14, height: 1.4, color: metinRengi),
            ),
            const SizedBox(height: 4),
            Text(
              formattedSaat,
              style: TextStyle(
                fontSize: 10,
                color: benimMesajim ? Colors.white70 : UygulamaRenkleri.metinGri,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
