import 'package:flutter/cupertino.dart';

extension StringNullableX on String? {
  bool get isNullOrTrimEmpty => this == null || this!.trim().isEmpty;
}

extension TextEditingControllerX on TextEditingController {
  String get trimmedText => text.trim();
}
