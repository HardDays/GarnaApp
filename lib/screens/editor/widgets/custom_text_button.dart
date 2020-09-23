import 'package:flutter/material.dart';
import 'package:garna/global/constants.dart';
import 'package:garna/global/widgets/custom_material_button.dart';

class CustomTextButton extends StatelessWidget {
  final String title;
  final Function onPressed;
  final bool isActive;
  const CustomTextButton({
    Key key,
    @required this.title,
    @required this.onPressed,
    @required this.isActive,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomMaterialButton(
      onPressed: onPressed,
      color: Colors.transparent,
      margin: EdgeInsets.zero,
      padding: Constants.standardPaddingDouble / 2,
      child: Text(
        title,
        style: TextStyle(
          fontSize: 10,
          color: isActive
              ? Theme.of(context).accentColor
              : Theme.of(context).primaryColorLight,
        ),
      ),
    );
  }
}
