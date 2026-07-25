import 'package:flutter/material.dart';

class HorizontalGap extends StatelessWidget {
  final double? val;
  const HorizontalGap(this.val, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: val ?? 10,
    );
  }
}

class VerticalGap extends StatelessWidget {
  final double? val;
  const VerticalGap(this.val, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: val ?? 10,
    );
  }
}
