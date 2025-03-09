// test/presentation/pages/search_factory_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:ui_kit/ui_kit.dart';

import 'package:vehicle_selection/src/presentation/cubit/search_cubit.dart';
import 'package:vehicle_selection/src/presentation/pages/factory/search_state_widget_factory.dart';
import 'package:vehicle_selection/src/presentation/pages/search/widgets/vehicle_choice_view.dart';
import 'package:vehicle_selection/src/presentation/pages/search/widgets/vin_input_form.dart';
import 'package:vehicle_selection/vehicle_search.dart';

import 'search_factory_test.mocks.dart';

// Create a manual mock class for SearchCubit
@GenerateMocks([SearchCubit])
void main() {
  late MockSearchCubit mockCubit;

  setUp(() {
    mockCubit = MockSearchCubit();
  });

  testWidgets('returns VinInputForm when status is initial',
      (WidgetTester tester) async {
    // Use an actual SearchState instance rather than a mock
    const state = SearchState(status: SearchStatus.initial);

    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<SearchCubit>.value(
          value: mockCubit,
          child: Builder(
            builder: (context) => Scaffold(
              body: SearchStateWidgetFactory.build(context, state),
            ),
          ),
        ),
      ),
    );

    // Assert
    expect(find.byType(VinInputForm), findsOneWidget);
  });

  testWidgets('returns LoadingWidget when status is loading',
      (WidgetTester tester) async {
    // Use an actual SearchState instance
    const state = SearchState(status: SearchStatus.loading);

    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<SearchCubit>.value(
          value: mockCubit,
          child: Builder(
            builder: (context) => Scaffold(
              body: SearchStateWidgetFactory.build(context, state),
            ),
          ),
        ),
      ),
    );

    // Assert
    expect(find.byType(LoadingWidget), findsOneWidget);
  });

  testWidgets('returns ErrorDisplayWidget when status is error',
      (WidgetTester tester) async {
    // Use an actual SearchState instance
    const errorMessage = 'Test error';
    const state =
        SearchState(status: SearchStatus.error, errorMessage: errorMessage);

    // Setup the retry action
    when(mockCubit.retry()).thenReturn(null);

    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<SearchCubit>.value(
          value: mockCubit,
          child: Builder(
            builder: (context) => Scaffold(
              body: SearchStateWidgetFactory.build(context, state),
            ),
          ),
        ),
      ),
    );

    // Assert
    expect(find.byType(ErrorDisplayWidget), findsOneWidget);
    expect(find.text(errorMessage), findsOneWidget);
    expect(find.text('Retry'), findsOneWidget);
   
  });

  testWidgets('returns VehicleCarChoiceView when status is multipleChoices',
      (WidgetTester tester) async {
    // Use an actual SearchState instance with real choices
    final choices = [
      const VehicleChoice(
        make: 'Toyota',
        model: 'GT 86',
        containerName: 'Test Container',
        similarity: 80,
        externalId: 'test-id',
      ),
    ];

    final state = SearchState(
      status: SearchStatus.multipleChoices,
      choices: choices,
    );

    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<SearchCubit>.value(
          value: mockCubit,
          child: Builder(
            builder: (context) => Scaffold(
              body: SearchStateWidgetFactory.build(context, state),
            ),
          ),
        ),
      ),
    );

    // Assert
    expect(find.byType(VehicleCarChoiceView), findsOneWidget);
  });

  testWidgets('returns SizedBox when status is selected',
      (WidgetTester tester) async {
    // Use an actual SearchState instance
    const state = SearchState(
      status: SearchStatus.selected,
      selectedExternalId: 'test-id',
      auctionId: 'auction-id',
    );

    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<SearchCubit>.value(
          value: mockCubit,
          child: Builder(
            builder: (context) => Scaffold(
              body: SearchStateWidgetFactory.build(context, state),
            ),
          ),
        ),
      ),
    );

    // Assert
    // Since SizedBox is commonly used, we verify indirectly by checking
    // the absence of other widgets
    expect(find.byType(VinInputForm), findsNothing);
    expect(find.byType(LoadingWidget), findsNothing);
    expect(find.byType(ErrorDisplayWidget), findsNothing);
    expect(find.byType(VehicleCarChoiceView), findsNothing);
  });
}
