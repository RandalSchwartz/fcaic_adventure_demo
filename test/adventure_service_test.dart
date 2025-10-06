import 'dart:typed_data';

import 'package:adventure_demo/src/models/story_step.dart';
import 'package:adventure_demo/src/service_locator.dart';
import 'package:adventure_demo/src/services/adventure_service.dart';
import 'package:adventure_demo/src/services/ai_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAIProvider extends Mock implements AIProvider {}

void main() {
  late AdventureService adventureService;
  late MockAIProvider mockAIProvider;

  setUp(() {
    mockAIProvider = MockAIProvider();
    ServiceLocator().register<AIProvider>(mockAIProvider);
    adventureService = AdventureService();
  });

  group('AdventureService', () {
    const testStoryStep = StoryStep(
      title: 'Test Title',
      story: 'Test Story',
      imagePrompt: 'Test Image Prompt',
      choices: ['Choice 1', 'Choice 2'],
    );

    test('startAdventure success', () async {
      when(() => mockAIProvider.generateStoryStep(any(), any()))
          .thenAnswer((_) async => testStoryStep);
      when(() => mockAIProvider.generateImage(any()))
          .thenAnswer((_) async => Uint8List(0));

      await adventureService.startAdventure('test theme');

      expect(adventureService.storyHistory.value.length, 1);
      expect(adventureService.storyHistory.value.first, testStoryStep);
      expect(adventureService.currentImage.value, isNotNull);
      expect(adventureService.errorMessage.value, isNull);
      expect(adventureService.isLoading.value, isFalse);
    });

    test('startAdventure failure', () async {
      when(() => mockAIProvider.generateStoryStep(any(), any()))
          .thenThrow(Exception('Test Error'));

      await adventureService.startAdventure('test theme');

      expect(adventureService.storyHistory.value.isEmpty, isTrue);
      expect(adventureService.currentImage.value, isNull);
      expect(adventureService.errorMessage.value, isNotNull);
      expect(adventureService.isLoading.value, isFalse);
    });
  });
}
