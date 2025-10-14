import 'package:flutter/material.dart';

class MyRouter {
  static final navigatorKey = GlobalKey<NavigatorState>();

  /// Push a new screen
  static void push({required Widget screen}) {
    navigatorKey.currentState?.push(MaterialPageRoute(builder: (_) => screen));
  }

  /// Restorable push by route name
  static restorablePushNamed({required String screen, Object? arguments}) {
    return navigatorKey.currentState?.restorablePushNamed(
      screen,
      arguments: arguments,
    );
  }

  /// Check if we can pop
  static bool canPop<T extends Object?>([T? result]) {
    bool? canPop = navigatorKey.currentState?.canPop();
    return canPop == true;
  }

  /// Pop the current route
  static pop<T extends Object?>([T? result]) {
    bool? canPop = navigatorKey.currentState?.canPop();
    if (canPop != true) return;
    navigatorKey.currentState?.pop(result);
  }

  /// Pop until a specific route
  static void popUntil(RoutePredicate predicate) {
    navigatorKey.currentState?.popUntil(predicate);
  }

  /// Replace current route with new screen
  static void pushReplace({required Widget screen}) {
    navigatorKey.currentState?.pushReplacement(
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  /// Push new screen and remove all previous routes
  static void pushRemoveUntil({required Widget screen}) {
    navigatorKey.currentState?.pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => screen),
      (route) => false,
    );
  }

  /// Push by route name
  static void pushNamed<T extends Object?>(
    String routeName, {
    Object? arguments,
  }) {
    navigatorKey.currentState?.pushNamed(routeName, arguments: arguments);
  }

  /// Replace by named route
  static void pushReplacementNamed<T extends Object?, TO extends Object?>(
    String routeName, {
    TO? result,
    Object? arguments,
  }) {
    navigatorKey.currentState?.pushReplacementNamed<T, TO>(
      routeName,
      arguments: arguments,
      result: result,
    );
  }

  /// Push named and remove until predicate
  static void pushNamedAndRemoveUntil<T extends Object?>(
    String newRouteName, {
    RoutePredicate? predicate,
    Object? arguments,
  }) {
    navigatorKey.currentState?.pushNamedAndRemoveUntil(
      newRouteName,
      predicate ?? (route) => false,
      arguments: arguments,
    );
  }
}
