import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../cekirdek/sabitler/renkler.dart';
import '../bilesenler/kimlik_baslik_bileseni.dart';
import '../bilesenler/sifre_sifirlama_diyalogu.dart';
import '../bloc/kimlik_bloc.dart';
import '../bloc/kimlik_event.dart';
import '../bloc/kimlik_state.dart';

class GirisEkrani extends StatefulWidget {
  const GirisEkrani({super.key});

  @override
  State<GirisEkrani> createState() => _GirisEkraniState();
}

class _GirisEkraniState extends State<GirisEkrani> {
  final _emailKontrolcu = TextEditingController();
  final _sifreKontrolcu = TextEditingController();
  bool _sifreGorunur = false;

  @override
  void dispose() {
    _emailKontrolcu.dispose();
    _sifreKontrolcu.dispose();
    super.dispose();
  }

  void _girisYap() {
    context.read<KimlikBloc>().add(
          GirisYapEvent(
            email: _emailKontrolcu.text.trim(),
            sifre: _sifreKontrolcu.text,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<KimlikBloc, KimlikState>(
        listener: (context, state) {
          if (state is KimlikDogrulandi) {
            context.go('/ana_sayfa');
          } else if (state is SifreSifirlamaEpostasiGonderildi) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.mesaj), backgroundColor: UygulamaRenkleri.naneYesili),
            );
          } else if (state is KimlikHatasi) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.mesaj), backgroundColor: UygulamaRenkleri.mercan),
            );
          }
        },
        builder: (context, state) {
          final yukleniyor = state is KimlikYukleniyor;

          return SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const KimlikBaslikBileseni(
                      baslik: 'InflueMatch',
                      altBaslik: 'Markalar ve İçerik Üreticilerini Buluşturan Platform',
                    ),
                    const SizedBox(height: 36),
                    const Text('E-Posta Adresi', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _emailKontrolcu,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        hintText: 'ornek@email.com',
                        prefixIcon: Icon(Icons.email_outlined, size: 20),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text('Şifre', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _sifreKontrolcu,
                      obscureText: !_sifreGorunur,
                      decoration: InputDecoration(
                        hintText: '••••••••',
                        prefixIcon: const Icon(Icons.lock_outline_rounded, size: 20),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _sifreGorunur ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                            size: 20,
                            color: UygulamaRenkleri.metinGri,
                          ),
                          onPressed: () => setState(() => _sifreGorunur = !_sifreGorunur),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => SifreSifirlamaDiyalogu.goster(context, baslangicEmail: _emailKontrolcu.text.trim()),
                        style: TextButton.styleFrom(visualDensity: VisualDensity.compact),
                        child: const Text('Şifremi Unuttum', style: TextStyle(color: UygulamaRenkleri.acikMor, fontSize: 12)),
                      ),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: yukleniyor ? null : _girisYap,
                      child: yukleniyor
                          ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                          : const Text('Giriş Yap', style: TextStyle(fontSize: 16)),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Hesabınız yok mu?', style: TextStyle(color: UygulamaRenkleri.metinGri, fontSize: 13)),
                        TextButton(
                          onPressed: () => context.push('/kayit'),
                          child: const Text('Kayıt Ol', style: TextStyle(color: UygulamaRenkleri.acikMor, fontWeight: FontWeight.bold, fontSize: 13)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
