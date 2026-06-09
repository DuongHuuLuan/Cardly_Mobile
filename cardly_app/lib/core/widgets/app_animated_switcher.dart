import 'package:cardly_app/core/constants/app_transition.dart';
import 'package:flutter/material.dart';

class AppAnimatedSwitcher extends StatelessWidget {
  final Widget child;
  final AppTransitionType transitionType;
  final Duration duration;
  final Curve curve;
  const AppAnimatedSwitcher({
    super.key,
    required this.child,
    this.transitionType = AppTransitionType.fadeSlideFromRight,
    this.duration = AppTransition.normal,
    this.curve = AppTransition.defaultCurve,
  });
  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: duration,
      switchInCurve: Curves.easeOut,
      switchOutCurve: Curves.easeIn,
      transitionBuilder: _buildTransition,
      child: child,
    );
  }

  Widget _buildTransition(Widget child, Animation<double> animation) {
    final builder = AppTransition.builder(transitionType);
    return builder(child, animation);
  }
}
