import 'dart:typed_data';

import 'package:adventure_demo/src/models/story_step.dart';
import 'package:adventure_demo/src/services/ai_provider.dart';

class FakeAIProvider implements AIProvider {
  @override
  Future<StoryStep> generateStoryStep(List<StoryStep> history, String choice) async {
    await Future.delayed(const Duration(milliseconds: 100));
    return const StoryStep(
      title: 'Fake Title',
      story: 'Fake Story',
      imagePrompt: 'Fake Image Prompt',
      choices: ['Fake Choice 1', 'Fake Choice 2'],
    );
  }

  // @override
  Future<Uint8List> generateImage(String prompt) async {
    await Future.delayed(const Duration(milliseconds: 100));
    return Uint8List(0);
  }
}
