import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garna/global/constants.dart';
import 'package:garna/global/widgets/custom_material_button.dart';
import 'package:garna/screens/editor/bloc/editor_bloc.dart';

import 'custom_image_slider.dart';
import 'custom_text_button.dart';
import 'editor_mode_switcher.dart';

class ClipperOptionsWidget extends StatelessWidget {
  ClipperOptionsWidget({
    Key key,
  }) : super(key: key);

  final List<String> aspectRatioButtons = [
    'Оригинал',
    '1:1',
    '2:3',
    '3:4',
    '4:5',
    '9:16'
  ];

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          const EditorModeSwitcher(),
          Expanded(
            child: PageView(
              physics: const NeverScrollableScrollPhysics(),
              controller:
                  BlocProvider.of<EditorBloc>(context).editModePageController,
              children: [
                Column(
                  children: [
                    const Expanded(child: CustomImageSliderWidget()),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        OrientationButton(
                          axis: Axis.vertical,
                          onPressed: () {},
                          // isActive: true,
                        ),
                        const SizedBox(
                          width: Constants.standardPaddingDouble,
                        ),
                        OrientationButton(
                          axis: Axis.horizontal,
                          onPressed: () {},
                        ),
                      ],
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(
                          aspectRatioButtons.length,
                          (index) => CustomTextButton(
                            title: aspectRatioButtons[index],
                            onPressed: () {},
                            isActive: index == 0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 42.0),
                      child: Row(
                        children: [
                          Text(
                            'X',
                            style: TextStyle(
                              color: Theme.of(context).primaryColorLight,
                              fontSize: 10,
                            ),
                          ),
                          const Expanded(
                            child: CustomImageSliderWidget(
                              horizontalPadding:
                                  Constants.standardPaddingDouble / 2,
                            ),
                          ),
                          const SizedBox(width: 7),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 42.0),
                      child: Row(
                        children: [
                          Text(
                            'Y',
                            style: TextStyle(
                              color: Theme.of(context).primaryColorLight,
                              fontSize: 10,
                            ),
                          ),
                          const Expanded(
                            child: CustomImageSliderWidget(
                              horizontalPadding:
                                  Constants.standardPaddingDouble / 2,
                            ),
                          ),
                          const SizedBox(width: 7),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class OrientationButton extends StatelessWidget {
  final bool isActive;
  final Axis axis;
  final Function onPressed;
  const OrientationButton({
    Key key,
    this.isActive = false,
    @required this.axis,
    @required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomMaterialButton(
      color: Colors.transparent,
      padding: Constants.standardPaddingDouble / 2,
      margin: EdgeInsets.zero,
      child: Container(
        width: axis == Axis.horizontal ? 24 : 16,
        height: axis == Axis.horizontal ? 16 : 24,
        decoration: BoxDecoration(
          color: isActive ? Theme.of(context).accentColor : null,
          border: Border.all(
            color: isActive
                ? Theme.of(context).accentColor
                : Theme.of(context).dividerColor,
          ),
        ),
      ),
      onPressed: onPressed,
    );
  }
}
