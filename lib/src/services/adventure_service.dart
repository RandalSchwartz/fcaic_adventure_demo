import 'dart:typed_data';

import 'package:adventure_demo/src/models/story_step.dart';
import 'package:adventure_demo/src/service_locator.dart';
import 'package:adventure_demo/src/services/ai_provider.dart';
import 'package:signals/signals.dart';

class AdventureService {
  AdventureService() : _aiProvider = ServiceLocator().get<AIProvider>();

  final AIProvider _aiProvider;

  final storyHistory = asyncSignal<List<StoryStep>>(AsyncState.data([]));
  final currentImage = signal<Uint8List?>(null);

  Future<void> startAdventure(String theme) async {
    storyHistory.value = const AsyncLoading();
    try {
      final initialStep = await _aiProvider.generateStoryStep([], theme);
      // final image = await _aiProvider.generateImage(initialStep.imagePrompt);
      storyHistory.value = AsyncData([initialStep]);
      // currentImage.value = image;
    } catch (e, s) {
      storyHistory.value = AsyncError(e, s);
    }
  }

  Future<void> makeChoice(String choice) async {
    final currentStory = storyHistory.value.requireValue;
    storyHistory.value = const AsyncLoading();
    try {
      final nextStep =
          await _aiProvider.generateStoryStep(currentStory, choice);
      // final image = await _aiProvider.generateImage(nextStep.imagePrompt);
      storyHistory.value = AsyncData([...currentStory, nextStep]);
      // currentImage.value = image;
    } catch (e, s) {
      storyHistory.value = AsyncError(e, s);
    }
  }
}
