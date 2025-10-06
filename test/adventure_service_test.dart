import 'package:adventure_demo/src/service_locator.dart';
import 'package:adventure_demo/src/services/adventure_service.dart';
import 'package:adventure_demo/src/services/ai_provider.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fake_ai_provider.dart';

void main() {
  late AdventureService adventureService;

  setUp(() {
    ServiceLocator().register<AIProvider>(FakeAIProvider());
    adventureService = AdventureService();
  });

  group('AdventureService', () {
    test('startAdventure success', () async {
      await adventureService.startAdventure('test theme');

      expect(adventureService.storyHistory.value.length, 1);
      expect(adventureService.currentImage.value, isNotNull);
      expect(adventureService.errorMessage.value, isNull);
      expect(adventureService.isLoading.value, isFalse);
    });
  });
}
