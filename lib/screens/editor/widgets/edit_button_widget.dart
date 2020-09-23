import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garna/global/constants.dart';
import 'package:garna/global/widgets/custom_material_button.dart';
import 'package:garna/screens/editor/bloc/editor_bloc.dart';

class EditButtonWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final Function onPressed;
  const EditButtonWidget({
    Key key,
    this.icon,
    this.title,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditorBloc, EditorState>(
      buildWhen: (previous, current) => current is EdChangeActiveFilterState,
      builder: (context, state) {
        return CustomMaterialButton(
          // margin: EdgeInsets.zero,
          margin: const EdgeInsets.all(Constants.standardPaddingDouble / 2),
          padding: 0,
          color: Colors.transparent,
          onPressed: () {
            BlocProvider.of<EditorBloc>(context)
                .add(EdChangeActiveFilterEvent(title));
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
                  color: title ==
                          BlocProvider.of<EditorBloc>(context).selectedEditItem
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
                      color: title ==
                              BlocProvider.of<EditorBloc>(context)
                                  .selectedEditItem
                          ? Theme.of(context).accentColor
                          : Theme.of(context).primaryColorLight),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
