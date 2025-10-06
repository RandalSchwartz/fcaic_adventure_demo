import 'package:adventure_demo/src/service_locator.dart';
import 'package:adventure_demo/src/services/adventure_service.dart';
import 'package:adventure_demo/src/ui/gameplay_screen.dart';
import 'package:flutter/material.dart';
import 'package:signals_flutter/signals_flutter.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  final _textController = TextEditingController();
  final _adventureService = ServiceLocator().get<AdventureService>();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adventure Forge'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'What is your adventure about?',
              style: TextStyle(fontSize: 24),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _textController,
              decoration: const InputDecoration(
                hintText: 'e.g., A haunted house, a space pirate adventure...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            Watch((context) {
              return ElevatedButton(
                onPressed: _adventureService.isLoading.value
                    ? null
                    : () {
                        _adventureService
                            .startAdventure(_textController.text)
                            .then((_) {
                          if (!context.mounted) return;
                          if (_adventureService.errorMessage.value == null) {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const GameplayScreen(),
                              ),
                            );
                          }
                        });
                      },
                child: _adventureService.isLoading.value
                    ? const CircularProgressIndicator()
                    : const Text('Start Adventure'),
              );
            }),
          ],
        ),
      ),
    );
  }
}
