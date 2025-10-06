class StoryStep {
  const StoryStep({
    required this.title,
    required this.story,
    required this.imagePrompt,
    required this.choices,
  });

  final String title;
  final String story;
  final String imagePrompt;
  final List<String> choices;

  factory StoryStep.fromJson(Map<String, dynamic> json) {
    return StoryStep(
      title: json['title'] as String? ?? 'Untitled Chapter',
      story: json['story'] as String? ?? 'The story could not be generated.',
      imagePrompt: json['imagePrompt'] as String? ?? 'A blank canvas.',
      choices: (json['choices'] as List<dynamic>?)?.cast<String>() ?? ['Try again'],
    );
  }
}
