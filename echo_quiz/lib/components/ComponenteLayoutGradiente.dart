import 'package:flutter/material.dart';

class ComponenteLayoutGradiente extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;

  const ComponenteLayoutGradiente({
    super.key,
    required this.child,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: padding ?? const EdgeInsets.all(24),
      child: child,
    );
  }
}