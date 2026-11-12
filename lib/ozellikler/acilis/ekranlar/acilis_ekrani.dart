// Dosya Görevi: Uygulamanın animasyonlu açılış (Splash Screen) ekranı.
// Bu ekran uygulama başlatıldığında markalama logosunu gösterir, animasyonları oynatır
// ve KimlikBloc durumuna göre kullanıcıyı ana sayfaya ya da tanıtım ekranına yönlendirir.

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../cekirdek/sabitler/renkler.dart';
import '../../kimlik/bloc/kimlik_bloc.dart';
import '../../kimlik/bloc/kimlik_state.dart';

/// AcilisEkrani: Animasyonlu durumlu (Stateful) açılış ekranı widget'ı.
class AcilisEkrani extends StatefulWidget {
  const AcilisEkrani({super.key});

  @override
  State<AcilisEkrani> createState() => _AcilisEkraniState();
}

/// _AcilisEkraniState: Açılış ekranının durum ve animasyon yaşam döngüsünü yöneten sınıf.
/// SingleTickerProviderStateMixin: Animasyon denetleyicisine ekran yenileme tetikleyicisi (vsync) sağlar.
class _AcilisEkraniState extends State<AcilisEkrani>
    with SingleTickerProviderStateMixin {
  // Animasyon denetleyicisi ve ölçek/opaklık animasyon değişkenleri.
  late AnimationController _animasyonKontrolcu;
  late Animation<double> _olcekAnimasyonu;
  late Animation<double> _opaklikAnimasyonu;
  
  // Zamanlayıcılar ve yönlendirme durum bayrakları.
  Timer? _zamanlayici1;
  Timer? _zamanlayici2;
  bool _animasyonBitti = false;
  bool _yonlendirildi = false;

  /// initState(): Widget ilk kez ağaca eklendiğinde çalışan yaşam döngüsü metodu.
  /// Burada animasyonlar tanımlanır, başlatılır ve zamanlayıcı yönlendirmeleri kurgulanır.
  @override
  void initState() {
    super.initState();
    
    // 1.4 saniyelik logo animasyon denetleyicisi oluşturma.
    _animasyonKontrolcu = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    // Büyüme (ölçeklenme) animasyon eğrisi.
    _olcekAnimasyonu = Tween<double>(begin: 0.75, end: 1.0).animate(
      CurvedAnimation(parent: _animasyonKontrolcu, curve: Curves.easeOutBack),
    );

    // Belirme (opaklık) animasyon eğrisi.
    _opaklikAnimasyonu = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animasyonKontrolcu, curve: Curves.easeIn),
    );

    // Animasyonu başlatır.
    _animasyonKontrolcu.forward();

    // 1.8 saniye sonra animasyonun bittiğini işaretler ve yönlendirmeyi dener.
    _zamanlayici1 = Timer(const Duration(milliseconds: 1800), () {
      _animasyonBitti = true;
      _rotayaYonlendir();
    });

    // 4.5 saniye yedek zamanlayıcı: Herhangi bir takılma durumunda koruma amaçlı tanıtıma yönlendirir.
    _zamanlayici2 = Timer(const Duration(milliseconds: 4500), () {
      if (!_yonlendirildi && mounted) {
        _yonlendirildi = true;
        context.go('/tanitim');
      }
    });
  }

  /// _rotayaYonlendir(): KimlikBloc durumuna göre uygun rota yönlendirmesini yapan yardımcı metod.
  void _rotayaYonlendir() {
    if (!mounted || _yonlendirildi || !_animasyonBitti) return;
    final kimlikState = context.read<KimlikBloc>().state;

    // Kullanıcı doğrulanmışsa ana sayfaya, aksi halde tanıtım ekranına yönlendirilir.
    if (kimlikState is KimlikDogrulandi) {
      _yonlendirildi = true;
      context.go('/ana_sayfa');
    } else if (kimlikState is KimlikDogrulanmadi || kimlikState is KimlikHatasi) {
      _yonlendirildi = true;
      context.go('/tanitim');
    }
  }

  /// dispose(): Widget ağaçtan kaldırıldığında bellek sızıntılarını önlemek için çalışan temizleme metodu.
  /// Burada çalışan zamanlayıcılar ve animasyon denetleyicisi serbest bırakılır.
  @override
  void dispose() {
    _zamanlayici1?.cancel();
    _zamanlayici2?.cancel();
    _animasyonKontrolcu.dispose();
    super.dispose();
  }

  /// build(): Ekranın UI bileşenlerini oluşturan yaşam döngüsü metodu.
  @override
  Widget build(BuildContext context) {
    // BlocListener: KimlikBloc durum değişikliklerini dinleyerek animasyon bittiğinde yönlendirmeyi tetikler.
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
                      // Uygulama Logosu Kutusu
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
                      // Uygulama Başlığı
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
                      // Alt Slogan Metni
                      const Text(
                        'İçerik Üreticileri & Markalar Tek Platformda',
                        style: TextStyle(
                          fontSize: 14,
                          color: UygulamaRenkleri.metinGri,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 48),
                      // Yükleniyor Göstergesi
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
