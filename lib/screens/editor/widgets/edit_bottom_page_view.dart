import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garna/screens/editor/bloc/editor_bloc.dart';

import 'clipper_options.dart';
import 'custom_slider.dart';

class EditBottomPageViewWidget extends StatelessWidget {
  EditBottomPageViewWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: BlocProvider.of<EditorBloc>(context).editButtonList,
          ),
        ),
        BlocBuilder<EditorBloc, EditorState>(
          buildWhen: (previous, current) =>
              current is EdChangeActiveFilterState,
          builder: (context, state) {
            return BlocProvider.of<EditorBloc>(context).selectedEditItem ==
                    BlocProvider.of<EditorBloc>(context)
                        .editButtonList
                        .first
                        .title
                ? ClipperOptionsWidget()
                : const CustomSliderWidget();
          },
        )
      ],
    );
  }
}
