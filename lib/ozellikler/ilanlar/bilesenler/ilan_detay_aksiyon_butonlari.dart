// Dosya Görevi: İlan Detayı Ekranı Alt Aksiyon Butonları ve Durum Kartları Bileşeni.
// Bu bileşen, oturum açan kullanıcının rolüne (Marka veya Influencer) ve ilanın türüne (Genel veya VIP Özel Teklif)
// göre dinamik butonlar (Başvur, Reddet, Kabul Et & Başvur) ve durum rozetleri görüntüler.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../cekirdek/sabitler/renkler.dart';
import '../../../cekirdek/yardimcilar/resim_saglayici_yardimcisi.dart';
import '../../kimlik/model/kullanici_modeli.dart';
import '../bloc/ilan_bloc.dart';
import '../bloc/ilan_event.dart';
import '../model/basvuru_modeli.dart';
import '../model/ilan_modeli.dart';
import 'ilan_basvuru_modali.dart';

/// IlanDetayAksiyonButonlari: Durumsuz (Stateless) alt aksiyon ve profil kartı widget'ı.
class IlanDetayAksiyonButonlari extends StatelessWidget {
  final IlanModeli ilan;
  final KullaniciModeli? kullanici;
  final BasvuruModeli? mevcutBasvuru;

  const IlanDetayAksiyonButonlari({
    super.key,
    required this.ilan,
    required this.kullanici,
    this.mevcutBasvuru,
  });

  /// _reddetDiyaloguGoster(): Influencer özel bir teklifi reddetmek istediğinde onay açılır penceresini (AlertDialog) görüntüler.
  void _reddetDiyaloguGoster(BuildContext context, KullaniciModeli k) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Özel Teklifi Reddet'),
        content: const Text(
          'Bu özel teklifi reddetmek istediğinizden emin misiniz? Marka teklifi reddettiğinizi görecektir.',
        ),
        actions: [
          // İptal Butonu
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Vazgeç'),
          ),
          // Onay Reddet Butonu
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: UygulamaRenkleri.mercan,
            ),
            onPressed: () {
              Navigator.pop(dialogContext);
              // Reddetme başvuru modelini oluşturur ve BLoC'a iletir.
              final basvuru = BasvuruModeli(
                id: 'basvuru_${ilan.id}_${k.id}',
                ilanId: ilan.id,
                ilanBasligi: ilan.baslik,
                markaId: ilan.markaId,
                markaAdi: ilan.markaAdi,
                influencerId: k.id,
                influencerAdi: k.adSoyad,
                influencerProfil: k.profilResmi,
                basvuruNotu: 'Özel teklif influencer tarafından reddedildi.',
                durum: BasvuruDurumu.reddedildi,
                tarih: DateTime.now(),
              );
              context.read<IlanBloc>().add(IlanaBasvurEvent(basvuru));
            },
            child: const Text('Reddet', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  /// build(): Kullanıcı rolü ve ilan durumuna göre alt buton / kart tasarımını döndüren yaşam döngüsü metodu.
  @override
  Widget build(BuildContext context) {
    final markaMi = kullanici?.markaMi ?? false;

    // 1. Durum: Kullanıcı MARKA ise
    if (markaMi) {
      final koyuMu = Theme.of(context).brightness == Brightness.dark;

      // Marka için Özel İlan Durum Kartı (Hedef Influencer Profil & Durum Rozeti)
      if (ilan.ozelIlanMi) {
        final basvuru = mevcutBasvuru;
        final infAd = basvuru?.influencerAdi.isNotEmpty == true
            ? basvuru!.influencerAdi
            : ilan.hedefInfluencer;
        final infProfil = basvuru?.influencerProfil ?? '';
        final fotoSaglayici = ResimSaglayiciYardimcisi.saglayici(infProfil);

        final String durumMetni;
        final Color durumRengi;
        final IconData durumIkoni;

        // Influencer yanıtına göre durum rozeti renk ve metnini belirler.
        if (basvuru != null && basvuru.durum == BasvuruDurumu.reddedildi) {
          durumMetni = 'Reddedildi';
          durumRengi = UygulamaRenkleri.mercan;
          durumIkoni = Icons.cancel_rounded;
        } else if ((basvuru != null && (basvuru.durum == BasvuruDurumu.kabulEdildi || basvuru.durum == BasvuruDurumu.beklemede)) || ilan.basvuranInfluencerIds.isNotEmpty) {
          durumMetni = 'Kabul Edildi';
          durumRengi = UygulamaRenkleri.naneYesili;
          durumIkoni = Icons.check_circle_rounded;
        } else {
          durumMetni = 'Değerlendirme Aşamasında';
          durumRengi = UygulamaRenkleri.sariVurgu;
          durumIkoni = Icons.access_time_rounded;
        }

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: koyuMu ? UygulamaRenkleri.koyuYuzey : UygulamaRenkleri.acikYuzey,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: koyuMu ? UygulamaRenkleri.koyuKenarlik : UygulamaRenkleri.acikKenarlik,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Hedef İçerik Üreticisi',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: UygulamaRenkleri.metinGri,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundImage: fotoSaglayici,
                    backgroundColor: UygulamaRenkleri.anaMor.withValues(alpha: 0.2),
                    child: fotoSaglayici == null
                        ? Text(
                            infAd.isNotEmpty ? infAd[0].toUpperCase() : 'I',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: UygulamaRenkleri.acikMor,
                              fontSize: 18,
                            ),
                          )
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          infAd,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'Özel Teklif İletildi',
                          style: TextStyle(
                            fontSize: 12,
                            color: UygulamaRenkleri.metinGri,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Durum Rozeti (Reddedildi / Kabul Edildi / Değerlendirme Aşamasında)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: durumRengi.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: durumRengi),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(durumIkoni, size: 14, color: durumRengi),
                        const SizedBox(width: 4),
                        Text(
                          durumMetni,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: durumRengi,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }

      // Marka için Genel İlan Başvuru Sayısı Kutusu
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: koyuMu ? UygulamaRenkleri.koyuYuzey : UygulamaRenkleri.acikYuzey,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: koyuMu ? UygulamaRenkleri.koyuKenarlik : UygulamaRenkleri.acikKenarlik,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Başvuran Sayısı: ${ilan.basvuranInfluencerIds.length}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            OutlinedButton(
              onPressed: () => context.push('/basvurularim'),
              child: const Text('Başvuruları İncele'),
            ),
          ],
        ),
      );
    }

    // 2. Durum: Kullanıcı INFLUENCER ise
    final k = kullanici;
    if (k == null) return const SizedBox.shrink();

    final basvurduMu = ilan.basvuranInfluencerIds.contains(k.id);
    final durum = mevcutBasvuru?.durum;

    // Eğer daha önce yanıt verildiyse (Başvuruldu veya Reddedildi kartı gösterilir)
    if (basvurduMu || durum != null) {
      final reddedildi = durum == BasvuruDurumu.reddedildi;
      final renk = reddedildi ? UygulamaRenkleri.mercan : UygulamaRenkleri.naneYesili;
      final ikon = reddedildi ? Icons.cancel_rounded : Icons.check_circle_rounded;
      final metin = reddedildi
          ? (ilan.ozelIlanMi && (mevcutBasvuru?.basvuruNotu.contains('influencer tarafından reddedildi') ?? false)
              ? 'Bu Özel Teklifi Reddettiniz'
              : 'Başvurunuz Reddedildi')
          : (durum == BasvuruDurumu.kabulEdildi
              ? 'Tebrikler! Başvurunuz Kabul Edildi'
              : 'Bu İlana Başvuru Yaptınız');

      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: renk.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: renk),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(ikon, color: renk, size: 22),
            const SizedBox(width: 8),
            Text(
              metin,
              style: TextStyle(color: renk, fontWeight: FontWeight.bold, fontSize: 15),
            ),
          ],
        ),
      );
    }

    // Henüz yanıt verilmediğinde: Özel ilan ise 'Reddet' + 'Kabul Et & Başvur', Normal ilan ise tek 'İlana Başvur' butonu
    if (ilan.ozelIlanMi) {
      return Row(
        children: [
          // Reddet Butonu
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () => _reddetDiyaloguGoster(context, k),
              icon: const Icon(Icons.close_rounded, color: UygulamaRenkleri.mercan),
              label: const Text(
                'Reddet',
                style: TextStyle(color: UygulamaRenkleri.mercan, fontWeight: FontWeight.bold),
              ),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: const BorderSide(color: UygulamaRenkleri.mercan, width: 1.5),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Kabul Et & Başvur Butonu
          Expanded(
            flex: 2,
            child: ElevatedButton.icon(
              onPressed: () => IlanBasvuruModali.goster(
                context: context,
                ilan: ilan,
                influencerId: k.id,
                influencerAdi: k.adSoyad,
                influencerProfil: k.profilResmi,
              ),
              icon: const Icon(Icons.rocket_launch_rounded, size: 20),
              label: const Text(
                'Kabul Et & Başvur',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: UygulamaRenkleri.anaMor,
              ),
            ),
          ),
        ],
      );
    }

    // Normal ilan için standart başvuru butonu
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => IlanBasvuruModali.goster(
          context: context,
          ilan: ilan,
          influencerId: k.id,
          influencerAdi: k.adSoyad,
          influencerProfil: k.profilResmi,
        ),
        icon: const Icon(Icons.rocket_launch_rounded, size: 20),
        label: const Text(
          'İlana Başvur (Pitch Gönder)',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: UygulamaRenkleri.anaMor,
        ),
      ),
    );
  }
}
