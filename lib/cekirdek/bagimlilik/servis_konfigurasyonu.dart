import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';
import '../../firebase_options.dart';
import '../tema/tema_cubit.dart';
import '../../ozellikler/ilanlar/bloc/ilan_bloc.dart';
import '../../ozellikler/ilanlar/depo/firebase_ilan_deposu.dart';
import '../../ozellikler/ilanlar/depo/ilan_deposu.dart';
import '../../ozellikler/kimlik/bloc/kimlik_bloc.dart';
import '../../ozellikler/kimlik/depo/firebase_kimlik_deposu.dart';
import '../../ozellikler/kimlik/depo/kimlik_deposu.dart';
import '../../ozellikler/sohbet/bloc/sohbet_bloc.dart';
import '../../ozellikler/sohbet/depo/firebase_sohbet_deposu.dart';
import '../../ozellikler/sohbet/depo/sohbet_deposu.dart';

/// bulucu: Tüm proje boyunca bağımlılıklara erişimi sağlayan GetIt servis örneği (Service Locator).
final bulucu = GetIt.instance;

/// servisleriBaslat(): Uygulama başlangıcında Firebase'i başlatan ve bağımlılıkları kaydeden fonksiyon.
Future<void> servisleriBaslat({bool testModu = false}) async {
  bool firebaseBaslatildi = false;

  // Firebase platform ayarlarıyla ilklendirme yapılır.
  if (!testModu) {
    try {
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
      }
      firebaseBaslatildi = true;
    } catch (e) {
      firebaseBaslatildi = false;
    }
  }

  // 1. Depolar (Repositories Kaydı):
  // registerLazySingleton: İlk ihtiyaç duyulduğunda oluşturulan ve bellekte tek örnek tutulan nesneler.
  if (firebaseBaslatildi) {
    bulucu.registerLazySingleton<IKimlikDeposu>(() => FirebaseKimlikDeposu());
    bulucu.registerLazySingleton<IIlanDeposu>(() => FirebaseIlanDeposu());
    bulucu.registerLazySingleton<ISohbetDeposu>(() => FirebaseSohbetDeposu());
  } else {
    bulucu.registerLazySingleton<IKimlikDeposu>(() => SahteKimlikDeposu());
    bulucu.registerLazySingleton<IIlanDeposu>(() => SahteIlanDeposu());
    bulucu.registerLazySingleton<ISohbetDeposu>(() => SahteSohbetDeposu());
  }

  // 2. BLoC'lar & Cubit'ler Kaydı:
  // TemaCubit: Tekil (Singleton) tema durum yöneticisi.
  bulucu.registerLazySingleton<TemaCubit>(() => TemaCubit());

  // KimlikBloc: Tekil oturum ve kullanıcı kimlik BLoC'u.
  bulucu.registerLazySingleton<KimlikBloc>(
    () => KimlikBloc(kimlikDeposu: bulucu<IKimlikDeposu>()),
  );

  // registerFactory: Her çağrıldığında yeni bir BLoC örneği üreten kayit metodu.
  bulucu.registerFactory<IlanBloc>(
    () => IlanBloc(ilanDeposu: bulucu<IIlanDeposu>()),
  );

  bulucu.registerFactory<SohbetBloc>(
    () => SohbetBloc(sohbetDeposu: bulucu<ISohbetDeposu>()),
  );
}
