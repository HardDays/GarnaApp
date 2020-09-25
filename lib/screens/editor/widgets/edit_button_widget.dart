import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garna/global/constants.dart';
import 'package:garna/global/widgets/custom_material_button.dart';
import 'package:garna/screens/editor/bloc/editor_bloc.dart';

class EditButtonWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final Function onPressed;
  final bool isSatturationIcon;
  const EditButtonWidget({
    Key key,
    this.icon,
    this.title,
    this.onPressed,
    this.isSatturationIcon = false,
  })  : assert(!isSatturationIcon || icon == null),
        super(key: key);

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
          child: ConstrainedBox(
            constraints: const BoxConstraints(
                minHeight: 1, maxHeight: 80, minWidth: 80, maxWidth: 80),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  !isSatturationIcon
                      ? Icon(
                          icon,
                          size: 38,
                          color: title ==
                                  BlocProvider.of<EditorBloc>(context)
                                      .selectedEditItem
                              ? Theme.of(context).accentColor
                              : Theme.of(context).primaryColorLight,
                        )
                      : CustomSatturationWidgetIcon(title: title),
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
          ),
        );
      },
    );
  }
}

class CustomSatturationWidgetIcon extends StatelessWidget {
  const CustomSatturationWidgetIcon({
    Key key,
    @required this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: 38,
      width: 38,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        border: Border.all(
          width: 2,
          color: title == BlocProvider.of<EditorBloc>(context).selectedEditItem
              ? Theme.of(context).accentColor
              : Theme.of(context).primaryColorLight,
        ),
      ),
      child: Container(
        width: 29,
        height: 29,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Theme.of(context).primaryColorLight,
              title == BlocProvider.of<EditorBloc>(context).selectedEditItem
                  ? Theme.of(context).accentColor
                  : Theme.of(context).primaryColorLight.withOpacity(0.05),
            ],
          ),
        ),
      ),
    );
  }
}
