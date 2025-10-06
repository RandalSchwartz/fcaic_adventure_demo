import 'dart:typed_data';

import 'package:adventure_demo/src/models/story_step.dart';

abstract class AIProvider {
  Future<StoryStep> generateStoryStep(List<StoryStep> history, String choice);
  Future<Uint8List> generateImage(String prompt);
}
