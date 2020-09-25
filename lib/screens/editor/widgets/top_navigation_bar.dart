import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garna/global/constants.dart';
import 'package:garna/global/utilities/garna_app_icons.dart';
import 'package:garna/global/widgets/custom_material_button.dart';
import 'package:garna/screens/editor/bloc/editor_bloc.dart';

import 'custom_text_button.dart';

class TopNavigationBarWidget extends StatelessWidget {
  const TopNavigationBarWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditorBloc, EditorState>(
      buildWhen: (previous, current) =>
          current is EdShowOrHideFrameButtonState ||
          current is EdEndEditingState ||
          current is EdResumeEditingSate,
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomTextButton(
              title: state is EdEndEditingState ? 'Назад' : 'Отмена',
              onPressed: state is EdEndEditingState
                  ? () => BlocProvider.of<EditorBloc>(context)
                      .add(EdResumeEditingEvent())
                  : () => Navigator.of(context).pop(),
              isActive: false,
              margin: Constants.standardPadding,
              fontSize: 16,
            ),
            state is EdShowOrHideFrameButtonState && state.show
                ? CustomMaterialButton(
                    onPressed: () {},
                    margin: EdgeInsets.zero,
                    padding: Constants.standardPaddingDouble / 2,
                    color: Colors.transparent,
                    child: Icon(
                      GarnaAppIcons.frame,
                      size: 30,
                      color: Theme.of(context).primaryColorLight,
                    ),
                  )
                : const SizedBox(),
            state is EdEndEditingState
                ? const SizedBox()
                : CustomTextButton(
                    title: 'Дальше',
                    onPressed: () => BlocProvider.of<EditorBloc>(context)
                        .add(EdEndEditingEvent()),
                    isActive: true,
                    margin: Constants.standardPadding,
                    fontSize: 16,
                  ),
          ],
        );
      },
    );
  }
}
