class ServiceLocator {
  ServiceLocator._();

  static final _instance = ServiceLocator._();
  factory ServiceLocator() => _instance;

  final _services = <Type, dynamic>{};

  void register<T>(T service) {
    _services[T] = service;
  }

  T get<T>() {
    final service = _services[T];
    if (service == null) {
      throw Exception('Service of type $T not found.');
    }
    return service as T;
  }
}
