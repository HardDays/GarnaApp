import 'package:flutter/material.dart';

import '../constants.dart';

class CustomMaterialButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;
  final Color color;
  final BorderRadius borderRadius;
  final double padding;
  final double elevation;
  final bool infiniteWidth;
  final EdgeInsets margin;
  CustomMaterialButton({
    Key key,
    @required this.onPressed,
    this.child,
    this.color,
    this.borderRadius,
    this.padding,
    this.elevation,
    this.infiniteWidth = false,
    this.margin = Constants.customButtonMargin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin,
      child: MaterialButton(
        elevation: elevation,
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius ?? Constants.standardBorderRadius,
        ),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        minWidth: infiniteWidth ? double.infinity : 0,
        padding: EdgeInsets.all(padding ?? Constants.standardPaddingDouble),
        onPressed: onPressed,
        child: child,
        color: color ?? Theme.of(context).accentColor,
      ),
    );
  }
}
