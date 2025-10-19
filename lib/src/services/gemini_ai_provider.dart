import 'dart:convert';

import 'package:adventure_demo/api_key.dart';
import 'package:adventure_demo/src/models/story_step.dart';
import 'package:adventure_demo/src/services/ai_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiAIProvider implements AIProvider {
  GeminiAIProvider({GenerativeModel? storyModel})
      : _storyModel = storyModel ??
            GenerativeModel(
              model: 'gemini-2.5-flash',
              apiKey: geminiApiKey,
              generationConfig: GenerationConfig(
                responseMimeType: 'application/json',
              ),
            );

  final GenerativeModel _storyModel;
  // final GenerativeModel _imageModel;

  @override
  Future<StoryStep> generateStoryStep(
    List<StoryStep> history,
    String choice,
  ) async {
    final prompt = _buildStoryPrompt(history, choice);
    try {
      final response = await _storyModel.generateContent([
        Content.text(prompt),
      ]);
      final responseText = response.text;

      debugPrint('Gemini API Raw Response: $responseText');

      if (responseText == null) {
        if (response.promptFeedback?.blockReason != null) {
          final reason = response.promptFeedback!.blockReason;
          throw Exception(
            'The story prompt was blocked for safety reasons: $reason. Please try a different theme.',
          );
        }
        throw Exception(
          'Received an empty response from the AI. Please try again.',
        );
      }

      final json = jsonDecode(responseText);
      return StoryStep.fromJson(json);
    } catch (e) {
      debugPrint('Error generating story step: $e');
      throw Exception(
        'Failed to generate the next part of the story. Please try again.',
      );
    }
  }

  // @override
  // Future<Uint8List> generateImage(String prompt) async {
  //   try {
  //     final response = await _imageModel.generateContent([
  //       Content.text(
  //         'Generate an image in a consistent, painterly fantasy style. $prompt',
  //       ),
  //     ]);

  //     debugPrint('Gemini Image API Raw Response: ${response.text}');

  //     if (response.promptFeedback?.blockReason != null) {
  //       final reason = response.promptFeedback!.blockReason;
  //       throw Exception(
  //         'The image prompt was blocked for safety reasons: $reason.',
  //       );
  //     }

  //     // The vision model returns the image bytes in the first part of the response.
  //     if (response.candidates.isNotEmpty &&
  //         response.candidates.first.content.parts.isNotEmpty &&
  //         response.candidates.first.content.parts.first is DataPart) {
  //       return (response.candidates.first.content.parts.first as DataPart)
  //           .bytes;
  //     }
  //     throw Exception('Image generation response did not contain image data.');
  //   } catch (e) {
  //     debugPrint('Error generating image: $e');
  //     throw Exception('Failed to create the scene\'s image. Please try again.');
  //   }
  // }

  String _buildStoryPrompt(List<StoryStep> history, String choice) {
    const formatInstructions = 'Respond with a JSON object with the following keys: "title" (String), "story" (String), "image_prompt" (String), and "choices" (List<String>).';

    if (history.isEmpty) {
      return 'You are an expert storyteller. Create the beginning of a "Choose Your Own Adventure" story based on this theme: "$choice". $formatInstructions';
    }

    final historyString = history
        .map(
          (step) =>
              'Title: ${step.title}\nStory: ${step.story}\nChoice Taken: ${step.choices.first}',
        ) // This is a simplification
        .join('\n\n');

    return 'You are an expert storyteller continuing a "Choose Your Own Adventure" story. Here is the story so far:\n$historyString\n\nThe user has just chosen to: "$choice".\n\nContinue the story. $formatInstructions';
  }
}
