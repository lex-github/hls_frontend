/// {@category components}
/// CLasses to paint custom graphics.
library painters;

import 'package:flutter/material.dart' hide Size;
import 'package:flutter/material.dart' as M;
import 'package:hls/theme/styles.dart';

/// Paints simple circular progressbar
class SectorPainter extends CustomPainter {
  final Color color;
  final double endAngle;
  final double startAngle;

  SectorPainter(
      {@required this.color, @required this.endAngle, this.startAngle = .0});

  @override
  void paint(Canvas canvas, M.Size size) {
    final Paint paint = Paint()
      ..isAntiAlias = true
      ..strokeWidth = Size.border * 2
      ..color = color
      ..style = PaintingStyle.stroke;
    canvas.drawArc(Rect.fromLTWH(0.0, 0.0, size.width, size.height), startAngle,
        endAngle, false, paint);
  }

  @override
  bool shouldRepaint(SectorPainter old) =>
      endAngle != old.endAngle || color != old.color;
}
