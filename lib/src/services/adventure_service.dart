import 'dart:typed_data';

import 'package:adventure_demo/src/models/story_step.dart';
import 'package:adventure_demo/src/service_locator.dart';
import 'package:adventure_demo/src/services/ai_provider.dart';
import 'package:signals/signals.dart';

class AdventureService {
  AdventureService() : _aiProvider = ServiceLocator().get<AIProvider>();

  final AIProvider _aiProvider;

  final storyHistory = signal<List<StoryStep>>([]);
  final currentImage = signal<Uint8List?>(null);
  final isLoading = signal<bool>(false);
  final errorMessage = signal<String?>(null);

  Future<void> startAdventure(String theme) async {
    isLoading.value = true;
    errorMessage.value = null;
    try {
      final initialStep = await _aiProvider.generateStoryStep([], theme);
      final image = await _aiProvider.generateImage(initialStep.imagePrompt);
      storyHistory.value = [initialStep];
      currentImage.value = image;
    } catch (e) {
      errorMessage.value = 'Failed to start adventure: $e';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> makeChoice(String choice) async {
    isLoading.value = true;
    errorMessage.value = null;
    try {
      final nextStep =
          await _aiProvider.generateStoryStep(storyHistory.value, choice);
      final image = await _aiProvider.generateImage(nextStep.imagePrompt);
      storyHistory.value = [...storyHistory.value, nextStep];
      currentImage.value = image;
    } catch (e) {
      errorMessage.value = 'Failed to make choice: $e';
    } finally {
      isLoading.value = false;
    }
  }
}
