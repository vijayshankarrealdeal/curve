import 'dart:math';
import 'package:curve/api/colors_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class AnimatedBackground extends StatefulWidget {
  const AnimatedBackground({super.key});

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation1;
  late Animation<double> _animation2;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat(reverse: true);

    _animation1 = Tween<double>(begin: 0, end: 2 * pi).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _animation2 = Tween<double>(begin: 2 * pi, end: 0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Consumer<ColorsProvider>(builder: (context, colorProvider, _) {
          return CustomPaint(
            painter: _GradientPainter(_animation1.value, _animation2.value,
                colorProvider.getGradients()),
            child: Container(),
          );
        });
      },
    );
  }
}

class _GradientPainter extends CustomPainter {
  final double rotation1;
  final double rotation2;
  final List<List<Color>> gradient;

  _GradientPainter(this.rotation1, this.rotation2, this.gradient);

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);

    // Two gradients that rotate in opposite directions
    final gradient1 = RadialGradient(
      center: const Alignment(0.2, 0.2),
      radius: 1.2,
      colors: gradient[0],
      stops: const [0.0, 2.0],
      transform: GradientRotation(rotation1),
    );

    final gradient2 = RadialGradient(
      center: const Alignment(0.8, 0.8),
      radius: 1.3,
      colors: gradient[1],
      stops: const [0.0, 1.0],
      transform: GradientRotation(rotation2),
    );

    // Paint the first gradient
    final paint1 = Paint()..shader = gradient1.createShader(rect);
    canvas.drawRect(rect, paint1);

    // Blend the second gradient using an overlay approach
    final paint2 = Paint()
      ..blendMode = BlendMode.overlay
      ..shader = gradient2.createShader(rect);
    canvas.drawRect(rect, paint2);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
