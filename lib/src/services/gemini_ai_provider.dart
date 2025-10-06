import 'dart:typed_data';

import 'package:adventure_demo/src/models/story_step.dart';
import 'package:adventure_demo/src/services/ai_provider.dart';

class GeminiAIProvider implements AIProvider {
  GeminiAIProvider();

  @override
  Future<StoryStep> generateStoryStep(
    List<StoryStep> history,
    String choice,
  ) async {
    // TODO: Implement actual API call with history and error handling.
    // For now, returning a dummy response.
    await Future.delayed(const Duration(seconds: 1));
    final dummyJson = {
      "title": "A New Beginning",
      "story":
          "You stand at a crossroads, the path splitting in two. To your left, a dark and ominous forest. To your right, a bright and sunny meadow.",
      "imagePrompt":
          "A fantasy adventurer standing at a crossroads, with a dark forest on one side and a sunny meadow on the other.",
      "choices": ["Enter the forest", "Walk into the meadow", "Sit down and rest"]
    };
    return StoryStep.fromJson(dummyJson);
  }

  @override
  Future<Uint8List> generateImage(String prompt) async {
    // TODO: Implement actual API call with error handling.
    // For now, returning an empty image.
    await Future.delayed(const Duration(seconds: 1));
    return Uint8List(0);
  }
}
