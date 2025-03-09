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
import 'package:vehicle_selection/src/domain/entities/vehicle_choice.dart';

import 'search_factory_test.mocks.dart';

@GenerateMocks([SearchCubit])
void main() {
  late MockSearchCubit mockCubit;

  setUp(() {
    mockCubit = MockSearchCubit();
  });

  testWidgets('returns VinInputForm when status is initial',
      (WidgetTester tester) async {
    // Use an actual SearchState instance
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
    when(mockCubit.selectVehicle(any)).thenAnswer((_) => Future.value());

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

    // Find error widget and associated text
    final errorWidget = find.byType(ErrorDisplayWidget);
    expect(errorWidget, findsOneWidget);

    // Verify error message is displayed
    expect(find.text(errorMessage), findsOneWidget);

    // Find action button in ErrorDisplayWidget and tap it
    // Note: This approach doesn't rely on specific text or button type
    await tester.tap(errorWidget);
    await tester.pump();
  });

  testWidgets('returns VehicleCarChoiceView when status is multipleChoices',
      (WidgetTester tester) async {
    // Use an actual SearchState instance with choices
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

    // Setup for vehicle selection
    when(mockCubit.selectVehicle(any)).thenAnswer((_) => Future.value());

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

    // Find the vehicle choice view widget
    final choiceView = find.byType(VehicleCarChoiceView);
    expect(choiceView, findsOneWidget);
  });

  testWidgets('returns empty SizedBox when status is loaded',
      (WidgetTester tester) async {
    // Use an actual SearchState instance
    const state = SearchState(status: SearchStatus.loaded);

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

    // Assert - SizedBox is used when loaded, which doesn't have a specific finder
    // We verify indirectly by checking that none of the other widgets are present
    expect(find.byType(VinInputForm), findsNothing);
    expect(find.byType(LoadingWidget), findsNothing);
    expect(find.byType(ErrorDisplayWidget), findsNothing);
    expect(find.byType(VehicleCarChoiceView), findsNothing);
  });
}
