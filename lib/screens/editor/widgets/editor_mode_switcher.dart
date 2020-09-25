import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garna/global/constants.dart';
import 'package:garna/screens/editor/bloc/editor_bloc.dart';

import 'custom_text_button.dart';

class EditorModeSwitcher extends StatefulWidget {
  const EditorModeSwitcher({
    Key key,
  }) : super(key: key);

  @override
  _EditorModeSwitcherState createState() => _EditorModeSwitcherState();
}

class _EditorModeSwitcherState extends State<EditorModeSwitcher> {
  final List<String> editModeButtons = ['Выравнивание', 'Наклон'];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: List.generate(
        2,
        (index) => CustomTextButton(
          isActive: index ==
              (BlocProvider.of<EditorBloc>(context)
                      .editModePageController
                      .hasClients
                  ? BlocProvider.of<EditorBloc>(context)
                      .editModePageController
                      .page
                  : 0),
          onPressed: () => BlocProvider.of<EditorBloc>(context)
              .editModePageController
              .animateToPage(
                index,
                duration: Constants.standardAnimationDuration,
                curve: Curves.linear,
              )
              .then((value) => setState(() {})),
          title: editModeButtons[index],
        ),
      ),
    );
  }
}
