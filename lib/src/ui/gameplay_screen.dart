import 'package:adventure_demo/src/service_locator.dart';
import 'package:adventure_demo/src/services/adventure_service.dart';
import 'package:flutter/material.dart';
import 'package:signals_flutter/signals_flutter.dart';

class GameplayScreen extends StatefulWidget {
  const GameplayScreen({super.key});

  @override
  State<GameplayScreen> createState() => _GameplayScreenState();
}

class _GameplayScreenState extends State<GameplayScreen> {
  final AdventureService _adventureService =
      ServiceLocator().get<AdventureService>();
  final _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (_adventureService.storyHistory.value.value?.isEmpty ?? true) {
      _adventureService.startAdventure('A magical forest');
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _adventureService.storyHistory.watch(context).value?.lastOrNull?.title ??
              'Adventure Forge',
        ),
      ),
      body: Watch((context) {
        final storyAsync = _adventureService.storyHistory.watch(context);

        return storyAsync.map(
          data: (story) {
            if (story.isEmpty) {
              return const Center(child: Text('No story yet.'));
            }
            final currentStep = story.last;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // if (_adventureService.currentImage.value != null)
                  //   Image.memory(
                  //     _adventureService.currentImage.value!,
                  //     height: 200,
                  //     fit: BoxFit.cover,
                  //   ),
                  const SizedBox(height: 16),
                  Text(
                    currentStep.story,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 24),
                  ...currentStep.choices.map(
                    (choice) => ElevatedButton(
                      onPressed: () => _adventureService.makeChoice(choice),
                      child: Text(choice),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _textController,
                    decoration: const InputDecoration(
                      hintText: 'Or type your own action...',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (value) {
                      if (value.isNotEmpty) {
                        _adventureService.makeChoice(value);
                        _textController.clear();
                      }
                    },
                  ),
                ],
              ),
            );
          },
          error: (error, stackTrace) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  error.toString(),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    final lastChoice =
                        _adventureService.storyHistory.value.requireValue.lastOrNull;
                    if (lastChoice != null) {
                      // This is a simplification. A real app would need
                      // to know the last *action*, not the last state.
                      // For now, we'll just retry the last theme.
                      _adventureService.startAdventure('A magical forest');
                    }
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
        );
      }),
    );
  }
}
