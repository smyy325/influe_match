import 'dart:async';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:influematch/cekirdek/bagimlilik/servis_konfigurasyonu.dart';
import 'package:influematch/cekirdek/hata/sonuc.dart';
import 'package:influematch/main.dart';
import 'package:influematch/ozellikler/kimlik/bloc/kimlik_bloc.dart';
import 'package:influematch/ozellikler/kimlik/bloc/kimlik_event.dart';
import 'package:influematch/ozellikler/kimlik/bloc/kimlik_state.dart';
import 'package:influematch/ozellikler/kimlik/depo/kimlik_deposu.dart';
import 'package:influematch/ozellikler/kimlik/model/kullanici_modeli.dart';
import 'package:influematch/ozellikler/ilanlar/bloc/ilan_bloc.dart';
import 'package:influematch/ozellikler/ilanlar/bloc/ilan_event.dart';
import 'package:influematch/ozellikler/ilanlar/bloc/ilan_state.dart';
import 'package:influematch/ozellikler/ilanlar/depo/ilan_deposu.dart';
import 'package:influematch/ozellikler/ilanlar/model/basvuru_modeli.dart';
import 'package:influematch/ozellikler/ilanlar/model/ilan_modeli.dart';
import 'package:influematch/ozellikler/sohbet/bloc/sohbet_bloc.dart';
import 'package:influematch/ozellikler/sohbet/bloc/sohbet_event.dart';
import 'package:influematch/ozellikler/sohbet/bloc/sohbet_state.dart';
import 'package:influematch/ozellikler/sohbet/depo/sohbet_deposu.dart';
import 'package:influematch/ozellikler/sohbet/model/mesaj_modeli.dart';

final List<int> _seffafPng = [
  0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, 0x00, 0x00, 0x00, 0x0D,
  0x49, 0x48, 0x44, 0x52, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01,
  0x08, 0x06, 0x00, 0x00, 0x00, 0x1F, 0x15, 0xC4, 0x89, 0x00, 0x00, 0x00,
  0x0A, 0x49, 0x44, 0x41, 0x54, 0x78, 0x9C, 0x63, 0x00, 0x01, 0x00, 0x00,
  0x05, 0x00, 0x01, 0x0D, 0x0A, 0x2D, 0xB4, 0x00, 0x00, 0x00, 0x00, 0x49,
  0x45, 0x4E, 0x44, 0xAE, 0x42, 0x60, 0x82
];

class _MockHttpClient extends Fake implements HttpClient {
  @override
  bool autoUncompress = true;
  @override
  Duration? connectionTimeout;
  @override
  Duration idleTimeout = const Duration(seconds: 15);
  @override
  int? maxConnectionsPerHost;
  @override
  String? userAgent;

  @override
  Future<HttpClientRequest> getUrl(Uri url) async => _MockHttpRequest();
}

class _MockHttpRequest extends Fake implements HttpClientRequest {
  @override
  final HttpHeaders headers = _MockHttpHeaders();

  @override
  Future<HttpClientResponse> close() async => _MockHttpResponse();
}

class _MockHttpHeaders extends Fake implements HttpHeaders {
  @override
  void add(String name, Object value, {bool preserveHeaderCase = false}) {}
  @override
  void set(String name, Object value, {bool preserveHeaderCase = false}) {}
}

class _MockHttpResponse extends Fake implements HttpClientResponse {
  @override
  int get statusCode => 200;
  @override
  int get contentLength => _seffafPng.length;
  @override
  HttpClientResponseCompressionState get compressionState =>
      HttpClientResponseCompressionState.notCompressed;
  @override
  final HttpHeaders headers = _MockHttpHeaders();

  @override
  StreamSubscription<List<int>> listen(
    void Function(List<int> event)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    return Stream<List<int>>.value(_seffafPng).listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }
}

class _TestHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) => _MockHttpClient();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    HttpOverrides.global = _TestHttpOverrides();
    await servisleriBaslat(testModu: true);
  });

  group('Kimlik Modülü Testleri', () {
    late IKimlikDeposu kimlikDeposu;
    late KimlikBloc kimlikBloc;

    setUp(() {
      kimlikDeposu = SahteKimlikDeposu();
      kimlikBloc = KimlikBloc(kimlikDeposu: kimlikDeposu);
    });

    tearDown(() {
      kimlikBloc.close();
    });

    test('KimlikDurumunuKontrolEtEvent oturum yoksa KimlikDogrulanmadi vermeli', () async {
      kimlikBloc.add(KimlikDurumunuKontrolEtEvent());

      await expectLater(
        kimlikBloc.stream,
        emitsInOrder([
          isA<KimlikYukleniyor>(),
          isA<KimlikDogrulanmadi>(),
        ]),
      );
    });

    test('GirisYapEvent kullanıcı girişini sağlamalı', () async {
      kimlikBloc.add(const GirisYapEvent(email: 'test@influematch.com', sifre: '123456'));

      await expectLater(
        kimlikBloc.stream,
        emitsInOrder([
          isA<KimlikYukleniyor>(),
          isA<KimlikDogrulandi>().having(
            (s) => s.kullanici.email,
            'email',
            'test@influematch.com',
          ),
        ]),
      );
    });

    test('RolDegistirEvent rolü başarıyla güncellemeli', () async {
      await kimlikDeposu.girisYap('test@influematch.com', '123456');
      kimlikBloc.add(RolDegistirEvent());

      await expectLater(
        kimlikBloc.stream,
        emitsInOrder([
          isA<KimlikDogrulandi>().having(
            (s) => s.kullanici.rol,
            'rol',
            Rol.marka,
          ),
        ]),
      );
    });
  });

  group('İlan Modülü Testleri', () {
    late IIlanDeposu ilanDeposu;
    late IlanBloc ilanBloc;

    setUp(() async {
      ilanDeposu = SahteIlanDeposu();
      await ilanDeposu.ilanOlustur(IlanModeli(
        id: 'ilan_test_1',
        markaId: 'marka_1',
        markaAdi: 'Test Marka',
        baslik: 'Test İlanı',
        aciklama: 'Test Açıklaması',
        kategori: 'Teknoloji',
        sartlar: const ['Şart 1'],
        olusturulmaTarihi: DateTime.now(),
      ));
      ilanBloc = IlanBloc(ilanDeposu: ilanDeposu);
    });

    tearDown(() {
      ilanBloc.close();
    });

    test('IlanlariYukleEvent ilanları listelemeli', () async {
      ilanBloc.add(const IlanlariYukleEvent());

      await expectLater(
        ilanBloc.stream,
        emitsInOrder([
          isA<IlanYukleniyor>(),
          isA<IlanlarYuklendi>().having(
            (s) => s.ilanlar.length,
            'ilan sayisi',
            greaterThanOrEqualTo(1),
          ),
        ]),
      );
    });

    test('IlanaBasvurEvent başvuru eklemeli', () async {
      final basvuru = BasvuruModeli(
        id: 'test_basvuru_1',
        ilanId: 'ilan_test_1',
        ilanBasligi: 'Test İlanı',
        markaAdi: 'Test Marka',
        influencerId: 'kullanici_test',
        influencerAdi: 'Test Influencer',
        basvuruNotu: 'Kampanyanız için harika bir fikrim var!',
        tarih: DateTime.now(),
      );

      final sonuc = await ilanDeposu.ilanaBasvur(basvuru);
      expect(sonuc, isA<Basari<BasvuruModeli>>());
    });

    test('Özel ilanı reddetme işlemi başvuruyu reddedildi olarak kaydetmeli', () async {
      final reddedilenBasvuru = BasvuruModeli(
        id: 'test_basvuru_red_1',
        ilanId: 'ilan_test_1',
        ilanBasligi: 'Test İlanı',
        markaAdi: 'Test Marka',
        influencerId: 'kullanici_red',
        influencerAdi: 'Reddeden Influencer',
        basvuruNotu: 'Özel teklif influencer tarafından reddedildi.',
        durum: BasvuruDurumu.reddedildi,
        tarih: DateTime.now(),
      );

      final sonuc = await ilanDeposu.ilanaBasvur(reddedilenBasvuru);
      expect(sonuc, isA<Basari<BasvuruModeli>>());
      final kayitli = (sonuc as Basari<BasvuruModeli>).veri;
      expect(kayitli.durum, equals(BasvuruDurumu.reddedildi));
    });
  });

  group('Sohbet Modülü Testleri', () {
    late ISohbetDeposu sohbetDeposu;
    late SohbetBloc sohbetBloc;

    setUp(() async {
      sohbetDeposu = SahteSohbetDeposu();
      await sohbetDeposu.sohbetOlusturVeyaGetir(
        ilanId: 'ilan_test_1',
        ilanBasligi: 'Test İlanı',
        karsiTarafId: 'marka_1',
        karsiTarafAdi: 'Test Marka',
        karsiTarafProfil: '',
        karsiTarafRol: 'Marka',
        mevcutKullaniciId: 'kullanici_001',
      );
      sohbetBloc = SohbetBloc(sohbetDeposu: sohbetDeposu);
    });

    tearDown(() {
      sohbetBloc.close();
    });

    test('SohbetOdalariniYukleEvent odaları başarıyla getirmeli', () async {
      sohbetBloc.add(const SohbetOdalariniYukleEvent('kullanici_001'));

      await expectLater(
        sohbetBloc.stream,
        emitsInOrder([
          isA<SohbetYukleniyor>(),
          isA<SohbetOdalariYuklendi>().having(
            (s) => s.odalar.isNotEmpty,
            'odalar bos degil',
            true,
          ),
        ]),
      );
    });

    test('MesajGonderEvent mesaj kaydetmeli', () async {
      final yeniMesaj = MesajModeli(
        id: 'test_m1',
        sohbetId: 'sohbet_1',
        gondericiId: 'kullanici_001',
        aliciId: 'marka_101',
        icerik: 'Merhaba, teslim adresi iletildi.',
        zaman: DateTime.now(),
      );

      final sonuc = await sohbetDeposu.mesajGonder(yeniMesaj);
      expect(sonuc, isA<Basari<MesajModeli>>());
    });
  });

  testWidgets('Açılış (Splash) ve Tanıtım (Onboarding) akış testi', (WidgetTester tester) async {
    await tester.pumpWidget(const InflueMatchUygulamasi());
    await tester.pump();

    // 1. Açılış (Splash) ekranında logo ve başlık görüntülenmeli
    expect(find.text('InflueMatch'), findsOneWidget);
    expect(find.text('İçerik Üreticileri & Markalar Tek Platformda'), findsOneWidget);

    // Timer süresini ilerlet (2500ms)
    await tester.pump(const Duration(milliseconds: 2500));
    await tester.pumpAndSettle();

    // 2. Tanıtım (Onboarding) 1. Ekran: Influencer Tanıtımı
    expect(find.text('İçerik Üreticileri İçin'), findsOneWidget);
    expect(find.text('Yaratıcılığınla Markaları Büyüt'), findsOneWidget);
    expect(find.text('Markaları Keşfet'), findsOneWidget);

    // İleri butonuna basarak 2. Ekrana (Markalar) geç
    await tester.tap(find.text('Markaları Keşfet'));
    await tester.pumpAndSettle();

    // 3. Tanıtım 2. Ekran: Markalar Tanıtımı & Giriş/Kayıt Butonları
    expect(find.text('Markalar & Ajanslar İçin'), findsOneWidget);
    expect(find.text('En Doğru İçerik Üreticilerini Keşfet'), findsOneWidget);
    expect(find.text('Giriş Yap'), findsOneWidget);
    expect(find.text('Ücretsiz Kayıt Ol'), findsOneWidget);

    // Giriş Yap butonuna basınca Giriş ekranı açılmalı
    await tester.tap(find.text('Giriş Yap'));
    await tester.pumpAndSettle();

    expect(find.text('E-Posta Adresi'), findsOneWidget);
    expect(find.text('Şifre'), findsOneWidget);
  });
}
