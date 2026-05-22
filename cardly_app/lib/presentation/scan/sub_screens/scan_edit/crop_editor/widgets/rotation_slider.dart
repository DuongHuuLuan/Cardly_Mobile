import 'package:flutter/material.dart';

class RotationSlider extends StatelessWidget {
  final double value;
  final ValueChanged<double> onChanged;

  const RotationSlider({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          const Icon(Icons.rotate_left, size: 20, color: Colors.grey),
          Expanded(
            child: Slider(
              value: value,
              min: -45,
              max: 45,
              divisions: 180,
              label: '${value.round()}\u00B0',
              onChanged: onChanged,
            ),
          ),
          const Icon(Icons.rotate_right, size: 20, color: Colors.grey),
          SizedBox(
            width: 40,
            child: Text(
              '${value.round()}\u00B0',
              style: const TextStyle(fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
