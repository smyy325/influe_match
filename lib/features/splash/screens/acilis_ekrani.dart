import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/renkler.dart';
import '../../auth/bloc/kimlik_bloc.dart';
import '../../auth/bloc/kimlik_state.dart';

class AcilisEkrani extends StatefulWidget {
  const AcilisEkrani({super.key});

  @override
  State<AcilisEkrani> createState() => _AcilisEkraniState();
}

class _AcilisEkraniState extends State<AcilisEkrani>
    with SingleTickerProviderStateMixin {
  late AnimationController _animasyonKontrolcu;
  late Animation<double> _olcekAnimasyonu;
  late Animation<double> _opaklikAnimasyonu;
  
  Timer? _zamanlayici1;
  Timer? _zamanlayici2;
  bool _animasyonBitti = false;
  bool _yonlendirildi = false;

  @override
  void initState() {
    super.initState();

    _animasyonKontrolcu = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _olcekAnimasyonu = Tween<double>(begin: 0.75, end: 1.0).animate(
      CurvedAnimation(parent: _animasyonKontrolcu, curve: Curves.easeOutBack),
    );

    _opaklikAnimasyonu = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animasyonKontrolcu, curve: Curves.easeIn),
    );

    _animasyonKontrolcu.forward();

    _zamanlayici1 = Timer(const Duration(milliseconds: 1800), () {
      _animasyonBitti = true;
      _rotayaYonlendir();
    });

    _zamanlayici2 = Timer(const Duration(milliseconds: 4500), () {
      if (!_yonlendirildi && mounted) {
        _yonlendirildi = true;
        context.go('/tanitim');
      }
    });
  }

  void _rotayaYonlendir() {
    if (!mounted || _yonlendirildi || !_animasyonBitti) return;
    final kimlikState = context.read<KimlikBloc>().state;

    if (kimlikState is KimlikDogrulandi) {
      _yonlendirildi = true;
      context.go('/ana_sayfa');
    } else if (kimlikState is KimlikDogrulanmadi || kimlikState is KimlikHatasi) {
      _yonlendirildi = true;
      context.go('/tanitim');
    }
  }

  @override
  void dispose() {
    _zamanlayici1?.cancel();
    _zamanlayici2?.cancel();
    _animasyonKontrolcu.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<KimlikBloc, KimlikState>(
      listener: (context, state) {
        if (_animasyonBitti) _rotayaYonlendir();
      },
      child: Scaffold(
        backgroundColor: UygulamaRenkleri.koyuArkaPlan,
        body: Center(
          child: AnimatedBuilder(
            animation: _animasyonKontrolcu,
            builder: (context, child) {
              return FadeTransition(
                opacity: _opaklikAnimasyonu,
                child: ScaleTransition(
                  scale: _olcekAnimasyonu,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          gradient: UygulamaRenkleri.morGradyan,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: UygulamaRenkleri.anaMor.withValues(alpha: 0.45),
                              blurRadius: 32,
                              offset: const Offset(0, 12),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.hub_rounded,
                          size: 54,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'InflueMatch',
                        style: TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.5,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'İçerik Üreticileri & Markalar Tek Platformda',
                        style: TextStyle(
                          fontSize: 14,
                          color: UygulamaRenkleri.metinGri,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 48),
                      const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          valueColor: AlwaysStoppedAnimation<Color>(UygulamaRenkleri.acikMor),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
