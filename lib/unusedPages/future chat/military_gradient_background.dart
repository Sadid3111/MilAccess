import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

class MilitaryGradientBackground extends StatelessWidget {
  final Widget child;
  final bool showPattern;

  const MilitaryGradientBackground({
    super.key,
    required this.child,
    this.showPattern = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppTheme.militaryGradient,
      ),
      child: showPattern ? _buildWithPattern() : child,
    );
  }

  Widget _buildWithPattern() {
    return Stack(
      children: [
        // Subtle pattern overlay (optional)
        Positioned.fill(
          child: Opacity(
            opacity: 0.05,
            child: CustomPaint(
              painter: MilitaryPatternPainter(),
            ),
          ),
        ),
        child,
      ],
    );
  }
}

class MilitaryPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    const spacing = 40.0;
    
    // Draw diagonal lines pattern
    for (double i = -size.height; i < size.width + size.height; i += spacing) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i + size.height, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Animated gradient background for special screens
class AnimatedMilitaryBackground extends StatefulWidget {
  final Widget child;
  final Duration duration;

  const AnimatedMilitaryBackground({
    super.key,
    required this.child,
    this.duration = const Duration(seconds: 3),
  });

  @override
  State<AnimatedMilitaryBackground> createState() => _AnimatedMilitaryBackgroundState();
}

class _AnimatedMilitaryBackgroundState extends State<AnimatedMilitaryBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.lerp(
                  AppTheme.backgroundGradientStart,
                  AppTheme.backgroundGradientEnd,
                  _animation.value,
                )!,
                Color.lerp(
                  AppTheme.backgroundGradientEnd,
                  AppTheme.backgroundGradientStart,
                  _animation.value,
                )!,
              ],
            ),
          ),
          child: widget.child,
        );
      },
    );
  }
}