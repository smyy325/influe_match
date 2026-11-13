import 'package:flutter/material.dart';
import '../../../core/constants/renkler.dart';

class MesajGirdiBari extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onGonder;

  const MesajGirdiBari({
    super.key,
    required this.controller,
    required this.onGonder,
  });

  @override
  Widget build(BuildContext context) {
    final koyuMu = Theme.of(context).brightness == Brightness.dark;
    final cubukRengi = koyuMu ? UygulamaRenkleri.koyuYuzey : UygulamaRenkleri.acikYuzey;
    final kenarlikRengi = koyuMu ? UygulamaRenkleri.koyuKenarlik : UygulamaRenkleri.acikKenarlik;
    final alanRengi = koyuMu ? UygulamaRenkleri.koyuArkaPlan : UygulamaRenkleri.acikArkaPlan;

    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 10,
        bottom: MediaQuery.of(context).padding.bottom + 10,
      ),
      decoration: BoxDecoration(
        color: cubukRengi,
        border: Border(top: BorderSide(color: kenarlikRengi)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => onGonder(),
              decoration: InputDecoration(
                hintText: 'Mesajınızı yazın...',
                filled: true,
                fillColor: alanRengi,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton.filled(
            icon: const Icon(Icons.send_rounded, size: 20),
            style: IconButton.styleFrom(
              backgroundColor: UygulamaRenkleri.anaMor,
              foregroundColor: Colors.white,
            ),
            onPressed: onGonder,
          ),
        ],
      ),
    );
  }
}
