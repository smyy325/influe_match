import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../cekirdek/sabitler/renkler.dart';
import '../../../cekirdek/yardimcilar/resim_saglayici_yardimcisi.dart';

class ProfilResimYardimcisi {
  static ImageProvider? resimSaglayici({
    required File? secilenDosya,
    required String seciliFotoUrl,
    required String yedekFotoUrl,
  }) {
    if (secilenDosya != null) return FileImage(secilenDosya);
    final url = seciliFotoUrl.isNotEmpty ? seciliFotoUrl : yedekFotoUrl;
    return ResimSaglayiciYardimcisi.saglayici(url);
  }

  static Future<void> galeridenSec({
    required BuildContext context,
    required Function(String base64, File dosya) onSecildi,
  }) async {
    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 400,
        maxHeight: 400,
        imageQuality: 75,
      );
      if (picked != null) {
        final bytes = await picked.readAsBytes();
        final base64 = 'data:image/jpeg;base64,${base64Encode(bytes)}';
        onSecildi(base64, File(picked.path));
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Fotoğraf seçilirken bir hata oluştu: $e'),
            backgroundColor: UygulamaRenkleri.mercan,
          ),
        );
      }
    }
  }

  static void fotoSecimMenusu({
    required BuildContext context,
    required bool fotoVarMi,
    required Function(String base64, File dosya) onSecildi,
    required VoidCallback onSilindi,
  }) {
    if (!fotoVarMi) {
      galeridenSec(context: context, onSecildi: onSecildi);
      return;
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).cardTheme.color,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: UygulamaRenkleri.anaMor,
                  child: Icon(Icons.photo_library_rounded, color: Colors.white),
                ),
                title: const Text('Galeriden Yeni Fotoğraf Seç'),
                onTap: () {
                  Navigator.pop(ctx);
                  galeridenSec(context: context, onSecildi: onSecildi);
                },
              ),
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: UygulamaRenkleri.mercan,
                  child: Icon(Icons.delete_outline_rounded, color: Colors.white),
                ),
                title: const Text('Fotoğrafı Kaldır'),
                onTap: () {
                  Navigator.pop(ctx);
                  onSilindi();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

