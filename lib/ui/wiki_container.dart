import 'package:flutter/material.dart';

class WikiContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color backgroundColor;
  final BorderRadiusGeometry borderRadius;
  final BoxBorder? border;

  const WikiContainer({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
    this.backgroundColor = const Color(0xFFF5F5F5), // Colors.grey.shade100
    this.borderRadius = const BorderRadius.all(Radius.circular(4)),
    this.border = const Border.fromBorderSide(
      BorderSide(color: Colors.black12),
    ),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: borderRadius,
        border: border,
      ),
      child: child,
    );
  }
}
