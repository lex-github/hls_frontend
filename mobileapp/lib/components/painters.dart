/// {@category components}
/// CLasses to paint custom graphics.
library painters;

import 'dart:math';

import 'package:flutter/material.dart' hide Colors, Size, TextStyle;
import 'package:flutter/material.dart' as M;
import 'package:hls/theme/styles.dart';
import 'package:path_drawing/path_drawing.dart';

class CircleDialPainter extends CustomPainter {
  final Color color;
  final List<int> values;
  final double offset;
  final double fontSize;

  CircleDialPainter(
      {@required this.color,
      @required this.values,
      this.offset = 0,
      this.fontSize});

  @override
  void paint(Canvas canvas, M.Size size) {
    final radius = min(size.width, size.height) / 2;
    final textRadius = radius - Size.fontTiny;

    final paint = Paint()
      ..isAntiAlias = true
      ..strokeWidth = Size.border * 3
      ..color = color
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(Offset(size.width / 2, size.height / 2), radius, paint);

    final textPainter = TextPainter(
        text: TextSpan(
            text: '',
            style: TextStyle.primary.copyWith(fontSize: fontSize ?? Size.fontTiny)),
        textDirection: TextDirection.ltr);

    final stepAngle = 2 * pi / values.length;
    for (final value in values) {
      textPainter.text =
          TextSpan(text: '$value', style: textPainter.text.style);
      textPainter.layout();

      canvas.save();

      final stepIndex = values.indexOf(value) + 1;

      // determine where to draw
      final offset = offsetFromAngle(
          stepAngle * stepIndex - pi / 2 + this.offset, textRadius,
          width: size.width / 2, height: size.height / 2);
      canvas.translate(offset.dx - textPainter.width / 2,
          offset.dy - textPainter.height / 2);

      textPainter.paint(canvas, Offset.zero);

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_) => false;
}

// class NightPainter extends CustomPainter {
//   final DateTime from;
//   final Da endAngle;
//   final double startAngle;
//
//   SectorPainter(
//     {@required this.color, @required this.endAngle, this.startAngle = .0});
//
//   @override
//   void paint(Canvas canvas, M.Size size) {
//     final Paint paint = Paint()
//       ..isAntiAlias = true
//       ..strokeWidth = Size.border * 2
//       ..color = color
//       ..style = PaintingStyle.stroke;
//     canvas.drawArc(Rect.fromLTWH(0.0, 0.0, size.width, size.height), startAngle,
//       endAngle, false, paint);
//   }
//
//   @override
//   bool shouldRepaint(SectorPainter old) =>
//     endAngle != old.endAngle || color != old.color;
// }

/// Paints simple circular progressbar
class SectorPainter extends CustomPainter {
  final Color color;
  final double endAngle;
  final double startAngle;
  final double width;

  SectorPainter(
      {@required this.color, @required this.endAngle, this.startAngle = .0, this.width});

  @override
  void paint(Canvas canvas, M.Size size) {
    final Paint paint = Paint()
      ..isAntiAlias = true
      ..strokeWidth = width ?? (Size.border * 2)
      ..color = color
      ..style = PaintingStyle.stroke;
    canvas.drawArc(Rect.fromLTWH(0.0, 0.0, size.width, size.height), startAngle,
        endAngle, false, paint);
  }

  @override
  bool shouldRepaint(SectorPainter old) =>
      endAngle != old.endAngle || color != old.color;
}

/// Paints advanced circular progressbar
///
/// Builds sector progressbar with [value] and [title]
class SectorProgressPainter extends CustomPainter {
  final Color color;
  final double endAngle;
  final double startAngle;
  final String title;
  final double value;

  SectorProgressPainter(
      {@required this.color,
      @required this.endAngle,
      this.startAngle = .0,
      this.title,
      this.value});

  @override
  void paint(Canvas canvas, M.Size size) {
    final radius = size.width / 2;
    final foregroundStrokeWidth = Size.border * 8;
    final padding = Size.horizontalSmall;

    // draw text
    final textPainter = TextPainter(
        text: TextSpan(
            text: title,
            style: TextStyle.primary.copyWith(fontSize: Size.fontTiny)),
        textDirection: TextDirection.ltr)
      ..layout();

    // correct angles to factor in border radius and padding
    final correctionStart = (padding + foregroundStrokeWidth / 2) / radius;
    final correctedStartAngle = startAngle + correctionStart;
    final correctedEndAngle = endAngle - correctionStart;

    final correctionGaugeTextWidth = (textPainter.width + padding) / radius;
    final gaugeEndAngle = correctedEndAngle - correctionGaugeTextWidth;

    // background gauge
    final paint = Paint()
      ..isAntiAlias = true
      ..strokeWidth = Size.border * 3
      ..color = color.withOpacity(.3)
      ..style = PaintingStyle.stroke;
    canvas.drawArc(Rect.fromLTWH(0.0, 0.0, size.width, size.height),
        correctedStartAngle, gaugeEndAngle, false, paint);

    // foreground
    paint
      ..strokeWidth = foregroundStrokeWidth
      ..color = color;

    // start of foreground gauge
    canvas.drawCircle(
        offsetFromAngle(correctedStartAngle, radius), 0.001, paint);

    // foreground gauge
    final knobWidth = Size.border * 20;
    final correctionKnob = knobWidth / 2 / radius;
    canvas.drawArc(
        Rect.fromLTWH(0.0, 0.0, size.width, size.height),
        correctedStartAngle,
        (gaugeEndAngle - correctionKnob) * value,
        false,
        paint);

    // end of foreground gauge
    canvas.drawCircle(
        offsetFromAngle(
            (gaugeEndAngle - correctionKnob * 1.5) * value +
                correctionKnob / 2 +
                correctedStartAngle,
            radius),
        knobWidth / 2,
        paint..style = PaintingStyle.fill);

    canvas.save();

    // position and rotation of text
    final textOrbitRadius = radius - textPainter.height / 2;
    final correctionTextWidth = textPainter.width / 2 / textOrbitRadius;
    final offset = offsetFromAngle(
        correctedEndAngle + correctedStartAngle, textOrbitRadius,
        width: size.width / 2, height: size.height / 2);
    canvas.translate(offset.dx, offset.dy);
    canvas.rotate(
        correctedEndAngle + correctedStartAngle - correctionTextWidth - pi / 2);

    textPainter.paint(canvas, Offset.zero);

    canvas.restore();
  }

  @override
  bool shouldRepaint(SectorProgressPainter old) => true;
  // endAngle != old.endAngle || color != old.color;
}

Offset offsetFromAngle(double angle, double radius,
    {double width, double height}) {
  final a = -angle;
  final offset = Offset(radius * cos(a) + (width ?? radius),
      -radius * sin(a) + (height ?? radius));

  // print('offsetFromAngle angle: $angle, x: ${radius * cos(a)}, y: ${radius * sin(a)}');
  // print('offsetFromAngle angle: $a, offset: $offset');

  return offset;
}

class MacroGraphPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, M.Size size) {
    final widthCell = size.width / 7;
    final heightCell = size.height / 2;
    final pointStart = Offset(0, size.height);

    Paint paint = Paint()
      ..isAntiAlias = true
      ..strokeWidth = Size.border
      ..color = Colors.macroHLS
      ..style = PaintingStyle.stroke;

    Offset pointPeak = Offset(widthCell * 3, .55 * heightCell);
    Offset pointEnd = Offset(size.width, .75 * heightCell);
    canvas.drawLine(pointStart, pointPeak, paint);
    canvas.drawLine(pointPeak, pointEnd, paint);

    paint..color = Colors.macroNoHLS;
    pointPeak = Offset(widthCell * 3, heightCell);
    pointEnd = Offset(size.width, 1.35 * heightCell);
    canvas.drawLine(pointStart, pointPeak, paint);
    canvas.drawLine(pointPeak, pointEnd, paint);

    paint..color = Colors.macroStatistical;
    pointPeak = Offset(widthCell * 3, 1.25 * heightCell);
    pointEnd = Offset(size.width, 1.7 * heightCell);
    // canvas.drawLine(pointStart, pointPeak, paint);
    // canvas.drawLine(pointPeak, pointEnd, paint);

    canvas.drawPath(
        dashPath(
            Path()
              ..moveTo(pointStart.dx, pointStart.dy)
              ..lineTo(pointPeak.dx, pointPeak.dy)
              ..lineTo(pointEnd.dx, pointEnd.dy),
            dashArray: CircularIntervalList<double>(
                <double>[1.5 * Size.horizontalTiny, .8 * Size.horizontalTiny])),
        paint);
  }

  @override
  bool shouldRepaint(_) => false;
}
