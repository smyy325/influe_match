import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/renkler.dart';
import '../../auth/bloc/kimlik_bloc.dart';
import '../../auth/bloc/kimlik_state.dart';
import '../bloc/ilan_bloc.dart';
import '../bloc/ilan_event.dart';
import '../bloc/ilan_state.dart';
import '../models/ilan_modeli.dart';
import '../widgets/ilan_akisi_app_bari.dart';
import '../widgets/ilan_arama_filtre_alani.dart';
import '../widgets/ilan_karti.dart';

class IlanAkisiEkrani extends StatefulWidget {
  const IlanAkisiEkrani({super.key});

  @override
  State<IlanAkisiEkrani> createState() => _IlanAkisiEkraniState();
}

class _IlanAkisiEkraniState extends State<IlanAkisiEkrani> {
  final _aramaKontrolcu = TextEditingController();
  String _seciliKategori = 'Tümü';
  static const _kategoriler = ['Tümü', 'Güzellik & Bakım', 'Spor & Moda', 'Yeme & İçme', 'Teknoloji & Yaşam'];

  @override
  void initState() {
    super.initState();
    final kimlik = context.read<KimlikBloc>().state;
    _filtrele(kimlik is KimlikDogrulandi ? kimlik.kullanici : null);
  }

  @override
  void dispose() {
    _aramaKontrolcu.dispose();
    super.dispose();
  }

  void _filtrele([dynamic user]) {
    final kimlik = context.read<KimlikBloc>().state;
    final k = user ?? (kimlik is KimlikDogrulandi ? kimlik.kullanici : null);
    context.read<IlanBloc>().add(
          IlanlariYukleEvent(
            kategori: _seciliKategori,
            aramaKelimesi: _aramaKontrolcu.text,
            markaId: (k != null && k.markaMi) ? k.id : null,
          ),
        );
  }

  bool _ilanGorunsunMu(IlanModeli i, dynamic k, bool markaMi) {
    if (!i.ozelIlanMi) return true;
    if (markaMi) return i.markaId == k?.id || i.markaAdi == k?.adSoyad;
    if (k == null) return false;

    final h = i.hedefInfluencer.trim().toLowerCase();
    if (h.isEmpty) return true;

    final ad = k.adSoyad.toString().trim().toLowerCase();
    final em = k.email.toString().trim().toLowerCase();
    final sos = k.sosyalMedyaHesabi.toString().trim().toLowerCase().replaceAll('@', '');
    final cleanH = h.replaceAll('@', '');

    // Tam ad/soyad eşleşmesi (Boşluksuz ve Türkçe büyük/küçük harf toleranslı)
    final adSpacesiz = ad.replaceAll(RegExp(r'\s+'), '');
    final hSpacesiz = h.replaceAll(RegExp(r'\s+'), '');

    return ad == h ||
        adSpacesiz == hSpacesiz ||
        em == h ||
        (sos.isNotEmpty && cleanH.isNotEmpty && sos == cleanH) ||
        k.id.toString().trim().toLowerCase() == h;
  }

  Widget _bosDurum() {
    return const SliverFillRemaining(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.campaign_outlined, size: 56, color: UygulamaRenkleri.metinGri),
            SizedBox(height: 12),
            Text('Aramanızla eşleşen ilan bulunamadı.', style: TextStyle(color: UygulamaRenkleri.metinGri)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final kimlikState = context.watch<KimlikBloc>().state;
    final kullanici = kimlikState is KimlikDogrulandi ? kimlikState.kullanici : null;
    final markaMi = kullanici?.markaMi ?? false;

    return Scaffold(
      appBar: IlanAkisiAppBari(markaMi: markaMi),
      body: RefreshIndicator(
        onRefresh: () async => _filtrele(),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: IlanAramaFiltreAlani(
                aramaKontrolcu: _aramaKontrolcu,
                seciliKategori: _seciliKategori,
                kategoriler: _kategoriler,
                onAramaDegisti: _filtrele,
                onKategoriSecildi: (kat) {
                  setState(() => _seciliKategori = kat);
                  _filtrele();
                },
              ),
            ),
            BlocBuilder<IlanBloc, IlanState>(
              builder: (context, state) {
                if (state is IlanYukleniyor) return const SliverFillRemaining(child: Center(child: CircularProgressIndicator()));
                if (state is IlanHatasi) {
                  return SliverFillRemaining(
                    child: Center(child: ElevatedButton(onPressed: _filtrele, child: const Text('Tekrar Dene'))),
                  );
                }
                if (state is IlanlarYuklendi) {
                  final ilanlar = state.ilanlar.where((i) => _ilanGorunsunMu(i, kullanici, markaMi)).toList();
                  if (ilanlar.isEmpty) return _bosDurum();
                  return SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (ctx, idx) {
                          final ilan = ilanlar[idx];
                          dynamic basvuruDurumu;
                          if (kullanici != null && state.basvurular.isNotEmpty) {
                            try {
                              basvuruDurumu = state.basvurular.firstWhere(
                                (b) => b.ilanId == ilan.id && b.influencerId == kullanici.id,
                              ).durum;
                            } catch (_) {}
                          }
                          return IlanKarti(
                            ilan: ilan,
                            basvurduMu: kullanici != null && ilan.basvuranInfluencerIds.contains(kullanici.id),
                            basvuruDurumu: basvuruDurumu,
                            onTap: () => context.push('/ilan-detay/${ilan.id}', extra: ilan),
                          );
                        },
                        childCount: ilanlar.length,
                      ),
                    ),
                  );
                }
                return const SliverToBoxAdapter(child: SizedBox.shrink());
              },
            ),
          ],
        ),
      ),
      floatingActionButton: markaMi
          ? FloatingActionButton.extended(
              onPressed: () => context.push('/ilan-olustur'),
              backgroundColor: UygulamaRenkleri.anaMor,
              icon: const Icon(Icons.campaign_rounded, color: Colors.white),
              label: const Text('Kampanya Başlat', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            )
          : null,
    );
  }
}
