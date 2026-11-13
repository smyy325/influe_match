import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/renkler.dart';
import '../../../core/dependency/servis_konfigurasyonu.dart';
import '../../../core/error/sonuc.dart';
import '../../../core/helpers/resim_saglayici_yardimcisi.dart';
import '../../auth/bloc/kimlik_bloc.dart';
import '../../auth/bloc/kimlik_state.dart';
import '../../auth/models/kullanici_modeli.dart';
import '../../chat/repository/sohbet_deposu.dart';
import '../widgets/influencer_tercihleri_alani.dart';
import '../widgets/profil_bilgi_karti.dart';

class KullaniciProfilDetayEkrani extends StatelessWidget {
  final String kullaniciId;

  const KullaniciProfilDetayEkrani({super.key, required this.kullaniciId});

  Future<void> _sohbetBaslat(BuildContext context, KullaniciModeli karsiKullanici) async {
    final kimlik = context.read<KimlikBloc>().state;
    final mevcutId = kimlik is KimlikDogrulandi ? kimlik.kullanici.id : '';
    final sonuc = await bulucu<ISohbetDeposu>().sohbetOlusturVeyaGetir(
      ilanId: 'profil_etkilesim',
      ilanBasligi: karsiKullanici.influencerMi ? 'İş Birliği İletişimi' : 'Marka İletişimi',
      karsiTarafId: karsiKullanici.id,
      karsiTarafAdi: karsiKullanici.adSoyad,
      karsiTarafProfil: karsiKullanici.profilResmi,
      karsiTarafRol: karsiKullanici.influencerMi ? 'Influencer' : 'Marka',
      mevcutKullaniciId: mevcutId,
    );
    if (context.mounted) {
      if (sonuc case Basari(:final veri)) {
        context.push('/sohbet/${veri.id}', extra: veri);
      }
    }
  }

  Widget _ustBaslik(KullaniciModeli k) {
    final fotoSaglayici = ResimSaglayiciYardimcisi.saglayici(k.profilResmi);
    return Column(
      children: [
        CircleAvatar(
          radius: 46,
          backgroundImage: fotoSaglayici,
          backgroundColor: UygulamaRenkleri.anaMor.withValues(alpha: 0.2),
          child: fotoSaglayici == null
              ? Text(k.adSoyad.isNotEmpty ? k.adSoyad[0].toUpperCase() : 'U', style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: UygulamaRenkleri.acikMor))
              : null,
        ),
        const SizedBox(height: 12),
        Text(k.adSoyad, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(color: UygulamaRenkleri.anaMor.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(12)),
          child: Text(k.influencerMi ? 'İçerik Üretici (Influencer)' : 'Marka / Şirket', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: UygulamaRenkleri.acikMor)),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      future: FirebaseFirestore.instance.collection('kullanicilar').doc(kullaniciId).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        final data = snapshot.data?.data();
        if (data == null) {
          return Scaffold(appBar: AppBar(title: const Text('Profil')), body: const Center(child: Text('Kullanıcı bilgisi bulunamadı.')));
        }
        data['id'] = kullaniciId;
        final k = KullaniciModeli.fromMap(data);

        return Scaffold(
          appBar: AppBar(title: Text(k.adSoyad, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _ustBaslik(k),
                const SizedBox(height: 20),
                ProfilBilgiKarti(ikon: Icons.email_rounded, baslik: 'E-Mail', deger: k.email),
                if (k.telefon.isNotEmpty) ProfilBilgiKarti(ikon: Icons.phone_rounded, baslik: 'Telefon', deger: k.telefon),
                ProfilBilgiKarti(ikon: Icons.location_on_rounded, baslik: 'Konum', deger: k.konum.isNotEmpty ? k.konum : 'Belirtilmedi'),
                ProfilBilgiKarti(ikon: Icons.alternate_email_rounded, baslik: k.influencerMi ? 'Sosyal Medya' : 'Web Sitesi / Hesap', deger: k.sosyalMedyaHesabi),
                if (k.biyografi.isNotEmpty) ProfilBilgiKarti(ikon: Icons.info_outline_rounded, baslik: 'Hakkında', deger: k.biyografi),
                if (k.influencerMi && k.tercihler.isNotEmpty) InfluencerTercihleriAlani(seciliTercihler: k.tercihler, duzenlemeModu: false),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () => _sohbetBaslat(context, k),
                  icon: const Icon(Icons.chat_bubble_outline_rounded, size: 18),
                  label: const Text('Mesaj Gönder'),
                  style: ElevatedButton.styleFrom(backgroundColor: UygulamaRenkleri.anaMor, padding: const EdgeInsets.symmetric(vertical: 14)),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }
}

