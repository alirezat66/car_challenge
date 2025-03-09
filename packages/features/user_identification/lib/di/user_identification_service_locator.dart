import 'package:core/core.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user_identification/user_identification.dart';

class UserIdentificationServiceLocator {
  void setup(GetIt locator) async {
    // Register LocalStorage if not already registered
    if (!locator.isRegistered<LocalStorage>()) {
      final sharedPreferences = await SharedPreferences.getInstance();
      locator.registerLazySingleton<LocalStorage>(
        () => SharedPreferencesStorage(sharedPreferences),
      );
    }

    // Register data sources
    if (!locator.isRegistered<LocalDataSource>()) {
      locator.registerLazySingleton<LocalDataSource>(
        () => LocalDataSourceImpl(locator<LocalStorage>()),
      );
    }

    // Register repositories
    if (!locator.isRegistered<UserRepository>()) {
      locator.registerLazySingleton<UserRepository>(
        () => UserRepositoryImpl(locator<LocalDataSource>()),
      );
    }

    // Register use cases
    if (!locator.isRegistered<GetUserIdentification>()) {
      locator.registerLazySingleton(
        () => GetUserIdentification(locator<UserRepository>()),
      );
    }

    if (!locator.isRegistered<SaveUserIdentification>()) {
      locator.registerLazySingleton(
        () => SaveUserIdentification(locator<UserRepository>()),
      );
    }

    // Register cubit
    locator.registerFactory(
      () => UserIdentificationCubit(
        locator<SaveUserIdentification>(),
        locator<GetUserIdentification>(),
      ),
    );
  }
}
