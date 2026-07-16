import 'dart:async';

import 'package:get_it/get_it.dart';

class IoD {
  static IoD? _instance;

  IoD._();

  static IoD get instance {
    return _instance ??= IoD._();
  }

  final GetIt getIt = GetIt.instance;

  void registerSingleton<T extends Object>(T instance) {
    getIt.registerSingleton<T>(instance);
  }

  void registerFactory<T extends Object>(T Function() factory) {
    getIt.registerFactory<T>(factory);
  }

  void registerLazySingleton<T extends Object>(T Function() factory) {
    getIt.registerLazySingleton<T>(factory);
  }

  Future<void> reset({bool dispose = true}) async {
    await getIt.reset(dispose: dispose);
  }

  Future<dynamic> resetLazySingleton<T extends Object>() async {
    return getIt.resetLazySingleton<T>();
  }

  T get<T extends Object>() {
    return getIt.get<T>();
  }

  bool isRegistered<T extends Object>() {
    return getIt.isRegistered<T>();
  }

  FutureOr<dynamic> unregister<T extends Object>() async {
    return getIt.unregister<T>();
  }
}
