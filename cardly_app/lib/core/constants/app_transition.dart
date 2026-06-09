import 'package:flutter/material.dart';

enum AppTransitionType {
  fade,
  slideFromRight,
  slideFromBottom,
  fadeSlideFromRight,
  fadeSlideFromBottom,
}

class AppTransition {
  static const Duration fast = Duration(milliseconds: 200);
  static const Duration normal = Duration(milliseconds: 400);
  static const Duration slow = Duration(milliseconds: 600);
  static const Curve defaultCurve = Curves.easeOutCubic;
  static Widget Function(Widget child, Animation<double> animation) fade() {
    return (child, animation) =>
        FadeTransition(opacity: animation, child: child);
  }

  static Widget Function(Widget child, Animation<double> animation)
  slideFromRight() {
    return (child, animation) => SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0.3, 0),
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: animation, curve: defaultCurve)),
      child: child,
    );
  }

  static Widget Function(Widget child, Animation<double> animation)
  slideFromBottom() {
    return (child, animation) => SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 0.3),
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: animation, curve: defaultCurve)),
      child: child,
    );
  }

  static Widget Function(Widget child, Animation<double> animation)
  fadeSlideFromRight() {
    return (child, animation) => ClipRect(
      child: FadeTransition(
        opacity: animation,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.3, 0),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: animation, curve: defaultCurve)),
          child: child,
        ),
      ),
    );
  }

  static Widget Function(Widget child, Animation<double> animation)
  fadeSlideFromBottom() {
    return (child, animation) => FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.3),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: animation, curve: defaultCurve)),
        child: child,
      ),
    );
  }

  static Widget Function(Widget child, Animation<double> animation) builder(
    AppTransitionType type,
  ) {
    switch (type) {
      case AppTransitionType.fade:
        return fade();
      case AppTransitionType.slideFromRight:
        return slideFromRight();
      case AppTransitionType.slideFromBottom:
        return slideFromBottom();
      case AppTransitionType.fadeSlideFromRight:
        return fadeSlideFromRight();
      case AppTransitionType.fadeSlideFromBottom:
        return fadeSlideFromBottom();
    }
  }
}
