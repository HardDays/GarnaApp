import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garna/global/constants.dart';
import 'package:garna/global/widgets/custom_material_button.dart';
import 'package:garna/screens/editor/bloc/editor_bloc.dart';

class EditButtonWidget extends StatelessWidget {
  final bool selected;
  final IconData icon;
  final String title;
  final Function onPressed;
  const EditButtonWidget({
    Key key,
    this.icon,
    this.title,
    this.onPressed,
    this.selected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomMaterialButton(
          // margin: EdgeInsets.zero,
      margin: const EdgeInsets.all(Constants.standardPaddingDouble / 2),
      padding: 0,
      color: Colors.transparent,
      onPressed: () {
        if (onPressed != null) {
          onPressed();
        }
      },
      child: SizedBox(
        width: 80,
        height: 80,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 38,
              color: selected 
                  ? Theme.of(context).accentColor
                  : Theme.of(context).primaryColorLight,
            ),
            const SizedBox(
              height: Constants.standardPaddingDouble,
            ),
            Text(
              title,
              style: TextStyle(
                  fontSize: 10,
                  color: selected
                      ? Theme.of(context).accentColor
                      : Theme.of(context).primaryColorLight),
            ),
          ],
        ),
      ),
    );
  }
}
