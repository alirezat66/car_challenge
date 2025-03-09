# CarOnSale Challenge

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Clean Architecture](https://img.shields.io/badge/Clean-Architecture-1abc9c?style=for-the-badge)
![MIT License](https://img.shields.io/apm/l/atomic-design-ui.svg?)

A robust, feature-rich Flutter application built for the CarOnSale coding challenge. This project showcases best practices in modular architecture, elegant error handling, and effective state management.

## 📱 Application Overview

CarOnSale Challenge is a mobile application that implements:

1. **User Identification**: Securely collect and store user identifiers
2. **Vehicle Search by VIN**: Validate and process Vehicle Identification Numbers
3. **Multiple Vehicle Selection**: Handle cases where a VIN matches multiple vehicles
4. **Data Caching**: Persist vehicle data between sessions and handle network failures
5. **Auction Details**: Display comprehensive auction information with visual feedback

## 🏗️ Architecture & Structure

This project follows a modular approach with Clean Architecture principles, organized into feature-based packages.

### Project Structure

```
lib/
├── core/                          # Core components and utilities
│   ├── di/                        # Dependency injection setup
│   ├── route/                     # Application routing
│   └── ...                        # Other core utilities
│
├── main.dart                      # Application entry point
│
packages/
├── core/                          # Core utilities package
│   ├── lib/                       # Library source files
│   │   ├── src/                   # Implementation details
│   │   │   ├── client/            # Network client implementations
│   │   │   ├── error/             # Error handling and failures
│   │   │   ├── storage/           # Storage implementations
│   │   │   └── utils/             # Shared utilities
│   │   └── core.dart              # Library exports
│   └── test/                      # Tests for core functionality
│
├── features/                      # Feature-specific packages
│   ├── user_identification/       # User identification feature
│   │   ├── lib/                   # Library source files
│   │   │   ├── di/                # Feature-specific DI setup
│   │   │   ├── src/               # Implementation details
│   │   │   │   ├── data/          # Data layer (repositories, models)
│   │   │   │   ├── domain/        # Domain layer (entities, use cases)
│   │   │   │   └── presentation/  # UI layer (pages, cubit)
│   │   │   └── user_identification.dart # Library exports
│   │   └── test/                  # Tests for user identification
│   │
│   └── vehicle_search/            # Vehicle search feature
│       ├── lib/                   # Library source files
│       │   ├── di/                # Feature-specific DI setup
│       │   ├── src/               # Implementation details 
│       │   │   ├── data/          # Data layer (repositories, models)
│       │   │   ├── domain/        # Domain layer (entities, use cases)
│       │   │   └── presentation/  # UI layer (pages, cubit)
│       │   └── vehicle_search.dart # Library exports
│       └── test/                  # Tests for vehicle search
│
└── ui_kit/                        # UI components package
    ├── lib/                       # Library source files
    │   ├── src/                   # Implementation details
    │   │   ├── components/        # Reusable UI components
    │   │   ├── notification/      # Notification services
    │   │   └── theme/             # Theming and styling
    │   └── ui_kit.dart            # Library exports
    └── test/                      # Tests for UI components
```

### Architectural Elements

- **Clean Architecture**: Separation of concerns with repository pattern
- **Feature-First Organization**: Modular, self-contained feature packages
- **Independency**: Presentation logic separated from business logic
- **Dependency Injection**: Using GetIt for service location
- **BLoC/Cubit**: State management with reactive patterns
- **Go Router**: Advanced navigation management
- **Multi Theming**: We picked color pallets for two dark and light theme that works based on user phone theme

## ✨ Key Features

### User Identification
- Secure local storage of user identifiers
- Persistence across app launches
- Elegant UI for data collection
- Local Storage can be replace with other technology easily
### VIN Search
- Robust validation of 17-character VIN codes
- Network error handling with graceful degradation
- Comprehensive feedback for invalid inputs
- Multiple vehicle match resolution
- Json fixer strategy with extendability
### Error Handling
- Friendly user feedback for all error types:
  - Network errors
  - Server maintenance
  - Validation errors
  - Deserialization issues
- Recovery strategies with retry mechanisms

### Data Persistence
- Local caching of vehicle data
- Fallback to cached data during connectivity issues
- Automatic retrieval of previously searched vehicles

### Auction Details
- Rich UI displaying comprehensive vehicle information
- Visual representation of price information
- Feedback indicators with contextual colors

## 🧪 Testing

The project includes comprehensive tests:

- **Unit Tests**: Core logic, repositories, and use cases
- **BLoC/Cubit Tests**: State management verification
- **Widget Tests**: UI component validation


## 🛠️ Technical Implementation

### Dependencies Used

```yaml
# State Management
flutter_bloc: ^9.1.0
equatable: ^2.0.5

# Networking
dio: ^5.1.1
http: ^1.1.0

# Dependency Injection
get_it: ^7.6.0

# Navigation
go_router: ^10.0.0

# Local Storage
shared_preferences: ^2.2.0

# Functional Programming
dartz: ^0.10.1

# Testing
mockito: ^5.4.2
bloc_test: ^9.1.4
```

### Design Decisions

1. **Feature Isolation**: Each feature is self-contained with its own data, domain, and presentation layers
2. **Error Handling Strategy**: Factory pattern for error creation and handling
3. **Reactive UI**: BLoC pattern for unidirectional data flow
4. **Dependency Injection**: Service locator pattern for maintainable dependencies
5. **Modular Navigation**: Route management through GoRouter for scalability

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (Latest stable version)
- Dart SDK (Latest stable version)
- Android Studio / VS Code with Flutter plugins

### Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/car-challenge.git
```

2. Navigate to project directory and install dependencies:
```bash
cd car-challenge
flutter pub get
```

3. Run the application:
```bash
flutter run
```

## 📚 Code Examples

### Dependency Injection Setup

```dart
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
```

### Error Handling

```dart
class SearchRemoteDataSourceImpl implements SearchRemoteDataSource {
  final BaseClient httpClient;

  SearchRemoteDataSourceImpl({required this.httpClient});

  @override
  Future<Either<Failure, SearchResult>> search(String userId,
      {String? vin, String? externalId}) async {
    // Implementation with comprehensive error handling
    try {
      final response = await httpClient.get(
        Uri.https('anyUrl', '/vehicle'),
        headers: headers,
      );

      switch (response.statusCode) {
        case 200:
          // Success handling
        case 300:
          // Multiple choices handling
        default:
          // Error handling
      }
    } on TimeoutException {
      return Left(FailureFactory.networkFailure('Request timed out'));
    } on ClientException catch (e) {
      return Left(FailureFactory.authenticationFailure(
          'Authentication error: ${e.message}'));
    } on FormatException {
      return Left(
          FailureFactory.deserializationFailure('Invalid response format'));
    } catch (e) {
      return Left(FailureFactory.unknownFailure(e));
    }
  }
}
```

## 🌟 Challenge Achievements

This implementation fulfills all the requirements of the CarOnSale challenge:

✅ **Step 1**: User identification with local persistence  
✅ **Step 2**: VIN search with comprehensive error handling  
✅ **Step 3**: Multiple vehicle selection with similarity ranking  
✅ **Step 4**: Data caching and persistence  
✅ **Step 5**: Rich auction data display with visual feedback  

## 📝 Notes

- This project uses the factory pattern extensively for creating domain objects
- Error handling has been implemented with user-friendly messages
- The UI is responsive and provides appropriate feedback for all operations
- All code follows SOLID principles and Clean Architecture guidelines

## 📃 License

This project is licensed under the MIT License - see the LICENSE file for details.