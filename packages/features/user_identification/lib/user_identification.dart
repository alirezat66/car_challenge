/// User identification feature package
library user_identification;

// Domain layer exports
export 'src/domain/entities/user.dart';
export 'src/domain/repositories/user_repository.dart';
export 'src/domain/usecases/get_user_identification.dart';
export 'src/domain/usecases/save_identification.dart';

// Data layer exports
export 'src/data/models/user_model.dart';
export 'src/data/datasources/local_data_source.dart';
export 'src/data/repositories/user_repository_impl.dart';

// Presentation layer exports
export 'src/presentation/cubit/user_identification_cubit.dart';
export 'src/presentation/pages/user_identification_page.dart';

// DI exports
export 'di/user_identification_service_locator.dart';
