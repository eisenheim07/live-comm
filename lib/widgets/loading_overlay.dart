import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/size_utils.dart';

class LoadingOverlay extends StatelessWidget {
  final bool isLoading;
  final Widget child;

  const LoadingOverlay({
    super.key,
    required this.isLoading,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: isLoading,
      child: child,
    );
  }
}

// Alternative full-screen loading overlay
class FullScreenLoadingOverlay extends StatelessWidget {
  final bool isLoading;
  final Widget child;

  const FullScreenLoadingOverlay({
    super.key,
    required this.isLoading,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: isLoading,
      child: child,
    );
  }
}

// Simple loading overlay for buttons and small areas
class SimpleLoadingOverlay extends StatelessWidget {
  final bool isLoading;
  final Widget child;

  const SimpleLoadingOverlay({
    super.key,
    required this.isLoading,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: isLoading,
      child: child,
    );
  }
}