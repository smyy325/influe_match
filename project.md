# InflueMatch - Modern Flutter & BLoC Mimarisi (Dosya Yapısı & Standartlar)

Bu belge, **InflueMatch** uygulamasının mimari yapısını, dizin şemasını, veri modellerini, iş kurallarını ve teknik standartlarını en güncel haliyle açıklamaktadır.

---

## 1. Mimari & Dosya İsimlendirme Standartları

Tüm dosya ve klasör isimleri küçük harf, anlaşılır `snake_case` formatında kurgulanmıştır. Dizin yapısında modüler ve sürdürülebilir **Feature-First (`core` ve `features`)** yapısı benimsenmiştir.

- **Dosya Boyutu Sınırı:** Temiz kod disiplini gereği **hiçbir dosya 150 satırı aşmayacak şekilde** mikro bileşenlere ayrıştırılmıştır.
- **Main Dosyası Sınırı:** Uygulamanın giriş noktası olan **`main.dart` dosyasının kod sayısı en fazla 40-50 satır** olacak şekilde sade ve öz tutulmaktadır.

```text
lib/
├── firebase_options.dart                     # Firebase platform konfigürasyonu
├── main.dart                                 # Uygulama başlangıç noktası & MultiBlocProvider (Max 40-50 satır)
│
├── core/                                     # Çekirdek Altyapı & Ortak Servisler
│   ├── constants/
│   │   ├── acik_tema.dart                    # Material 3 Açık Tema ayarları
│   │   ├── koyu_tema.dart                    # Material 3 Koyu Tema ayarları
│   │   ├── renkler.dart                      # Renk paleti, gradyanlar ve sabitler
│   │   └── temalar.dart                      # UygulamaTemasi (Koyu/Açık tema sağlayıcı)
│   ├── dependency/
│   │   └── servis_konfigurasyonu.dart        # GetIt bağımlılık enjeksiyonu
│   ├── error/
│   │   ├── firebase_hata_cozucu.dart         # Hata mesajı dönüştürücü
│   │   └── sonuc.dart                        # Sonuc<T> (Basari, Hata) Sealed Class
│   ├── helpers/
│   │   └── resim_saglayici_yardimcisi.dart   # Base64 & Network Image akıllı dönüştürücü
│   ├── routing/
│   │   └── uygulama_rotalari.dart            # GoRouter rota tanımları
│   └── theme/
│       └── tema_cubit.dart                   # Dinamik tema durumu (ThemeMode Cubit)
│
└── features/                                 # Modüler Özellikler (Feature-First)
    ├── auth/                                 # Kimlik Doğrulama & Yetkilendirme
    │   ├── bloc/
    │   │   ├── kimlik_bloc.dart
    │   │   ├── kimlik_event.dart
    │   │   └── kimlik_state.dart
    │   ├── models/
    │   │   └── kullanici_modeli.dart         # Kullanıcı, Rol (Marka/Influencer), Tercihler
    │   ├── repository/
    │   │   ├── firebase_kimlik_deposu.dart   # FirebaseAuth & Firestore kullanıcı deposu
    │   │   └── kimlik_deposu.dart            # IKimlikDeposu & SahteKimlikDeposu
    │   ├── screens/
    │   │   ├── giris_ekrani.dart             # E-posta & şifre ile giriş
    │   │   └── kayit_ekrani.dart             # Rol seçimiyle yeni kayıt
    │   └── widgets/
    │       ├── kimlik_baslik_bileseni.dart   # Giriş/Kayıt başlık alanı
    │       ├── rol_secim_karti.dart          # Marka / Influencer rol seçim kutuları
    │       └── sifre_sifirlama_diyalogu.dart # Şifre sıfırlama popup'ı
    │
    ├── chat/                                 # Gerçek Zamanlı Mesajlaşma
    │   ├── bloc/
    │   │   ├── sohbet_bloc.dart
    │   │   ├── sohbet_event.dart
    │   │   └── sohbet_state.dart
    │   ├── models/
    │   │   ├── mesaj_modeli.dart             # Tekil mesaj modeli
    │   │   └── sohbet_odasi_modeli.dart      # Oda, ilan başlığı ve son mesaj
    │   ├── repository/
    │   │   ├── firebase_sohbet_deposu.dart   # Firestore gerçek zamanlı sohbet deposu
    │   │   ├── sohbet_deposu.dart            # ISohbetDeposu arayüzü
    │   │   └── sohbet_model_esleyici.dart    # Karşı taraf adı/profil eşleyici
    │   ├── screens/
    │   │   ├── sohbet_detay_ekrani.dart      # Canlı mesajlaşma ekranı
    │   │   └── sohbet_listesi_ekrani.dart    # Açık sohbetler listesi
    │   └── widgets/
    │       ├── mesaj_balonu_bileseni.dart    # Gönderen/Alıcı mesaj balonları
    │       ├── mesaj_girdi_bari.dart         # Mesaj yazma ve gönderme alanı
    │       └── sohbet_satiri_bileseni.dart   # Sohbet listesi elemanı
    │
    ├── home/                                 # Ana Sayfa / Navigasyon
    │   └── screens/
    │       └── ana_sayfa_ekrani.dart         # Alt Gezinti Çubuğu (Bottom Navigation)
    │
    ├── listings/                             # İlan & Başvuru Yönetimi
    │   ├── bloc/
    │   │   ├── ilan_bloc.dart
    │   │   ├── ilan_event.dart
    │   │   └── ilan_state.dart
    │   ├── models/
    │   │   ├── basvuru_modeli.dart           # Başvuru, pitch notu ve durum modeli
    │   │   └── ilan_modeli.dart              # İlan modeli (hedefInfluencer desteğiyle)
    │   ├── repository/
    │   │   ├── firebase_basvuru_yardimcisi.dart # Firestore başvurular alt modülü
    │   │   ├── firebase_ilan_deposu.dart     # Firestore ilanlar deposu
    │   │   ├── ilan_deposu.dart              # IIlanDeposu & SahteIlanDeposu
    │   │   └── kategori_filtre_yardimcisi.dart# Kategori normalizasyonu & arama
    │   ├── screens/
    │   │   ├── basvuru_detay_ekrani.dart     # Markanın başvuru inceleme ekranı
    │   │   ├── basvurularim_ekrani.dart      # Başvurular / Gelen Teklifler listesi
    │   │   ├── ilan_akisi_ekrani.dart        # Ana kampanya akışı (Kişiye özel filtreli)
    │   │   ├── ilan_detay_ekrani.dart        # İlan detay ve başvuru ekranı
    │   │   └── ilan_olustur_ekrani.dart      # Marka yeni kampanya açma ekranı
    │   └── widgets/
    │       ├── basvuru_detay_aksiyon_butonlari.dart # Kabul / Ret butonları
    │       ├── basvuru_detay_ilan_karti.dart # İlan özet kutusu
    │       ├── basvuru_detay_influencer_karti.dart # Influencer profil & pitch notu kartı
    │       ├── basvuru_karti.dart            # Başvuru liste kartı & durum rozeti
    │       ├── basvuru_notu_kutusu.dart      # Pitch notu gösterim kutusu
    │       ├── ilan_akisi_app_bari.dart      # Akış üst çubuğu
    │       ├── ilan_arama_filtre_alani.dart  # Arama kutusu ve kategori çipleri
    │       ├── ilan_basvuru_modali.dart      # Pitch notuyla başvuru bottom sheet'i
    │       ├── ilan_bilgileri_formu.dart     # İlan formu (Hedef Influencer destekli)
    │       ├── ilan_detay_aksiyon_butonlari.dart # İlan detay aksiyon butonları
    │       ├── ilan_detay_icerik.dart        # İlan detay gereksinimleri & açıklaması
    │       ├── ilan_detay_marka_karti.dart   # İlan sahibi marka kartı
    │       ├── ilan_karti.dart               # Normal ve Sarı (Özel Teklif) ilan kartı
    │       └── ilan_sartlari_secici.dart     # Şart ekleme/çıkarma bileşeni
    │
    ├── onboarding/                           # Tanıtım / Onboarding
    │   ├── screens/
    │   │   └── tanitim_ekrani.dart           # Influencer & Marka tanıtım sayfaları
    │   └── widgets/
    │       └── tanitim_sayfasi_bileseni.dart # Sayfa içeriği kartları
    │
    ├── profile/                              # Profil, Tercihler ve Tema
    │   ├── models/
    │   │   └── kategori_tanimi.dart          # İlgi alanları & kategori tanımları
    │   ├── screens/
    │   │   ├── kullanici_profil_detay_ekrani.dart # Karşılıklı profil inceleme ekranı
    │   │   └── profil_ekrani.dart            # Kullanıcı profil yönetimi ekranı
    │   └── widgets/
    │       ├── influencer_tercihleri_alani.dart # 3 sütunlu ilgi alanları ızgarası (Max 5)
    │       ├── kategori_karti_kutusu.dart    # İkonlu kategori kutucuğu
    │       ├── profil_baslik_alani.dart      # Avatar, rozet ve fotoğraf güncelleme
    │       ├── profil_bilgi_karti.dart       # Bilgi satırları ve özet kartları
    │       ├── profil_bilgileri_formu.dart   # Profil düzenleme formu
    │       ├── profil_bilgileri_gorunumu.dart# Profil detay görünümü
    │       ├── profil_form_yoneticisi.dart   # Profil form kontrolcüleri
    │       ├── profil_onay_diyaloglari.dart  # Çıkış yap ve hesabı sil diyalogları
    │       ├── profil_resim_yardimcisi.dart  # Galeri seçim bottom sheet'i
    │       └── profil_tema_secici_karti.dart # Yalnızca profildeki Açık/Koyu tema seçici
    │
    └── splash/                               # Splash Screen
        └── screens/
            └── acilis_ekrani.dart            # Animasyonlu logo & Auth yönlendirmesi
```

---

## 2. Temel İş Kuralları ve Fonksiyonlar

1. **Çift Rol Deneyimi (Marka / Influencer):**
   - Kullanıcı kayıt olurken veya profilinden rolünü belirler.
   - Marka rolü: Kampanya açabilir, gelen başvuruları inceler, kabul/red kararı verir, ilanlarına başvuru yapamaz.
   - Influencer rolü: İlanlara pitch notu ile başvurur, ilgi alanlarını (max 5 kategori) seçer.

2. **Hedefe Özel İlan (VIP Sarı Kart):**
   - Marka kampanya oluştururken opsiyonel olarak `hedefInfluencer` adı girebilir.
   - Belirtilen isimle eşleşen influencer dışındaki üreticiler bu ilanı göremez.
   - İlan akışında bu kart **altın sarısı renkte (`sariVurgu`)** ve `⭐ SANA ÖZEL İLAN` rozetiyle vurgulanır.

3. **Karşılıklı Detaylı Profil İnceleme:**
   - Marka, gelen başvurudaki influencer'a tıklayarak biyografisini ve tercihlerini inceler.
   - Influencer, ilan sahibine tıklayarak markanın kurumsal profilini inceler.
   - Profil detayından doğrudan sohbet başlatılabilir.

4. **Şeffaf Başvuru Durumu Senkronizasyonu:**
   - Marka başvuru detayında *Kabul Et* veya *Reddet* butonuna bastığında karar Firestore'a yazılır.
   - Influencer'ın ekranındaki rozet (`Değerlendiriliyor`, `Kabul Edildi`, `Reddedildi`) anlık olarak senkronize güncellenir.

5. **Dinamik Açık & Koyu Tema:**
   - Tema seçeneği **yalnızca** Profil ekranında sunulur (`ProfilTemaSeciciKarti`).
   - `TemaCubit` üzerinden anlık olarak tüm ekranlar (kartlar, açılır kutular, sohbet balonları, şartlar) kusursuz kontrastla açık veya koyu temaya adapte olur.

6. **150 Satır Sınırı & Main Dosyası (Max 40-50 Satır) Disiplini:**
   - Kod tabanındaki her dosya kesinlikle en fazla 150 satırdır.
   - `main.dart` dosyası en fazla **40-50 satır** sınırı kuralına sadık kalınarak sadece uygulama başlatma ve temel sağlayıcıları (MultiBlocProvider) barındırır.
   - Kod tekrarı önlenmiş, sorumluluklar mikro bileşenlere ayrılmıştır.
