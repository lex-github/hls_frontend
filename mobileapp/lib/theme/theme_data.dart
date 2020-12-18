import 'package:flutter/material.dart' hide Colors, Size, TextStyle;
import 'package:google_fonts/google_fonts.dart';
import 'package:hls/constants/values.dart';
import 'package:hls/theme/styles.dart';

final theme = (context) => ThemeData(
    // general
    accentColor: Colors.primary,
    primaryColor: Colors.primary,
    disabledColor: Colors.disabled,
    errorColor: Colors.failure,
    splashColor: Colors.shadowLight,
    canvasColor: Colors.background,

    // appBar
    appBarTheme: AppBarTheme(color: Colors.background, elevation: elevation),

    // icon theme
    iconTheme: IconThemeData(color: Colors.icon),

    // button bars (alert buttons)
    buttonBarTheme: ButtonBarThemeData(alignment: MainAxisAlignment.center),

    // cards
    cardTheme: CardTheme(
        color: Colors.background,
        margin: EdgeInsets.zero,
        elevation: elevation,
        shape: RoundedRectangleBorder(borderRadius: borderRadiusCircular)),

    // forms
    sliderTheme: SliderThemeData(
        thumbColor: Colors.primary,
        activeTrackColor: Colors.primary,
        inactiveTrackColor: Colors.disabled,
        trackShape: TrackShape()),

    // text theme
    textTheme: GoogleFonts.robotoTextTheme(Theme.of(context).textTheme),

    // text selection
    textSelectionTheme: TextSelectionThemeData(
        selectionColor: Colors.primary.withOpacity(.5),
        selectionHandleColor: Colors.primary));

class TrackShape extends RoundedRectSliderTrackShape {
  Rect getPreferredRect(
      {@required RenderBox parentBox,
      Offset offset = Offset.zero,
      @required SliderThemeData sliderTheme,
      bool isEnabled = false,
      bool isDiscrete = false}) {
    final double trackHeight = sliderTheme.trackHeight;
    final double trackLeft = offset.dx;
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}
