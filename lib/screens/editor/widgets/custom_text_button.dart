import 'package:flutter/material.dart';
import 'package:garna/global/constants.dart';
import 'package:garna/global/widgets/custom_material_button.dart';

class CustomTextButton extends StatelessWidget {
  final String title;
  final Function onPressed;
  final bool isActive;
  final double fontSize;
  final EdgeInsets margin;
  final Color color;
  const CustomTextButton({
    Key key,
    @required this.title,
    @required this.onPressed,
    @required this.isActive,
    this.fontSize = 10,
    this.margin,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomMaterialButton(
      onPressed: onPressed,
      color: Colors.transparent,
      margin: margin ?? EdgeInsets.zero,
      padding: Constants.standardPaddingDouble / 3,
      child: Text(
        title,
        style: TextStyle(
          fontSize: fontSize,
          color: color ??
              (isActive
                  ? Theme.of(context).accentColor
                  : Theme.of(context).primaryColorLight),
        ),
      ),
    );
  }
}
