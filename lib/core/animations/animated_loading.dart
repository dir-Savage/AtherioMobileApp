// core/static_widgets/animated_loading.dart
import 'package:flutter/material.dart';

class AnimatedLoading extends StatefulWidget {
  final Color? color;

  const AnimatedLoading({super.key, this.color});

  @override
  _AnimatedLoadingState createState() => _AnimatedLoadingState();
}

class _AnimatedLoadingState extends State<AnimatedLoading> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(
          widget.color ?? Theme.of(context).primaryColor,
        ),
        strokeWidth: 3,
      ),
    );
  }
}