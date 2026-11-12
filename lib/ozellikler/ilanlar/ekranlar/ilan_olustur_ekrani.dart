import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../../../cekirdek/sabitler/renkler.dart';
import '../../kimlik/bloc/kimlik_bloc.dart';
import '../../kimlik/bloc/kimlik_state.dart';
import '../bloc/ilan_bloc.dart';
import '../bloc/ilan_event.dart';
import '../bloc/ilan_state.dart';
import '../bilesenler/ilan_bilgileri_formu.dart';
import '../bilesenler/ilan_sartlari_secici.dart';
import '../model/ilan_modeli.dart';

class IlanOlusturEkrani extends StatefulWidget {
  const IlanOlusturEkrani({super.key});

  @override
  State<IlanOlusturEkrani> createState() => _IlanOlusturEkraniState();
}

class _IlanOlusturEkraniState extends State<IlanOlusturEkrani> {
  final _formKey = GlobalKey<FormState>();
  final _baslikKontrolcu = TextEditingController();
  final _aciklamaKontrolcu = TextEditingController();
  final _hedefInfluencerKontrolcu = TextEditingController();
  final _yeniSartKontrolcu = TextEditingController();

  String _seciliKategori = 'Güzellik & Bakım';
  String _seciliPlatform = 'Instagram Reels & Stories';
  String _seciliButceTuru = 'Ürün Kiti + Özel Anlaşmalı Bütçe';

  static const _kategoriler = ['Güzellik & Bakım', 'Spor & Moda', 'Yeme & İçme', 'Teknoloji & Yaşam', 'Seyahat & Eğlence'];
  static const _platformlar = ['Instagram Reels & Stories', 'TikTok Video', 'YouTube Shorts & Video', 'Çoklu Platform (IG + TikTok)'];
  static const _butceModelleri = ['Ürün Kiti + Özel Anlaşmalı Bütçe', 'Tam Ürün Hediyesi (Barter)', 'Satış Başına Komisyon (%15-20)', 'Özel Performans Primi Anlaşmalı'];
  final List<String> _sartlar = ['En az 10K aktif ve organik takipçi', 'Yüksek çözünürlüklü estetik video çekimi'];

  @override
  void dispose() {
    _baslikKontrolcu.dispose();
    _aciklamaKontrolcu.dispose();
    _hedefInfluencerKontrolcu.dispose();
    _yeniSartKontrolcu.dispose();
    super.dispose();
  }

  void _sartEkle() {
    final metin = _yeniSartKontrolcu.text.trim();
    if (metin.isNotEmpty) {
      setState(() {
        _sartlar.add(metin);
        _yeniSartKontrolcu.clear();
      });
    }
  }

  void _kaydet() {
    if (!_formKey.currentState!.validate()) return;
    if (_sartlar.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Lütfen en az bir katılım şartı ekleyiniz.')));
      return;
    }

    final kimlikState = context.read<KimlikBloc>().state;
    final kullanici = kimlikState is KimlikDogrulandi ? kimlikState.kullanici : null;

    final yeniIlan = IlanModeli(
      id: const Uuid().v4(),
      markaId: kullanici?.id ?? 'marka_anonim',
      markaAdi: kullanici?.adSoyad ?? 'Marka Adı',
      markaLogoUrl: kullanici?.profilResmi.isNotEmpty == true ? kullanici!.profilResmi : 'https://images.unsplash.com/photo-1522335789203-aabd1fc54bc9?w=200',
      baslik: _baslikKontrolcu.text.trim(),
      aciklama: _aciklamaKontrolcu.text.trim(),
      hedefInfluencer: _hedefInfluencerKontrolcu.text.trim(),
      kategori: _seciliKategori,
      platform: _seciliPlatform,
      butceTuru: _seciliButceTuru,
      sartlar: _sartlar,
      durum: IlanDurumu.yayinda,
      olusturulmaTarihi: DateTime.now(),
      basvuranInfluencerIds: const [],
    );

    context.read<IlanBloc>().add(IlanOlusturEvent(yeniIlan));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Yeni Kampanya İlanı')),
      body: BlocListener<IlanBloc, IlanState>(
        listener: (context, state) {
          if (state is IlanIslemiBasarili) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.mesaj), backgroundColor: UygulamaRenkleri.naneYesili));
            context.pop();
          } else if (state is IlanHatasi) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.mesaj), backgroundColor: UygulamaRenkleri.mercan));
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                IlanBilgileriFormu(
                  baslikKontrolcu: _baslikKontrolcu,
                  aciklamaKontrolcu: _aciklamaKontrolcu,
                  hedefInfluencerKontrolcu: _hedefInfluencerKontrolcu,
                  seciliKategori: _seciliKategori,
                  seciliPlatform: _seciliPlatform,
                  seciliButceTuru: _seciliButceTuru,
                  kategoriler: _kategoriler,
                  platformlar: _platformlar,
                  butceModelleri: _butceModelleri,
                  onKategoriDegisti: (val) { if (val != null) setState(() => _seciliKategori = val); },
                  onPlatformDegisti: (val) { if (val != null) setState(() => _seciliPlatform = val); },
                  onButceDegisti: (val) { if (val != null) setState(() => _seciliButceTuru = val); },
                ),
                const SizedBox(height: 24),
                IlanSartlariSecici(
                  sartlar: _sartlar,
                  yeniSartKontrolcu: _yeniSartKontrolcu,
                  onSartEkle: _sartEkle,
                  onSartSil: (idx) => setState(() => _sartlar.removeAt(idx)),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: _kaydet,
                  style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                  child: const Text('Kampanyayı Canlıya Al', style: TextStyle(fontSize: 16)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
