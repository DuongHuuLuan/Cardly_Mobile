import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../theme/app_color.dart';

class RippleWave extends StatefulWidget {
  final Color color;
  final double size;

  const RippleWave({super.key, this.color = AppColor.primary, this.size = 90});

  @override
  State<RippleWave> createState() => _RippleWaveState();
}

class _RippleWaveState extends State<RippleWave>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final iconBoxSize = widget.size * 0.42;

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              return CustomPaint(
                size: Size(widget.size, widget.size),
                painter: _RippleWavePainter(
                  value: _controller.value,
                  color: widget.color,
                ),
              );
            },
          ),

          Container(
            width: iconBoxSize,
            height: iconBoxSize,
            decoration: BoxDecoration(
              color: Colors.transparent,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: widget.color.withValues(alpha: 0.25),
                  blurRadius: 16,
                  spreadRadius: 2,
                ),
              ],
            ),

            child: Container(
              padding: const EdgeInsets.all(8),
              child: SvgPicture.asset(
                'assets/images/cardly_logo.svg',
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RippleWavePainter extends CustomPainter {
  final double value;
  final Color color;

  _RippleWavePainter({required this.value, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final maxRadius = size.shortestSide / 2;

    for (int i = 0; i < 3; i++) {
      final phase = (value + i * 0.33) % 1.0;
      final radius = phase * maxRadius;
      final opacity = 1.0 - phase;

      final fillPaint = Paint()
        ..color = color.withValues(alpha: opacity * 0.18)
        ..style = PaintingStyle.fill;

      final strokePaint = Paint()
        ..color = color.withValues(alpha: opacity * 0.55)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;

      canvas.drawCircle(center, radius, fillPaint);
      canvas.drawCircle(center, radius, strokePaint);
    }
  }

  @override
  bool shouldRepaint(covariant _RippleWavePainter oldDelegate) {
    return oldDelegate.value != value || oldDelegate.color != color;
  }
}
