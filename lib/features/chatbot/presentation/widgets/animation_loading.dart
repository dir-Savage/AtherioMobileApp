import 'package:flutter/material.dart';
import 'dart:math' as math;

class LoadingAnimation extends StatefulWidget {
  const LoadingAnimation({super.key});

  @override
  State<LoadingAnimation> createState() => _LoadingAnimationState();
}

class _LoadingAnimationState extends State<LoadingAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotation;
  late Animation<double> _scale;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    _rotation = Tween<double>(begin: 0, end: 2 * math.pi).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _scale = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );

    _fade = Tween<double>(begin: 0.3, end: 1.0).animate(
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
        return Stack(
          alignment: Alignment.center,
          children: [
            // Glow effect
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Colors.blue.withOpacity(0.3),
                    Colors.blue.withOpacity(0.1),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.7, 1.0],
                ),
              ),
            ),
            // Central rotating and scaling star
            Transform.scale(
              scale: _scale.value,
              child: Transform.rotate(
                angle: _rotation.value,
                child: const Icon(
                  Icons.star,
                  size: 40,
                  color: Colors.blue,
                ),
              ),
            ),
            // Orbiting particles
            for (int i = 0; i < 3; i++)
              Transform.translate(
                offset: Offset(
                  30 * math.cos(_rotation.value + i * 2 * math.pi / 3),
                  30 * math.sin(_rotation.value + i * 2 * math.pi / 3),
                ),
                child: Opacity(
                  opacity: _fade.value,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blueAccent,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}