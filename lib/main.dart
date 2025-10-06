import 'package:adventure_demo/src/service_locator.dart';
import 'package:adventure_demo/src/services/adventure_service.dart';
import 'package:adventure_demo/src/services/ai_provider.dart';
import 'package:adventure_demo/src/services/gemini_ai_provider.dart';
import 'src/ui/start_screen.dart';
import 'package:flutter/material.dart';

void main() {
  ServiceLocator().register<AIProvider>(GeminiAIProvider());
  ServiceLocator().register<AdventureService>(AdventureService());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Adventure Forge',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const StartScreen(),
    );
  }
}
