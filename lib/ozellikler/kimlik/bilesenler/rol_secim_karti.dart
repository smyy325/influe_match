import 'package:flutter/material.dart';
import '../../../cekirdek/sabitler/renkler.dart';
import '../model/kullanici_modeli.dart';

class RolSecimKarti extends StatelessWidget {
  final Rol rol;
  final Rol seciliRol;
  final IconData ikon;
  final String baslik;
  final String aciklama;
  final ValueChanged<Rol> onRolSecildi;

  const RolSecimKarti({
    super.key,
    required this.rol,
    required this.seciliRol,
    required this.ikon,
    required this.baslik,
    required this.aciklama,
    required this.onRolSecildi,
  });

  @override
  Widget build(BuildContext context) {
    final secili = rol == seciliRol;
    return Expanded(
      child: GestureDetector(
        onTap: () => onRolSecildi(rol),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: secili
                ? UygulamaRenkleri.anaMor.withValues(alpha: 0.2)
                : UygulamaRenkleri.koyuYuzey,
            border: Border.all(
              color: secili ? UygulamaRenkleri.anaMor : UygulamaRenkleri.koyuKenarlik,
              width: secili ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              Icon(
                ikon,
                size: 32,
                color: secili ? UygulamaRenkleri.acikMor : UygulamaRenkleri.metinGri,
              ),
              const SizedBox(height: 8),
              Text(
                baslik,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                aciklama,
                style: const TextStyle(fontSize: 11, color: UygulamaRenkleri.metinGri),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

