import 'package:flutter/material.dart';

class CustomBottomSheet extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final Color backgroundColor;

  const CustomBottomSheet({
    super.key,
    required this.child,
    this.borderRadius = 16.0,
    this.backgroundColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(borderRadius),
          topRight: Radius.circular(borderRadius),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: child,
      ),
    );
  }
}

void showCustomBottomSheet({
  required BuildContext context,
  required Widget child,
  required double maxChildSize,
  Color backgroundColor = Colors.white,
  double borderRadius = 22.0,
}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (_) {
      return DraggableScrollableSheet(
        expand: false,
        maxChildSize: maxChildSize,
        initialChildSize: maxChildSize,
        minChildSize: 0.25,
        builder: (_, scrollController) => CustomBottomSheet(
          backgroundColor: backgroundColor,
          borderRadius: borderRadius,
          child: SingleChildScrollView(
            controller: scrollController,
            child: child,
          ),
        ),
      );
    },
  );
}
