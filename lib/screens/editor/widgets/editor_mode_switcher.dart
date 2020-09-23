import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garna/global/constants.dart';
import 'package:garna/global/widgets/custom_material_button.dart';
import 'package:garna/screens/editor/bloc/editor_bloc.dart';

class EditorModeSwitcherWidget extends StatefulWidget {
  final double itemWidth;
  final double innerPadding;
  final double indicatorSize;
  final PageController controller;
  final List<String> buttons;
  const EditorModeSwitcherWidget({
    Key key,
    this.itemWidth = 100,
    this.innerPadding = 40,
    this.indicatorSize = 6,
    @required this.controller,
    @required this.buttons,
  }) : super(key: key);

  @override
  _EditorModeSwitcherWidgetState createState() =>
      _EditorModeSwitcherWidgetState();
}

class _EditorModeSwitcherWidgetState extends State<EditorModeSwitcherWidget> {
  @override
  void initState() {
    super.initState();
    leftMargin = widget.itemWidth / 2 - widget.indicatorSize / 2;
    rightMargin = (widget.itemWidth * (widget.buttons.length - 1)) +
        (widget.innerPadding * (widget.buttons.length - 1)) +
        leftMargin;
    maxExtent = (widget.itemWidth * (widget.buttons.length - 1)) +
        (widget.innerPadding * (widget.buttons.length - 1));
    widget.controller.addListener(() {
      maxExtent = ((widget.itemWidth * (widget.buttons.length - 1)) +
          (widget.innerPadding * (widget.buttons.length - 1)));
      koef =
          widget.controller.offset / widget.controller.position.maxScrollExtent;
      setState(() {});
    });
  }

  double leftMargin = 0;
  double rightMargin = 0;
  double maxExtent = 0;
  double koef = 0;

  double calculateButtonColorOpacity(int index) {
    return 1 - ((index / 2).ceil() / (widget.buttons.length - 1) - koef).abs();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            widget.buttons.length * 2 - 1,
            (index) {
              return index.isOdd
                  ? SizedBox(
                      width: widget.innerPadding,
                    )
                  : SizedBox(
                      width: widget.itemWidth,
                      child: CustomMaterialButton(
                        margin: EdgeInsets.zero,
                        padding: Constants.standardPaddingDouble / 2,
                        onPressed: () {
                          BlocProvider.of<EditorBloc>(context)
                              .pageController
                              .animateToPage((index / 2).ceil(),
                                  duration: Constants.standardAnimationDuration,
                                  curve: Curves.linear);
                        },
                        color: Colors.transparent,
                        child: Text(
                          widget.buttons[(index / 2).ceil()],
                          style: TextStyle(
                            fontSize: 16,
                            color:
                                Theme.of(context).primaryColorLight.withOpacity(
                                      calculateButtonColorOpacity(index) < 0.4
                                          ? 0.4
                                          : calculateButtonColorOpacity(
                                              index,
                                            ),
                                    ),
                          ),
                        ),
                      ),
                    );
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(
                left: leftMargin + maxExtent * koef,
                right: rightMargin - maxExtent * koef,
              ),
              width: widget.indicatorSize,
              height: widget.indicatorSize,
              decoration: BoxDecoration(
                color: Theme.of(context).accentColor,
                borderRadius: BorderRadius.circular(100),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
