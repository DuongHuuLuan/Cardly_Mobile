import 'package:flutter/material.dart';

extension WidgetPaddingX on Widget {
  Widget padding(EdgeInsetsGeometry padding) =>
      Padding(padding: padding, child: this);

  Widget paddingAll(double v) =>
      Padding(padding: EdgeInsets.all(v), child: this);

  Widget paddingHorizontal(double v) => Padding(
    padding: EdgeInsets.symmetric(horizontal: v),
    child: this,
  );

  Widget paddingVertical(double v) => Padding(
    padding: EdgeInsets.symmetric(vertical: v),
    child: this,
  );

  Widget paddingOnly({
    double left = 0,
    double top = 0,
    double right = 0,
    double bottom = 0,
  }) => Padding(
    padding: EdgeInsets.only(
      left: left,
      top: top,
      right: right,
      bottom: bottom,
    ),
    child: this,
  );

  Widget paddingLeft(double v) => Padding(
    padding: EdgeInsets.only(left: v),
    child: this,
  );

  Widget paddingRight(double v) => Padding(
    padding: EdgeInsets.only(right: v),
    child: this,
  );

  Widget paddingTop(double v) => Padding(
    padding: EdgeInsets.only(top: v),
    child: this,
  );

  Widget paddingBottom(double v) => Padding(
    padding: EdgeInsets.only(bottom: v),
    child: this,
  );
}
