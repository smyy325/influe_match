import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/renkler.dart';
import '../../../core/helpers/resim_saglayici_yardimcisi.dart';
import '../models/sohbet_odasi_modeli.dart';

class SohbetSatiriBileseni extends StatelessWidget {
  final SohbetOdasiModeli oda;
  final VoidCallback onTap;

  const SohbetSatiriBileseni({
    super.key,
    required this.oda,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final saatFormat = DateFormat('HH:mm');
    final formattedSaat = saatFormat.format(oda.sonMesajZamani);
    final fotoSaglayici = ResimSaglayiciYardimcisi.saglayici(oda.karsiTarafProfil);

    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        radius: 24,
        backgroundImage: fotoSaglayici,
        backgroundColor: UygulamaRenkleri.anaMor.withValues(alpha: 0.2),
        child: fotoSaglayici == null
            ? Text(
                oda.karsiTarafAdi.isNotEmpty ? oda.karsiTarafAdi[0].toUpperCase() : 'S',
                style: const TextStyle(fontWeight: FontWeight.bold, color: UygulamaRenkleri.acikMor),
              )
            : null,
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              oda.karsiTarafAdi,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            formattedSaat,
            style: const TextStyle(fontSize: 11, color: UygulamaRenkleri.metinGri),
          ),
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 2),
          Text(
            'İlan: ${oda.ilanBasligi}',
            style: const TextStyle(fontSize: 11, color: UygulamaRenkleri.acikMor),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            oda.sonMesaj,
            style: TextStyle(
              fontSize: 13,
              color: oda.okunmamisAdet > 0 ? Colors.white : UygulamaRenkleri.metinGri,
              fontWeight: oda.okunmamisAdet > 0 ? FontWeight.w600 : FontWeight.normal,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
      trailing: oda.okunmamisAdet > 0
          ? Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: UygulamaRenkleri.anaMor,
                shape: BoxShape.circle,
              ),
              child: Text(
                '${oda.okunmamisAdet}',
                style: const TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.bold),
              ),
            )
          : null,
    );
  }
}

