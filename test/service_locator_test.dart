import 'package:adventure_demo/src/service_locator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ServiceLocator', () {
    test('register and get a service', () {
      final serviceLocator = ServiceLocator();
      serviceLocator.register<String>('test service');
      expect(serviceLocator.get<String>(), 'test service');
    });

    test('throws an exception if service not found', () {
      final serviceLocator = ServiceLocator();
      expect(() => serviceLocator.get<int>(), throwsException);
    });
  });
}
