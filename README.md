# 🤝 InflueMatch - Modern Flutter & BLoC İş Birliği Platformu

**InflueMatch**, yeni büyüme aşamasındaki düşük bütçeli içerik üreticileri (Mikro Influencer) ile elindeki işin boyutu gereği yüksek ajans bütçeleri ayırmak istemeyen markaları/KOBİ'leri bir araya getiren mobil iş birliği platformudur.

---

## 📌 Proje Hakkında ve Amacı

Geleneksel pazarlamada mikro influencer'lar takipçi sayıları henüz çok yüksek olmadığı için büyük ajansların radarına giremezken, küçük bütçeli markalar da spesifik kampanyaları için yüksek bütçeler harcamak istememektedir. 

**InflueMatch**, bu iki tarafı doğrudan ve aracısız buluşturarak:
- **Mikro Influencer'lara:** İlk ticari iş birliklerini bulma, deneyim kazanma ve gelir elde etme imkanı sunar.
- **Markalara:** Küçük bütçeli işlerini niş ve hevesli içerik üreticileriyle uygun maliyetle tamamlama fırsatı verir.

---

## 🛠 Mimari ve Teknolojik Altyapı

Proje, modern Flutter standartları ve sürdürülebilirlik ilkeleri doğrultusunda geliştirilmiştir:

- **Mimari Desen:** Feature-First (`core` ve `features`) Modüler Yapı
- **Durum Yönetimi (State Management):** BLoC & Cubit (`flutter_bloc`)
- **Bağımlılık Enjeksiyonu (DI):** GetIt (`get_it`)
- **Navigasyon:** GoRouter (`go_router`)
- **Backend Servisleri:** Firebase Auth & Cloud Firestore
- **Tasarım Dili:** Material 3 (Dinamik Açık & Koyu Tema Desteği)

### 📐 Temiz Kod ve Satır Sınırı Disiplini
- **Mikro Bileşen Mimarisi:** Kod tabanındaki her dosya en fazla **150 satır** olacak şekilde mikro bileşenlere ayrılmıştır.
- **Sade Main Dosyası:** Uygulama başlangıç noktası `main.dart` dosyası en fazla **40-50 satır** sınırı kuralına sadık kalınarak sadece bootstrap ve bağımlılık yüklemelerini barındırır.

---

## 📂 Proje Dizin Yapısı (`lib/` Klasör İskeleti)

```text
lib/
├── firebase_options.dart                     # Firebase platform konfigürasyonu
├── main.dart                                 # Uygulama başlangıç noktası & MultiBlocProvider (Max 40-50 satır)
│
├── core/                                     # Çekirdek Altyapı & Ortak Servisler
│   ├── constants/                            # Açık/Koyu Tema Ayarları, Renk Paleti ve Sabitler
│   ├── dependency/                           # GetIt Bağımlılık Enjeksiyonu Konfigürasyonu
│   ├── error/                                # Firebase Hata Çözücü ve Sonuc Sealed Class
│   ├── helpers/                              # Base64 ve Görsel Dönüştürücü Yardımcılar
│   ├── routing/                              # GoRouter Rota Tanımları
│   └── theme/                                # Dinamik Tema Durum Yönetimi (ThemeMode Cubit)
│
└── features/                                 # Modüler Özellikler (Feature-First)
    ├── auth/                                 # Kimlik Doğrulama (Giriş, Kayıt, Rol Seçimi)
    ├── chat/                                 # Gerçek Zamanlı Mesajlaşma (Sohbet Odaları & Canlı Akış)
    ├── home/                                 # Ana Sayfa Kabuğu & Alt Navigasyon
    ├── listings/                             # İlan Akışı, VIP Sarı İlan & Başvuru Yönetimi
    ├── onboarding/                           # Tanıtım & Karşılama Sayfaları
    ├── profile/                              # Profil Yönetimi, Tercihler (Max 5 İlgi Alanı) & Tema
    └── splash/                           # Animasyonlu Açılış & Auth Yönlendirmesi
```

---

## 🌟 Öne Çıkan Özellikler

1. **Çift Rol Deneyimi (Marka / Influencer):** Kullanıcı kaydolurken rolünü belirler. Markalar kampanya açıp başvuruları incelerken, influencer'lar pitch notuyla ilanlara başvurabilir.
2. **VIP Sarı İlan Kartı (Hedefe Özel İlan):** Markanın belirli bir influencer'a özel açtığı ilanlar, sadece o kullanıcıya altın sarısı vurgulu VIP rozetiyle görüntülenir.
3. **Gerçek Zamanlı Sohbet:** Firestore Stream altyapısı ile marka ve influencer arasında anlık canlı mesajlaşma.
4. **Şeffaf Başvuru Senkronizasyonu:** Başvuru durumları (*Değerlendiriliyor, Kabul Edildi, Reddedildi*) her iki tarafta anlık olarak senkronize güncellenir.
5. **Karşılıklı Detaylı Profil İnceleme:** Markalar başvuran üreticinin biyografisini ve tercihlerini; üreticiler ise markanın kurumsal profilini inceleyebilir.
6. **Dinamik Açık & Koyu Tema:** Profil ekranından tek dokunuşla tüm uygulamayı Açık veya Koyu Material 3 temasına geçirme (`TemaCubit`).

---

## 🚀 Kurulum ve Çalıştırma

1. Projeyi klonlayın:
   ```bash
   git clone https://github.com/smyy325/influe_match.git
   cd influe_match
   ```

2. Bağımlılıkları yükleyin:
   ```bash
   flutter pub get
   ```

3. Uygulamayı çalıştırın:
   ```bash
   flutter run
   ```
