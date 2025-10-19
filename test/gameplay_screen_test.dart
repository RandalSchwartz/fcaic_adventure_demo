import 'package:adventure_demo/src/models/story_step.dart';
import 'package:adventure_demo/src/service_locator.dart';
import 'package:adventure_demo/src/services/adventure_service.dart';
import 'package:adventure_demo/src/ui/gameplay_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:signals/signals.dart';

class MockAdventureService extends Mock implements AdventureService {}

void main() {
  late MockAdventureService mockAdventureService;

  setUp(() {
    mockAdventureService = MockAdventureService();
    when(() => mockAdventureService.storyHistory)
        .thenReturn(asyncSignal(AsyncState.data([])));
    when(() => mockAdventureService.currentImage).thenReturn(signal(null));
    when(() => mockAdventureService.startAdventure(any()))
        .thenAnswer((_) async {});
    ServiceLocator().register<AdventureService>(mockAdventureService);
  });

  testWidgets('GameplayScreen displays story and choices',
      (WidgetTester tester) async {
    when(() => mockAdventureService.storyHistory)
        .thenReturn(asyncSignal(AsyncState.data([
      const StoryStep(
        title: 'Test Title',
        story: 'Test Story',
        imagePrompt: 'Test Image Prompt',
        choices: ['Choice 1', 'Choice 2'],
      )
    ])));

    await tester.pumpWidget(const MaterialApp(
      home: GameplayScreen(),
    ));

    await tester.pumpAndSettle();

    expect(find.text('Test Title'), findsOneWidget);
    expect(find.text('Test Story'), findsOneWidget);
    expect(find.text('Choice 1'), findsOneWidget);
    expect(find.text('Choice 2'), findsOneWidget);
  });

  testWidgets('GameplayScreen shows error message', (WidgetTester tester) async {
    when(() => mockAdventureService.storyHistory)
        .thenReturn(asyncSignal(AsyncState.error('Test Error', null)));

    await tester.pumpWidget(const MaterialApp(
      home: GameplayScreen(),
    ));

    await tester.pumpAndSettle();

    expect(find.text('Test Error'), findsOneWidget);
    expect(find.text('Retry'), findsOneWidget);
  });
}
