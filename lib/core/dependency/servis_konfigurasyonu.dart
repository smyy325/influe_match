import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';
import '../../features/auth/bloc/kimlik_bloc.dart';
import '../../features/auth/repository/firebase_kimlik_deposu.dart';
import '../../features/auth/repository/kimlik_deposu.dart';
import '../../features/chat/bloc/sohbet_bloc.dart';
import '../../features/chat/repository/firebase_sohbet_deposu.dart';
import '../../features/chat/repository/sohbet_deposu.dart';
import '../../features/listings/bloc/ilan_bloc.dart';
import '../../features/listings/repository/firebase_ilan_deposu.dart';
import '../../features/listings/repository/ilan_deposu.dart';
import '../../firebase_options.dart';
import '../theme/tema_cubit.dart';

final bulucu = GetIt.instance;

Future<void> servisleriBaslat({bool testModu = false}) async {
  bool firebaseBaslatildi = false;

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

  if (firebaseBaslatildi) {
    bulucu.registerLazySingleton<IKimlikDeposu>(() => FirebaseKimlikDeposu());
    bulucu.registerLazySingleton<IIlanDeposu>(() => FirebaseIlanDeposu());
    bulucu.registerLazySingleton<ISohbetDeposu>(() => FirebaseSohbetDeposu());
  } else {
    bulucu.registerLazySingleton<IKimlikDeposu>(() => SahteKimlikDeposu());
    bulucu.registerLazySingleton<IIlanDeposu>(() => SahteIlanDeposu());
    bulucu.registerLazySingleton<ISohbetDeposu>(() => SahteSohbetDeposu());
  }

  bulucu.registerLazySingleton<TemaCubit>(() => TemaCubit());

  bulucu.registerLazySingleton<KimlikBloc>(
    () => KimlikBloc(kimlikDeposu: bulucu<IKimlikDeposu>()),
  );

  bulucu.registerFactory<IlanBloc>(
    () => IlanBloc(ilanDeposu: bulucu<IIlanDeposu>()),
  );

  bulucu.registerFactory<SohbetBloc>(
    () => SohbetBloc(sohbetDeposu: bulucu<ISohbetDeposu>()),
  );
}
