import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/renkler.dart';
import '../../../core/theme/tema_cubit.dart';

class ProfilTemaSeciciKarti extends StatelessWidget {
  const ProfilTemaSeciciKarti({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TemaCubit, ThemeMode>(
      builder: (context, temaModu) {
        final koyuMu = temaModu == ThemeMode.dark;
        final kartRengi = koyuMu ? UygulamaRenkleri.koyuYuzey : UygulamaRenkleri.acikYuzey;
        final kenarlikRengi = koyuMu ? UygulamaRenkleri.koyuKenarlik : UygulamaRenkleri.acikKenarlik;
        final metinRengi = koyuMu ? Colors.white : UygulamaRenkleri.metinKoyu;

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: kartRengi,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: kenarlikRengi),
          ),
          child: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: koyuMu
                      ? UygulamaRenkleri.anaMor.withValues(alpha: 0.2)
                      : UygulamaRenkleri.sariVurgu.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  koyuMu ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                  size: 20,
                  color: koyuMu ? UygulamaRenkleri.acikMor : const Color(0xFFD97706),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Uygulama Teması',
                      style: const TextStyle(
                        fontSize: 11,
                        color: UygulamaRenkleri.metinGri,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      koyuMu ? 'Koyu Tema' : 'Açık Tema',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: metinRengi,
                      ),
                    ),
                  ],
                ),
              ),
              Switch.adaptive(
                value: koyuMu,
                activeThumbColor: UygulamaRenkleri.anaMor,
                inactiveThumbColor: const Color(0xFFD97706),
                inactiveTrackColor: UygulamaRenkleri.acikKenarlik,
                onChanged: (yeniDeger) {
                  context.read<TemaCubit>().temaDegistir(yeniDeger);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
