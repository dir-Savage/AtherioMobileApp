import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  final Color? color;
  final double? size;
  final double strokeWidth;
  final String? loadingText;

  const LoadingIndicator({
    super.key,
    this.color,
    this.size,
    this.strokeWidth = 4.0,
    this.loadingText,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: size ?? 24,
            height: size ?? 24,
            child: CircularProgressIndicator(
              strokeWidth: strokeWidth,
              valueColor: AlwaysStoppedAnimation<Color>(
                color ?? Theme.of(context).primaryColor,
              ),
            ),
          ),
          if (loadingText != null) ...[
            const SizedBox(height: 16),
            Text(
              loadingText!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withOpacity(0.7),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// Full screen loading overlay
class LoadingOverlay extends StatelessWidget {
  final bool isLoading;
  final Widget child;
  final String? message;
  final Color? barrierColor;
  final Color? progressColor;

  const LoadingOverlay({
    super.key,
    required this.isLoading,
    required this.child,
    this.message,
    this.barrierColor,
    this.progressColor,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          ModalBarrier(
            dismissible: false,
            color: barrierColor ?? Colors.black.withOpacity(0.4),
          ),
        if (isLoading)
          Center(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  LoadingIndicator(
                    color: progressColor,
                    size: 32,
                    strokeWidth: 3.5,
                  ),
                  if (message != null) ...[
                    const SizedBox(height: 16),
                    Text(
                      message!,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ],
                ],
              ),
            ),
          ),
      ],
    );
  }
}
