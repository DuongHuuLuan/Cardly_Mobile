import 'package:flutter/cupertino.dart';

extension WidgetPopScopeX on Widget {
  Widget canPop(
    bool canPop, {
    void Function(bool didPop, Object? result)? onPop,
  }) => PopScope(canPop: canPop, onPopInvokedWithResult: onPop, child: this);
}
