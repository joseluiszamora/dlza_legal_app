import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double? elevation;
  final Color? backgroundColor;
  final VoidCallback? onTap;

  const CustomCard({
    super.key,
    required this.child,
    this.padding,
    this.elevation,
    this.backgroundColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cardChild = Padding(
      padding: padding ?? const EdgeInsets.all(16),
      child: child,
    );

    return Card(
      elevation: elevation ?? 4,
      color: backgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child:
          onTap != null
              ? InkWell(
                onTap: onTap,
                borderRadius: BorderRadius.circular(16),
                child: cardChild,
              )
              : cardChild,
    );
  }
}
