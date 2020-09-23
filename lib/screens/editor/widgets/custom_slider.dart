import 'package:flutter/material.dart';

class CustomSliderWidget extends StatefulWidget {
  const CustomSliderWidget({
    Key key,
  }) : super(key: key);

  @override
  _CustomSliderWidgetState createState() => _CustomSliderWidgetState();
}

class _CustomSliderWidgetState extends State<CustomSliderWidget> {
  double val = 0;
  @override
  Widget build(BuildContext context) {
    return Slider(
      value: val,
      onChanged: (value) {
        val = value;
        setState(() {});
      },
    );
  }
}
