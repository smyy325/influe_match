import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../cekirdek/sabitler/renkler.dart';
import '../bloc/kimlik_bloc.dart';
import '../bloc/kimlik_event.dart';

class SifreSifirlamaDiyalogu {
  static void goster(BuildContext context, {String baslangicEmail = ''}) {
    final emailKontrolcu = TextEditingController(text: baslangicEmail);

    showDialog(
      context: context,
      builder: (diyalogContext) {
        return AlertDialog(
          backgroundColor: UygulamaRenkleri.koyuYuzey,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Şifremi Unuttum', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Hesabınıza kayıtlı e-posta adresinizi girin. Size şifre sıfırlama bağlantısı göndereceğiz.',
                style: TextStyle(fontSize: 13, color: UygulamaRenkleri.metinGri),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: emailKontrolcu,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  hintText: 'ornek@email.com',
                  prefixIcon: Icon(Icons.email_outlined, size: 20),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(diyalogContext).pop(),
              child: const Text('İptal', style: TextStyle(color: UygulamaRenkleri.metinGri)),
            ),
            ElevatedButton(
              onPressed: () {
                final email = emailKontrolcu.text.trim();
                if (email.isEmpty || !email.contains('@')) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Lütfen geçerli bir e-posta adresi giriniz.'),
                      backgroundColor: UygulamaRenkleri.mercan,
                    ),
                  );
                  return;
                }
                context.read<KimlikBloc>().add(SifreSifirlamaTalebiEvent(email));
                Navigator.of(diyalogContext).pop();
              },
              child: const Text('Bağlantı Gönder'),
            ),
          ],
        );
      },
    );
  }
}

