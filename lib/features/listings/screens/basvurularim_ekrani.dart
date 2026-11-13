import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/renkler.dart';
import '../../auth/bloc/kimlik_bloc.dart';
import '../../auth/bloc/kimlik_state.dart';
import '../../auth/models/kullanici_modeli.dart';
import '../bloc/ilan_bloc.dart';
import '../bloc/ilan_event.dart';
import '../bloc/ilan_state.dart';
import '../widgets/basvuru_karti.dart';

class BasvurularimEkrani extends StatefulWidget {
  final VoidCallback? onIlanaGit;

  const BasvurularimEkrani({super.key, this.onIlanaGit});

  @override
  State<BasvurularimEkrani> createState() => _BasvurularimEkraniState();
}

class _BasvurularimEkraniState extends State<BasvurularimEkrani> {
  @override
  void initState() {
    super.initState();
    final kimlikState = context.read<KimlikBloc>().state;
    final kullanici = kimlikState is KimlikDogrulandi ? kimlikState.kullanici : null;
    _basvurulariYukle(kullanici);
  }

  void _basvurulariYukle(KullaniciModeli? kullanici) {
    if (kullanici != null) {
      context.read<IlanBloc>().add(
            BasvurulariYukleEvent(
              influencerId: kullanici.influencerMi ? kullanici.id : null,
              markaId: kullanici.markaMi ? kullanici.id : null,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final kimlikState = context.watch<KimlikBloc>().state;
    final kullanici = kimlikState is KimlikDogrulandi ? kimlikState.kullanici : null;
    final markaMi = kullanici?.markaMi ?? false;

    return Scaffold(
      appBar: AppBar(
        title: Text(markaMi ? 'Gelen Başvurular & Teklifler' : 'Başvurularım & Süreç'),
      ),
      body: RefreshIndicator(
        onRefresh: () async => _basvurulariYukle(kullanici),
        child: BlocBuilder<IlanBloc, IlanState>(
          builder: (context, state) {
            if (state is IlanYukleniyor) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is IlanHatasi) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline_rounded, size: 48, color: UygulamaRenkleri.mercan),
                    const SizedBox(height: 12),
                    Text(state.mesaj),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () => _basvurulariYukle(kullanici),
                      child: const Text('Tekrar Dene'),
                    ),
                  ],
                ),
              );
            }

            final basvurular = state is IlanlarYuklendi ? state.basvurular : [];

            if (basvurular.isEmpty) {
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.25),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          markaMi ? Icons.inbox_outlined : Icons.send_and_archive_outlined,
                          size: 56,
                          color: UygulamaRenkleri.metinGri,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          markaMi ? 'Henüz gelen bir başvuru bulunmuyor.' : 'Henüz hiçbir ilana başvuru yapmadınız.',
                          style: const TextStyle(color: UygulamaRenkleri.metinGri),
                        ),
                        const SizedBox(height: 16),
                        if (!markaMi)
                          ElevatedButton(
                            onPressed: () {
                              if (widget.onIlanaGit != null) {
                                widget.onIlanaGit!();
                              } else {
                                context.go('/ana_sayfa');
                              }
                            },
                            child: const Text('İlanları Keşfet'),
                          ),
                      ],
                    ),
                  ),
                ],
              );
            }

            return ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              itemCount: basvurular.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final basvuru = basvurular[index];
                return BasvuruKarti(
                  basvuru: basvuru,
                  markaMi: markaMi,
                  mevcutKullaniciId: kullanici?.id ?? '',
                );
              },
            );
          },
        ),
      ),
    );
  }
}
