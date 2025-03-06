import 'package:car_challenge/features/user_identification/data/datasources/local_data_source.dart';
import 'package:car_challenge/features/user_identification/data/repositories/user_repository_impl.dart';
import 'package:car_challenge/features/user_identification/domain/repositories/user_repository.dart';
import 'package:car_challenge/features/user_identification/domain/usecases/get_user_identification.dart';
import 'package:car_challenge/features/user_identification/domain/usecases/save_identification.dart';
import 'package:car_challenge/features/user_identification/presentation/cubit/user_identification_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GetIt locator = GetIt.instance;

void setup() async {
  await _setupPreferences();
  _setupUserIdentifier();
}

Future<void> _setupPreferences() async {
  final preferences = await SharedPreferences.getInstance();
  locator.registerLazySingleton<SharedPreferences>(() => preferences);
}

void _setupUserIdentifier() {
 // Data sources
  locator.registerLazySingleton<LocalDataSource>(
    () => LocalDataSource(
      locator<SharedPreferences>(),
    ),
  );

  // Repositories
  locator.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(
      locator<LocalDataSource>(),
    ),
  );

  // Use cases
  locator.registerLazySingleton(
    () => GetUserIdentification(
      locator<UserRepository>(),
    ),
  );
  locator.registerLazySingleton(
    () => SaveUserIdentification(
      locator<UserRepository>(),
    ),
  );


  // Cubit
  locator.registerFactory(() => UserIdentificationCubit(
        locator<SaveUserIdentification>(),
        locator<GetUserIdentification>(),
      ));
}
