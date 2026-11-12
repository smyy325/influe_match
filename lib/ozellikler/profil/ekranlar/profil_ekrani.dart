import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../cekirdek/sabitler/renkler.dart';
import '../../kimlik/bloc/kimlik_bloc.dart';
import '../../kimlik/bloc/kimlik_event.dart';
import '../../kimlik/bloc/kimlik_state.dart';
import '../../kimlik/model/kullanici_modeli.dart';
import '../bilesenler/profil_baslik_alani.dart';
import '../bilesenler/profil_bilgileri_formu.dart';
import '../bilesenler/profil_bilgileri_gorunumu.dart';
import '../bilesenler/profil_form_yoneticisi.dart';

class ProfilEkrani extends StatefulWidget {
  const ProfilEkrani({super.key});

  @override
  State<ProfilEkrani> createState() => _ProfilEkraniState();
}

class _ProfilEkraniState extends State<ProfilEkrani> {
  bool _duzenlemeModu = false;
  String _profilResmi = '';
  File? _secilenResimDosyasi;
  final ProfilFormYoneticisi _form = ProfilFormYoneticisi();

  @override
  void dispose() {
    _form.dispose();
    super.dispose();
  }

  void _alanlariDoldur(KullaniciModeli kullanici) {
    if (_duzenlemeModu) return;
    _form.alanlariDoldur(kullanici);
    if (_secilenResimDosyasi == null) {
      _profilResmi = kullanici.profilResmi;
    }
  }

  void _fotoSecildi(KullaniciModeli kullanici, String b64, File file) {
    setState(() {
      _profilResmi = b64;
      _secilenResimDosyasi = file;
    });
    final guncel = kullanici.copyWith(profilResmi: b64);
    context.read<KimlikBloc>().add(ProfilGuncelleEvent(guncel));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profil fotoğrafı güncellendi!'), backgroundColor: UygulamaRenkleri.naneYesili),
    );
  }

  void _fotoSilindi(KullaniciModeli kullanici) {
    setState(() {
      _profilResmi = '';
      _secilenResimDosyasi = null;
    });
    final guncel = kullanici.copyWith(profilResmi: '');
    context.read<KimlikBloc>().add(ProfilGuncelleEvent(guncel));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profil fotoğrafı kaldırıldı.')),
    );
  }

  void _kaydet(KullaniciModeli mevcut) {
    final guncel = _form.guncelKullanici(mevcut, _profilResmi);
    context.read<KimlikBloc>().add(ProfilGuncelleEvent(guncel));
    setState(() => _duzenlemeModu = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profil başarıyla kaydedildi!'), backgroundColor: UygulamaRenkleri.naneYesili),
    );
  }

  Widget _eylemButonu(KullaniciModeli kullanici) {
    if (_duzenlemeModu) {
      return ElevatedButton.icon(
        onPressed: () => _kaydet(kullanici),
        icon: const Icon(Icons.check_rounded, size: 16),
        label: const Text('Kaydet'),
        style: ElevatedButton.styleFrom(backgroundColor: UygulamaRenkleri.anaMor),
      );
    }
    final koyuMu = Theme.of(context).brightness == Brightness.dark;
    return ElevatedButton.icon(
      onPressed: () => setState(() => _duzenlemeModu = true),
      icon: const Icon(Icons.edit_rounded, size: 16),
      label: const Text('Düzenle'),
      style: ElevatedButton.styleFrom(
        backgroundColor: koyuMu ? UygulamaRenkleri.koyuYuzey : UygulamaRenkleri.acikMor.withValues(alpha: 0.25),
        foregroundColor: koyuMu ? UygulamaRenkleri.acikMor : UygulamaRenkleri.anaMor,
      ),
    );
  }

  Widget _profilIcerigi(KullaniciModeli k) {
    if (!_duzenlemeModu) {
      return ProfilBilgileriGorunumu(kullanici: k, onDuzenleTiklandi: () => setState(() => _duzenlemeModu = true));
    }
    return ProfilBilgileriFormu(
      adSoyadKontrolcu: _form.adSoyadKontrolcu,
      emailKontrolcu: _form.emailKontrolcu,
      telefonKontrolcu: _form.telefonKontrolcu,
      konumKontrolcu: _form.konumKontrolcu,
      sosyalMedyaKontrolcu: _form.sosyalMedyaKontrolcu,
      biyografiKontrolcu: _form.biyografiKontrolcu,
      influencerMi: k.influencerMi,
      seciliTercihler: _form.seciliTercihler,
      onTercihDegisti: (kat) => setState(() => _form.tercihDegistir(kat)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<KimlikBloc, KimlikState>(
      builder: (context, state) {
        if (state is! KimlikDogrulandi) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        final kullanici = state.kullanici;
        _alanlariDoldur(kullanici);

        return Scaffold(
          appBar: AppBar(
            title: const Text('Hesabı Yönet', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            actions: [Padding(padding: const EdgeInsets.only(right: 16), child: _eylemButonu(kullanici))],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Column(
              children: [
                ProfilBaslikAlani(
                  kullanici: kullanici,
                  seciliFotoUrl: _profilResmi,
                  secilenDosya: _secilenResimDosyasi,
                  onFotoSecildi: (b64, f) => _fotoSecildi(kullanici, b64, f),
                  onFotoSilindi: () => _fotoSilindi(kullanici),
                ),
                const SizedBox(height: 24),
                _profilIcerigi(kullanici),
              ],
            ),
          ),
        );
      },
    );
  }
}
