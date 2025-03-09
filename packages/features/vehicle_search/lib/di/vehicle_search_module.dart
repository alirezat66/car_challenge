// lib/src/di/vehicle_search_module.dart
import 'package:get_it/get_it.dart';
import 'package:core/core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vehicle_selection/src/data/data_sources/search_local_data_source.dart';
import 'package:vehicle_selection/src/data/data_sources/search_local_data_source_impl.dart';
import 'package:vehicle_selection/vehicle_search.dart';

class VehicleSearchModule {
  static void register(GetIt locator) async {
    // External dependencies - only register if not already registered

    // Data sources
    locator.registerLazySingleton<UserDataSource>(
        () => UserDataSourceImpl(localStorage: locator<LocalStorage>()));
    locator.registerLazySingleton<SearchRemoteDataSource>(
        () => SearchRemoteDataSourceImpl(httpClient: CosChallenge.httpClient));
    if (!locator.isRegistered<SharedPreferences>()) {
      final preferences = await SharedPreferences.getInstance();
      locator.registerLazySingleton<SharedPreferences>(() => preferences);
    }
    if (!locator.isRegistered<LocalStorage>()) {
      locator.registerLazySingleton<LocalStorage>(
          () => SharedPreferencesStorage(locator<SharedPreferences>()));
    }
    if (!locator.isRegistered<SearchLocalDataSource>()) {
      locator.registerLazySingleton<SearchLocalDataSource>(
          () => SearchLocalDataSourceImpl(locator<LocalStorage>()));
    }

    // Repository
    locator.registerLazySingleton<SearchRepository>(() => SearchRepositoryImpl(
          remoteDataSource: locator<SearchRemoteDataSource>(),
          localDataSource: locator<SearchLocalDataSource>(),
          userDataSource: locator<UserDataSource>(),
        ));

    // Use cases
    locator.registerLazySingleton(
        () => SearchVehicleByVin(locator<SearchRepository>()));

    locator.registerLazySingleton(
        () => SelectVehicleOption(locator<SearchRepository>()));

    // Presentation
    locator.registerFactory(() => SearchCubit(
          searchVehicleByVin: locator<SearchVehicleByVin>(),
          selectVehicleOption: locator<SelectVehicleOption>(),
        ));
  }

  static void unregister(GetIt locator) {
    // Unregister presentation components
    if (locator.isRegistered<SearchCubit>()) {
      locator.unregister<SearchCubit>();
    }

    // Unregister use cases
    if (locator.isRegistered<SearchVehicleByVin>()) {
      locator.unregister<SearchVehicleByVin>();
    }

    if (locator.isRegistered<SelectVehicleOption>()) {
      locator.unregister<SelectVehicleOption>();
    }

    // Unregister repository
    if (locator.isRegistered<SearchRepository>()) {
      locator.unregister<SearchRepository>();
    }

    // Unregister data sources
    if (locator.isRegistered<SearchRemoteDataSource>()) {
      locator.unregister<SearchRemoteDataSource>();
    }

    if (locator.isRegistered<UserDataSource>()) {
      locator.unregister<UserDataSource>();
    }
  }
}
