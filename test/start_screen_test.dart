import 'package:adventure_demo/src/service_locator.dart';
import 'package:adventure_demo/src/services/adventure_service.dart';
import 'package:adventure_demo/src/ui/start_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:signals/signals.dart';

class MockAdventureService extends Mock implements AdventureService {}

void main() {
  late MockAdventureService mockAdventureService;

  setUp(() {
    mockAdventureService = MockAdventureService();
    when(() => mockAdventureService.isLoading).thenReturn(signal(false));
    when(() => mockAdventureService.errorMessage).thenReturn(signal(null));
    when(() => mockAdventureService.startAdventure(any()))
        .thenAnswer((_) async {});
    ServiceLocator().register<AdventureService>(mockAdventureService);
  });

  testWidgets('StartScreen has a title, text field, and button',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: StartScreen()));

    expect(find.text('Adventure Forge'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget);
  });

  testWidgets('StartScreen shows loading indicator',
      (WidgetTester tester) async {
    when(() => mockAdventureService.isLoading).thenReturn(signal(true));

    await tester.pumpWidget(const MaterialApp(home: StartScreen()));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
