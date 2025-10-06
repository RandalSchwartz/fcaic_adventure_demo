import 'package:adventure_demo/src/models/story_step.dart';
import 'package:adventure_demo/src/services/gemini_ai_provider.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('GeminiAIProvider', () {
    test('generateStoryStep returns a valid StoryStep', () async {
      final provider = GeminiAIProvider();
      final storyStep = await provider.generateStoryStep([], 'test');
      expect(storyStep, isA<StoryStep>());
      expect(storyStep.title, isNotEmpty);
      expect(storyStep.story, isNotEmpty);
      expect(storyStep.imagePrompt, isNotEmpty);
      expect(storyStep.choices, isNotEmpty);
    });
  });
}
