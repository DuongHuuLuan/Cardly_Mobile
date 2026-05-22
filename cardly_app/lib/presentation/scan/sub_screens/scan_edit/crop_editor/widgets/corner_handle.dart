import 'package:flutter/material.dart';

class CornerHandle extends StatelessWidget {
  final double size;

  const CornerHandle({super.key, this.size = 44});

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: size, height: size);
  }
}
