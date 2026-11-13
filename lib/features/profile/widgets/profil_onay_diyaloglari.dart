import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/renkler.dart';
import '../../auth/bloc/kimlik_bloc.dart';
import '../../auth/bloc/kimlik_event.dart';

class ProfilOnayDiyaloglari {
  static void cikisYap(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).cardTheme.color,
        title: const Text('Çıkış Yap'),
        content: const Text(
          'Hesabınızdan çıkış yapmak istediğinize emin misiniz?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<KimlikBloc>().add(CikisYapEvent());
              context.go('/giris');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: UygulamaRenkleri.mercan,
            ),
            child: const Text('Çıkış Yap'),
          ),
        ],
      ),
    );
  }

  static void hesabiSil(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).cardTheme.color,
        title: const Text(
          'Hesabı Sil',
          style: TextStyle(color: UygulamaRenkleri.mercan),
        ),
        content: const Text(
          'Hesabınızı silmek üzeresiniz. Bu işlem geri alınamaz ve tüm verileriniz silinir. Emin misiniz?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Vazgeç'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<KimlikBloc>().add(HesabiSilEvent());
              context.go('/giris');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: UygulamaRenkleri.mercan,
            ),
            child: const Text('Evet, Hesabımı Sil'),
          ),
        ],
      ),
    );
  }
}

