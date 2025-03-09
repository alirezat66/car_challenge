library vehicle_search;

// Domain entities
export 'src/domain/entities/vehicle_choice.dart';
export 'src/domain/entities/search_result.dart';

// Domain repositories and use cases
export 'src/domain/repositories/search_repository.dart';
export 'src/domain/usecases/search_vehicle_by_vin.dart';
export 'src/domain/usecases/select_vehicle_option.dart';

// Data layer models
export 'src/data/models/vehicle_choice_model.dart';

// Data layer sources and repositories
export 'src/data/data_sources/search_remote_data_source.dart';
export 'src/data/data_sources/search_remote_data_source_impl.dart';
export 'src/data/data_sources/user_data_source.dart';
export 'src/data/data_sources/user_data_source_impl.dart';
export 'src/data/repositories/search_repository_impl.dart';

// Presentation layer
export 'src/presentation/cubit/search_cubit.dart';
export 'src/presentation/pages/search/search_page.dart';
export 'src/presentation/pages/factory/search_state_widget_factory.dart';
export 'src/presentation/pages/search/widgets/vehicle_choice_view.dart';
export 'src/presentation/pages/search/widgets/vin_input_form.dart';

// Dependency Injection
export 'di/vehicle_search_module.dart';
