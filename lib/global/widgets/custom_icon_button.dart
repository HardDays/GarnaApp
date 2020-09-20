import 'package:flutter/material.dart';

import '../constants.dart';

class CustomIconButton extends StatelessWidget {
  final Function onPressed;
  final IconData icon;
  final double iconSize;
  final Color iconColor;
  final Color backgroundColor;
  const CustomIconButton({
    this.iconSize = 28,
    this.icon,
    this.onPressed,
    Key key,
    this.iconColor,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(100),
      ),
      color: backgroundColor,
      minWidth: 0,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      padding: Constants.standardPadding,
      child: Container(
        height: iconSize + 7,
        width: iconSize + 7,
        child: Center(
          child: Icon(
            // LineAwesomeIcons.send,
            icon,
            size: iconSize,
            color: iconColor ?? Theme.of(context).accentColor,
          ),
        ),
      ),
      onPressed: onPressed,
    );
  }
}
