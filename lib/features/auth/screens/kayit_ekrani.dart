import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/renkler.dart';
import '../bloc/kimlik_bloc.dart';
import '../bloc/kimlik_event.dart';
import '../bloc/kimlik_state.dart';
import '../models/kullanici_modeli.dart';
import '../widgets/rol_secim_karti.dart';

class KayitEkrani extends StatefulWidget {
  const KayitEkrani({super.key});

  @override
  State<KayitEkrani> createState() => _KayitEkraniState();
}

class _KayitEkraniState extends State<KayitEkrani> {
  final _adSoyadKontrolcu = TextEditingController();
  final _emailKontrolcu = TextEditingController();
  final _sifreKontrolcu = TextEditingController();
  Rol _seciliRol = Rol.influencer;
  bool _sifreGorunur = false;

  @override
  void dispose() {
    _adSoyadKontrolcu.dispose();
    _emailKontrolcu.dispose();
    _sifreKontrolcu.dispose();
    super.dispose();
  }

  void _kayitOl() {
    context.read<KimlikBloc>().add(
          KayitOlEvent(
            adSoyad: _adSoyadKontrolcu.text.trim(),
            email: _emailKontrolcu.text.trim(),
            sifre: _sifreKontrolcu.text,
            rol: _seciliRol,
          ),
        );
  }

  Widget _metinGirdisi(String etiket, TextEditingController kontrolcu, String ipucu, IconData ikon, {bool sifreAlani = false, TextInputType? tip}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(etiket, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
        const SizedBox(height: 6),
        TextField(
          controller: kontrolcu,
          obscureText: sifreAlani && !_sifreGorunur,
          keyboardType: tip,
          decoration: InputDecoration(
            hintText: ipucu,
            prefixIcon: Icon(ikon, size: 20),
            suffixIcon: sifreAlani
                ? IconButton(
                    icon: Icon(_sifreGorunur ? Icons.visibility_off_rounded : Icons.visibility_rounded, size: 20, color: UygulamaRenkleri.metinGri),
                    onPressed: () => setState(() => _sifreGorunur = !_sifreGorunur),
                  )
                : null,
          ),
        ),
        const SizedBox(height: 14),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Yeni Hesap Oluştur')),
      body: BlocConsumer<KimlikBloc, KimlikState>(
        listener: (context, state) {
          if (state is KimlikDogrulandi) {
            context.go('/ana_sayfa');
          } else if (state is KimlikHatasi) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.mesaj), backgroundColor: UygulamaRenkleri.mercan),
            );
          }
        },
        builder: (context, state) {
          final yukleniyor = state is KimlikYukleniyor;

          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text('Hesap Türünü Seçin', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      RolSecimKarti(
                        rol: Rol.influencer,
                        seciliRol: _seciliRol,
                        ikon: Icons.star_rounded,
                        baslik: 'Influencer',
                        aciklama: 'İçerik Üreticisi',
                        onRolSecildi: (r) => setState(() => _seciliRol = r),
                      ),
                      const SizedBox(width: 12),
                      RolSecimKarti(
                        rol: Rol.marka,
                        seciliRol: _seciliRol,
                        ikon: Icons.business_rounded,
                        baslik: 'Marka',
                        aciklama: 'İlan Veren',
                        onRolSecildi: (r) => setState(() => _seciliRol = r),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _metinGirdisi(_seciliRol == Rol.marka ? 'Marka Adı' : 'Ad Soyad', _adSoyadKontrolcu, 'Adınızı girin', Icons.person_outline_rounded),
                  _metinGirdisi('E-Posta Adresi', _emailKontrolcu, 'ornek@email.com', Icons.email_outlined, tip: TextInputType.emailAddress),
                  _metinGirdisi('Şifre', _sifreKontrolcu, 'En az 6 karakter', Icons.lock_outline_rounded, sifreAlani: true),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: yukleniyor ? null : _kayitOl,
                    child: yukleniyor
                        ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : const Text('Hesap Oluştur', style: TextStyle(fontSize: 16)),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Zaten hesabınız var mı?', style: TextStyle(color: UygulamaRenkleri.metinGri, fontSize: 13)),
                      TextButton(
                        onPressed: () => context.pop(),
                        child: const Text('Giriş Yap', style: TextStyle(color: UygulamaRenkleri.acikMor, fontWeight: FontWeight.bold, fontSize: 13)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
