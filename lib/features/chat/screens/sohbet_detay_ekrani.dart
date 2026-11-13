import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../../../core/constants/renkler.dart';
import '../../../core/helpers/resim_saglayici_yardimcisi.dart';
import '../../auth/bloc/kimlik_bloc.dart';
import '../../auth/bloc/kimlik_state.dart';
import '../bloc/sohbet_bloc.dart';
import '../bloc/sohbet_event.dart';
import '../bloc/sohbet_state.dart';
import '../models/mesaj_modeli.dart';
import '../models/sohbet_odasi_modeli.dart';
import '../widgets/mesaj_balonu_bileseni.dart';
import '../widgets/mesaj_girdi_bari.dart';

class SohbetDetayEkrani extends StatefulWidget {
  final String sohbetId;
  final SohbetOdasiModeli? oda;

  const SohbetDetayEkrani({super.key, required this.sohbetId, this.oda});

  @override
  State<SohbetDetayEkrani> createState() => _SohbetDetayEkraniState();
}

class _SohbetDetayEkraniState extends State<SohbetDetayEkrani> {
  final _mesajKontrolcu = TextEditingController();
  final _kaydirmaKontrolcu = ScrollController();
  String _baslikAdi = '', _altBaslik = '', _profilFoto = '';

  @override
  void initState() {
    super.initState();
    _baslikAdi = (widget.oda?.karsiTarafAdi.isNotEmpty == true && widget.oda?.karsiTarafAdi != 'Kullanıcı') ? widget.oda!.karsiTarafAdi : '';
    _altBaslik = widget.oda?.ilanBasligi ?? 'İş Birliği Detayları';
    _profilFoto = widget.oda?.karsiTarafProfil ?? '';
    context.read<SohbetBloc>().add(MesajlariDinleEvent(widget.sohbetId));
    _karsiTarafBilgisiniGetir();
  }

  Future<void> _karsiTarafBilgisiniGetir() async {
    try {
      final kimlik = context.read<KimlikBloc>().state;
      final mevcutId = kimlik is KimlikDogrulandi ? kimlik.kullanici.id : '';
      final aliciId = _aliciIdBul(mevcutId);
      if (aliciId.isNotEmpty && aliciId != 'alici_hedef') {
        final doc = await FirebaseFirestore.instance.collection('kullanicilar').doc(aliciId).get();
        if (doc.exists && doc.data() != null && mounted) {
          final ad = (doc.data()!['adSoyad'] ?? doc.data()!['ad'] ?? '').toString().trim();
          final foto = (doc.data()!['profilResmi'] ?? '').toString();
          if (ad.isNotEmpty) setState(() { _baslikAdi = ad; if (foto.isNotEmpty) _profilFoto = foto; });
        }
      }
    } catch (_) {}
  }

  @override
  void dispose() {
    _mesajKontrolcu.dispose();
    _kaydirmaKontrolcu.dispose();
    super.dispose();
  }

  void _mesajGonder(String gondericiId, String aliciId) {
    final icerik = _mesajKontrolcu.text.trim();
    if (icerik.isEmpty) return;
    final yeniMesaj = MesajModeli(
      id: const Uuid().v4(), sohbetId: widget.sohbetId, gondericiId: gondericiId,
      aliciId: aliciId, icerik: icerik, zaman: DateTime.now(), okunduMu: true,
    );
    context.read<SohbetBloc>().add(MesajGonderEvent(yeniMesaj));
    _mesajKontrolcu.clear();
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_kaydirmaKontrolcu.hasClients) {
        _kaydirmaKontrolcu.animateTo(_kaydirmaKontrolcu.position.maxScrollExtent, duration: const Duration(milliseconds: 250), curve: Curves.easeOut);
      }
    });
  }

  String _aliciIdBul(String mevcutId) {
    if (widget.oda != null && widget.oda!.karsiTarafId.isNotEmpty) return widget.oda!.karsiTarafId;
    final p = widget.sohbetId.split('_');
    return p.length >= 4 ? (p[p.length - 2] == mevcutId ? p[p.length - 1] : p[p.length - 2]) : 'alici_hedef';
  }

  @override
  Widget build(BuildContext context) {
    final kimlikState = context.watch<KimlikBloc>().state;
    final mevcutId = kimlikState is KimlikDogrulandi ? kimlikState.kullanici.id : '';
    final aliciId = _aliciIdBul(mevcutId);
    final gorunenAd = _baslikAdi.isNotEmpty ? _baslikAdi : (widget.oda?.karsiTarafAdi.isNotEmpty == true ? widget.oda!.karsiTarafAdi : 'Sohbet');
    final fotoSaglayici = ResimSaglayiciYardimcisi.saglayici(_profilFoto);

    return Scaffold(
      appBar: AppBar(
        title: InkWell(
          onTap: () { if (aliciId.isNotEmpty && aliciId != 'alici_hedef') context.push('/kullanici-profil/$aliciId'); },
          borderRadius: BorderRadius.circular(8),
          child: Row(
            children: [
              CircleAvatar(
                radius: 18, backgroundImage: fotoSaglayici, backgroundColor: UygulamaRenkleri.anaMor.withValues(alpha: 0.25),
                child: fotoSaglayici == null ? Text(gorunenAd.isNotEmpty ? gorunenAd[0].toUpperCase() : 'S', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: UygulamaRenkleri.acikMor)) : null,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(child: Text(gorunenAd, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold))),
                        const SizedBox(width: 4),
                        const Icon(Icons.info_outline_rounded, size: 14, color: UygulamaRenkleri.acikMor),
                      ],
                    ),
                    Text(_altBaslik, style: const TextStyle(fontSize: 11, color: UygulamaRenkleri.metinGri), maxLines: 1, overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<SohbetBloc, SohbetState>(
              builder: (context, state) {
                if (state is SohbetOdalariYuklendi && state.aktifSohbetId == widget.sohbetId) {
                  final mesajlar = state.aktifMesajlar;
                  if (mesajlar.isEmpty) return const Center(child: Text('Henüz mesaj yok. İlk mesajı siz yazın!', style: TextStyle(color: UygulamaRenkleri.metinGri)));
                  return ListView.builder(
                    controller: _kaydirmaKontrolcu, padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    itemCount: mesajlar.length, itemBuilder: (context, index) => MesajBalonuBileseni(mesaj: mesajlar[index], benimMesajim: mesajlar[index].gondericiId == mevcutId),
                  );
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ),
          MesajGirdiBari(controller: _mesajKontrolcu, onGonder: () => _mesajGonder(mevcutId, aliciId)),
        ],
      ),
    );
  }
}
