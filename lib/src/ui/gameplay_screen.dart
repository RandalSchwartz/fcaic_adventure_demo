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
    // Start a dummy adventure for UI development
    _adventureService.startAdventure('A magical forest');
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
          _adventureService.storyHistory.watch(context).lastOrNull?.title ??
              'Adventure Forge',
        ),
      ),
      body: Watch((context) {
        if (_adventureService.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (_adventureService.errorMessage.value != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _adventureService.errorMessage.value!,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    final lastChoice =
                        _adventureService.storyHistory.value.lastOrNull;
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
          );
        }

        final story = _adventureService.storyHistory.value.lastOrNull;
        if (story == null) {
          return const Center(child: Text('No story yet.'));
        }

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
                story.story,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 24),
              ...story.choices.map(
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
      }),
    );
  }
}
