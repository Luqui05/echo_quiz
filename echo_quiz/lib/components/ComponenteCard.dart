import 'package:flutter/material.dart';

class ComponenteCard extends StatelessWidget {
  final Widget child;
  final double? opacity;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? cor;

  const ComponenteCard({
    super.key,
    required this.child,
    this.opacity,
    this.padding,
    this.margin,
    this.cor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: cor ?? Colors.white.withOpacity(opacity ?? 0.9),
      margin: margin ?? const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      child: Padding(
        padding: padding ?? const EdgeInsets.all(16),
        child: child,
      ),
    );
  }
}