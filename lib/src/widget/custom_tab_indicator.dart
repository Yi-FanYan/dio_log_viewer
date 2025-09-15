import 'package:flutter/material.dart';

class CustomTabIndicator extends Decoration {
  final Color color;
  final double widthFactor;
  final double indicatorSpacing;
  final double radius;

  const CustomTabIndicator({
    required this.color,
    this.widthFactor = 0.12,
    this.indicatorSpacing = 8,
    this.radius = 4,
  });

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _CustomTabIndicatorPainter(
      widthFactor: widthFactor,
      indicatorSpacing: indicatorSpacing,
      radius: radius,
      color: color,
    );
  }
}

class _CustomTabIndicatorPainter extends BoxPainter {
  final double widthFactor;
  final double indicatorSpacing;
  final double radius;
  final Color color;

  _CustomTabIndicatorPainter({
    required this.widthFactor,
    required this.indicatorSpacing,
    required this.radius,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    assert(configuration.size != null);
    final Rect rect = Offset(
          offset.dx + configuration.size!.width * (1 - widthFactor) / 2,
          offset.dy + configuration.size!.height - indicatorSpacing,
        ) &
        Size(configuration.size!.width * widthFactor, 3);
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    canvas.drawRRect(
      RRect.fromRectAndCorners(rect, topLeft: Radius.circular(radius), topRight: Radius.circular(radius)),
      paint,
    );
  }
}
