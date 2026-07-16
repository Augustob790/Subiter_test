import 'package:go_router/go_router.dart';
import 'app_navigator.dart';

class CoreNavigator extends AppNavigator {
  final GoRouter _router;

  CoreNavigator(this._router);

  @override
  Future<T?> push<T extends Object?>(String path, {Object? extra}) {
    return _router.push<T>(path, extra: extra);
  }

  @override
  Future<T?> pushReplacement<T extends Object?>(String path, {Object? extra}) {
    return _router.pushReplacement<T>(path, extra: extra);
  }

  @override
  void pop<T extends Object?>({T? result}) {
    if (_router.canPop()) {
      _router.pop(result);
    } else {
      _router.go('/');
    }
  }

  @override
  void go(String path, {Object? extra}) {
    return _router.go(path, extra: extra);
  }
}
