abstract class AppNavigator {
  Future<T?> push<T extends Object?>(String path, {Object? extra});
  Future<T?> pushReplacement<T extends Object?>(String path, {Object? extra});
  void pop<T extends Object?>({T? result});
  void go(String path, {Object? extra});
}
