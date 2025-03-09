import 'package:core/core.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user_identification/di/user_identification_service_locator.dart';
import 'package:vehicle_selection/di/vehicle_search_module.dart';

final GetIt locator = GetIt.instance;

class ServiceLocator {
  Future<void> setup() async {
    await _setupCore();
    _setupFeatures();
  }

  Future<void> _setupCore() async {
    // Setup SharedPreferences
    final preferences = await SharedPreferences.getInstance();
    locator.registerLazySingleton<SharedPreferences>(() => preferences);

    // Setup LocalStorage
    locator.registerLazySingleton<LocalStorage>(
      () => SharedPreferencesStorage(locator<SharedPreferences>()),
    );

    // Setup FailureFactory
    setupFailureFactory();
  }

  void _setupFeatures() {
    // Register User Identification Package
    final userIdentificationModule = UserIdentificationServiceLocator();
    userIdentificationModule.setup(locator);

    // Register Vehicle Search Package
    VehicleSearchModule.register(locator);
  }
}
