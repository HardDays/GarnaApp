 import 'package:flutter/material.dart';

// class CustomImageSliderWidget extends StatefulWidget {
//   const CustomImageSliderWidget({Key key}) : super(key: key);

//   @override
//   _CustomImageSliderWidgetState createState() =>
//       _CustomImageSliderWidgetState();
// }

// class _CustomImageSliderWidgetState extends State<CustomImageSliderWidget> {
//   double val = 0.5;
//   @override
//   Widget build(BuildContext context) {
//     return SliderTheme(
//       data: SliderTheme.of(context).copyWith(
//         trackShape: ImageSliderTrackShape(),
//         thumbShape: ImageSliderThumbShape(),
//         overlayColor: Colors.transparent,
//       ),
//       child: Slider(
//         value: val,
//         onChanged: (value) {
//           val = value;
//           setState(() {});
//         },
//       ),
//     );
//   }
// }

class ImageSliderThumbShape extends SliderComponentShape {
  final double thumbWidth;
  final double thumbHeight;

  ImageSliderThumbShape({
    this.thumbWidth = 2.0,
    this.thumbHeight = 16.0,
  });

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size(thumbWidth, thumbHeight);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    Animation<double> activationAnimation,
    Animation<double> enableAnimation,
    bool isDiscrete,
    TextPainter labelPainter,
    RenderBox parentBox,
    SliderThemeData sliderTheme,
    TextDirection textDirection,
    double value,
    double textScaleFactor,
    Size sizeWithOverflow,
  }) {
    final Canvas canvas = context.canvas;
    final Paint paint = Paint()
      ..color = sliderTheme.activeTrackColor
      ..strokeWidth = thumbWidth;
    canvas.drawLine(Offset(center.dx, center.dy - thumbHeight / 2),
        Offset(center.dx, center.dy + thumbHeight / 2), paint);
  }
}

class ImageSliderTrackShape extends SliderTrackShape {
  final double trackHeight;
  final double horizontalPadding;
  final double tickMarksWidth;
  final double tickMarksHeight;
  final int divisions;

  ImageSliderTrackShape({
    this.trackHeight = 2.0,
    this.horizontalPadding = 58.0,
    this.tickMarksWidth = 2.0,
    this.tickMarksHeight = 16.0,
    this.divisions = 4,
  });

  @override
  Rect getPreferredRect(
      {RenderBox parentBox,
      Offset offset = Offset.zero,
      SliderThemeData sliderTheme,
      bool isEnabled,
      bool isDiscrete}) {
    final double thumbWidth =
        sliderTheme.thumbShape.getPreferredSize(true, isDiscrete).width;
    final double trackHeight = sliderTheme.trackHeight;
    assert(thumbWidth >= 0);
    assert(trackHeight >= 0);
    assert(parentBox.size.width >= thumbWidth);
    assert(parentBox.size.height >= trackHeight);

    final double trackLeft = offset.dx + horizontalPadding;
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackWidth = parentBox.size.width - horizontalPadding * 2;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }

  @override
  void paint(PaintingContext context, Offset offset,
      {RenderBox parentBox,
      SliderThemeData sliderTheme,
      Animation<double> enableAnimation,
      Offset thumbCenter,
      bool isEnabled,
      bool isDiscrete,
      TextDirection textDirection}) {
    if (sliderTheme.trackHeight == 0) {
      return;
    }

    final double trackStartDx = horizontalPadding;
    final double trackEndDx = parentBox.size.width - horizontalPadding;
    final double trackCenterDy = parentBox.size.height / 2;
    final double trackDivisionWidth = (trackEndDx - trackStartDx) / divisions;

    final Paint trackPaint = Paint()
      ..color = sliderTheme.inactiveTrackColor
      ..strokeWidth = trackHeight;
    final Paint tickPaint = Paint()
      ..color = sliderTheme.inactiveTrackColor
      ..strokeWidth = tickMarksWidth;
    context.canvas.drawLine(
        Offset(horizontalPadding, trackCenterDy - trackHeight / 2),
        Offset(trackEndDx, trackCenterDy + trackHeight / 2),
        trackPaint);
    for (int i = 0; i < divisions + 1; i++) {
      context.canvas.drawLine(
          Offset(trackStartDx + (trackDivisionWidth * i),
              trackCenterDy - tickMarksHeight / 2),
          Offset(trackStartDx + (trackDivisionWidth * i),
              trackCenterDy + tickMarksHeight / 2),
          tickPaint);
    }
  }
}
