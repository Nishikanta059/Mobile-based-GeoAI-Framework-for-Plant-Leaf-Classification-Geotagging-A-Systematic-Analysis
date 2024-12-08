import 'dart:ui';

import 'package:flutter/material.dart';

class GlassifyWhite extends StatelessWidget {
  Widget child;
  GlassifyWhite({required this.child});

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: this.child,
    );
  }
}
