import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:ui_kit/ui_kit.dart';
import 'package:user_identification/src/presentation/pages/identification_form.dart';

import 'identification_form_test.mocks.dart';

@GenerateNiceMocks([MockSpec<NotificationService>()])
void main() {
  late MockNotificationService mockNotificationService;

  setUp(() {
    mockNotificationService = MockNotificationService();
  });

  Widget buildTestableWidget({
    required Function(String) onSubmit,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: IdentificationForm(
          notificationService: mockNotificationService,
          onSubmit: onSubmit,
        ),
      ),
    );
  }

  testWidgets('should display form fields', (WidgetTester tester) async {
    // Given
    // ignore: unused_local_variable
    bool submitCalled = false;

    // When
    await tester.pumpWidget(buildTestableWidget(
      onSubmit: (_) => submitCalled = true,
    ));

    // Then
    expect(find.byType(TextField), findsOneWidget);
    expect(find.text('Continue'), findsOneWidget);
  });

  testWidgets('should call onSubmit when text entered and button pressed',
      (WidgetTester tester) async {
    // Given
    String? submittedUserId;

    // When
    await tester.pumpWidget(buildTestableWidget(
      onSubmit: (userId) => submittedUserId = userId,
    ));

    // Enter text and submit form
    await tester.enterText(find.byType(TextField), 'test-user-id');
    await tester.tap(find.text('Continue'));
    await tester.pump();

    // Then
    expect(submittedUserId, equals('test-user-id'));
  });

  testWidgets(
      'should call onSubmit when text entered and keyboard done pressed',
      (WidgetTester tester) async {
    // Given
    String? submittedUserId;

    // When
    await tester.pumpWidget(buildTestableWidget(
      onSubmit: (userId) => submittedUserId = userId,
    ));

    // Enter text and submit via keyboard action
    await tester.enterText(find.byType(TextField), 'test-user-id');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();

    // Then
    expect(submittedUserId, equals('test-user-id'));
  });

  testWidgets('should show notification when trying to submit empty form',
      (WidgetTester tester) async {
    // Given
    bool submitCalled = false;

    // When
    await tester.pumpWidget(buildTestableWidget(
      onSubmit: (_) => submitCalled = true,
    ));

    // Submit form without entering text
    await tester.tap(find.text('Continue'));
    await tester.pump();

    // Then
    expect(submitCalled, isFalse);
    verify(mockNotificationService.showMessage(
      message: 'Please enter a User ID',
      type: NotificationType.error,
    )).called(1);
  });
}
