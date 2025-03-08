import 'package:car_challenge/core/client/snippet.dart';
import 'package:car_challenge/core/error/factory/failure_factory.dart';
import 'package:car_challenge/features/user_identification/data/datasources/local_data_source.dart';
import 'package:car_challenge/features/user_identification/data/repositories/user_repository_impl.dart';
import 'package:car_challenge/features/user_identification/domain/repositories/user_repository.dart';
import 'package:car_challenge/features/user_identification/domain/usecases/get_user_identification.dart';
import 'package:car_challenge/features/user_identification/domain/usecases/save_identification.dart';
import 'package:car_challenge/features/user_identification/presentation/cubit/user_identification_cubit.dart';
import 'package:car_challenge/features/vehicle_selection/data/datasources/vehicle_local_data_source.dart';
import 'package:car_challenge/features/vehicle_selection/data/datasources/vehicle_local_data_source_impl.dart';
import 'package:car_challenge/features/vehicle_selection/data/datasources/vehicle_remote_data_source.dart';
import 'package:car_challenge/features/vehicle_selection/data/datasources/vehicle_remote_data_source_impl.dart';
import 'package:car_challenge/features/vehicle_selection/data/repositories/vehicle_repository_impl.dart';
import 'package:car_challenge/features/vehicle_selection/domain/repositories/vehicle_repository.dart';
import 'package:car_challenge/features/vehicle_selection/domain/usecases/get_vehicle_data.dart';
import 'package:car_challenge/features/vehicle_selection/presentation/cubit/vehicle_selection_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GetIt locator = GetIt.instance;

class ServiceLocator {
  Future<void> setup() async {
    await _setupPreferences();
    _setupFactories();
    _setupUserIdentifier();
    _setupVehicleSelection();
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

  void _setupVehicleSelection() {
    // Register HTTP client
    locator.registerLazySingleton(() => CosChallenge.httpClient);

    // Data sources
    locator.registerLazySingleton<VehicleLocalDataSource>(
      () => VehicleLocalDataSourceImpl(
        locator<SharedPreferences>(),
      ),
    );

    locator.registerLazySingleton<VehicleRemoteDataSource>(
      () => VehicleRemoteDataSourceImpl(
        CosChallenge.httpClient,
      ),
    );

    // Repository
    locator.registerLazySingleton<VehicleRepository>(
      () => VehicleRepositoryImpl(
        remoteDataSource: locator<VehicleRemoteDataSource>(),
        localDataSource: locator<VehicleLocalDataSource>(),
      ),
    );

    // Use cases
    locator.registerLazySingleton(
      () => GetVehicleData(
        locator<VehicleRepository>(),
      ),
    );

    // Cubit
    locator.registerFactory(
      () => VehicleSelectionCubit(
        getVehicleData: locator<GetVehicleData>(),
      ),
    );
  }

  void _setupFactories() {
    setupFailureFactory();
  }
}
