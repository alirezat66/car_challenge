# CarOnSale Flutter Challenge

This project is an implementation of the CarOnSale Flutter Coding Challenge, showcasing a clean, maintainable, and testable Flutter application that handles user identification, vehicle data retrieval, error handling, and data persistence.

[![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev/)
[![Clean Architecture](https://img.shields.io/badge/Clean-Architecture-success)](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
[![BLoC Pattern](https://img.shields.io/badge/BLoC-Pattern-blue)](https://bloclibrary.dev/)

## Project Overview

The application is built following Clean Architecture principles with a focus on separation of concerns, testability, and maintainability. It implements a complete workflow for vehicle identification and auction data retrieval, with robust error handling and local data caching.

## Features Implemented

### User Identification (Step 1)
- User can enter and save their unique identifier
- Persists user data locally using SharedPreferences
- Automatic login on subsequent app launches

### VIN Entry & Error Handling (Step 2)
- Form for entering Vehicle Identification Number (VIN)
- VIN validation (17 characters requirement)
- Comprehensive error handling including:
  - Network errors
  - Authentication errors
  - Server maintenance errors
  - Deserialization errors
- User-friendly error messages with recovery suggestions

### Multiple Vehicle Selection (Step 3)
- Handling of ambiguous vehicle identification (status code 300)
- Display of multiple vehicle choices
- Sorting options by similarity
- Color-coded similarity indicators

### Data Caching (Step 4)
- Persistent local storage of successful requests
- Fallback to cached data when network requests fail
- Seamless user experience during connectivity issues

### Auction Data Display (Step 5)
- Detailed view of auction data
- Display of price, model, and UUID
- Feedback indicators (positive/negative)
- Well-structured UI with cards for different data categories

## Technical Implementation

### Architecture
The project follows **Clean Architecture** principles with three main layers:
- **Domain Layer**: Contains business logic, entities and use cases
- **Data Layer**: Implements repositories and data sources
- **Presentation Layer**: Uses BLoC/Cubit for state management with UI components

### Key Technologies & Libraries
- **State Management**: flutter_bloc for predictable state management
- **Dependency Injection**: get_it for service location
- **Navigation**: go_router for declarative routing
- **HTTP Client**: http package for API requests
- **Local Storage**: shared_preferences for persisting data
- **Error Handling**: dartz for functional error handling with Either type
- **Testing**: mockito and bloc_test for comprehensive unit testing

### Design Patterns Utilized
- **Repository Pattern**: Abstracts data sources
- **Factory Pattern**: For creating object instances
- **Dependency Injection**: For loose coupling
- **Strategy Pattern**: For JSON string fixing strategies
- **Builder Pattern**: For constructing complex objects

## Project Structure

```
lib/
├── core/                       # Core functionality used across features
│   ├── client/                 # HTTP client and extensions
│   ├── constants/              # App-wide constants
│   ├── di/                     # Dependency injection
│   ├── error/                  # Error handling framework
│   ├── notification/           # Notification services
│   ├── route/                  # App routing
│   ├── theme/                  # App theming
│   ├── usecase/                # Base use case definitions
│   └── widgets/                # Shared widgets
├── features/                   # Feature modules
│   ├── user_identification/    # User identification feature
│   │   ├── data/               # Data layer
│   │   ├── domain/             # Domain layer
│   │   └── presentation/       # Presentation layer
│   └── vehicle_selection/      # Vehicle selection feature
│       ├── data/               # Data layer
│       ├── domain/             # Domain layer
│       └── presentation/       # Presentation layer
└── main.dart                   # Application entry point
```

## Error Handling Strategy

The application implements a robust error handling mechanism:

1. **Error Categorization**: Different types of errors (network, server, parsing) are categorized into failure types
2. **Factory Pattern**: A FailureFactory creates appropriate failure objects
3. **Either Type**: The dartz package's Either type is used to represent success or failure outcomes
4. **User-Friendly Messages**: Appropriate error messages with recovery options
5. **JSON Fixing**: Custom strategies to handle and fix malformed JSON responses

## Testing Strategy

The application has extensive unit tests covering:
- Domain use cases
- Data repositories
- Remote and local data sources
- Presentation logic (Cubits)
- Utility classes and extensions

## Getting Started

### Prerequisites
- Flutter SDK (2.5.0 or higher)
- Dart SDK (2.14.0 or higher)

### Installation
1. Clone this repository
2. Run `flutter pub get` to install dependencies
3. Run `flutter run` to start the application

### Running Tests
```bash
flutter test
```

## Bonus Features Implemented

- **User Data Persistence**: Automatic skipping of login on subsequent launches
- **VIN Validation**: Client-side validation of VIN format
- **Similarity Ranking**: Visual indicators for vehicle similarity
- **Comprehensive Error Handling**: Detailed error messages with recovery paths
- **Caching Strategy**: Robust implementation with fallback to cached data
- **Dark Mode Support**: Full dark theme implementation
- **Comprehensive Testing**: Extensive unit tests for all components

## Design Considerations

The application is built with several key principles in mind:

1. **Separation of Concerns**: Clean separation between data, domain, and presentation layers
2. **Testability**: All components are highly testable with clear interfaces
3. **Error Handling**: Robust error handling throughout the application
4. **User Experience**: Clean, intuitive UI with clear feedback
5. **Performance**: Efficient data handling and caching strategies

## Future Improvements

- **Offline Mode**: Enhanced offline capabilities
- **Localization**: Multi-language support
- **Analytics**: Event tracking for user actions
- **Enhanced Animations**: Smoother transitions between screens
- **Biometric Authentication**: Option for secure login

---

Created for the CarOnSale Flutter Coding Challenge.