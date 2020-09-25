import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garna/global/constants.dart';
import 'package:garna/global/utilities/garna_app_icons.dart';
import 'package:garna/global/widgets/custom_material_button.dart';
import 'package:garna/screens/editor/bloc/editor_bloc.dart';
import 'package:garna/screens/editor/widgets/custom_slider.dart';
import 'package:garna/screens/editor/widgets/custom_text_button.dart';
import 'package:garna/screens/editor/widgets/edit_bottom_page_view.dart';
import 'package:garna/screens/editor/widgets/mode_switcher.dart';
import 'package:garna/screens/editor/widgets/filter_button.dart';
import 'package:garna/screens/editor/widgets/top_navigation_bar.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class EditorScreen extends StatefulWidget {
  final Asset asset;
  const EditorScreen({Key key, this.asset}) : super(key: key);

  static const String id = '/editor';

  @override
  _EditorScreenState createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  final EditorBloc _editorBloc = EditorBloc();

  @override
  void dispose() {
    _editorBloc.modePageController.dispose();
    _editorBloc.editModePageController.dispose();
    _editorBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocProvider(
        create: (context) => _editorBloc,
        child: Scaffold(
          body: SizedBox.expand(
            child: Column(
              children: [
                const TopNavigationBarWidget(),
                Expanded(
                  // flex: 7,
                  // fit: FlexFit.tight,
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: ConstrainedBox(
                      constraints:
                          const BoxConstraints(minWidth: 1, minHeight: 1),
                      child: Image(
                        image: AssetThumbImageProvider(
                          widget.asset,
                          width: 3000,
                          height: 3000,
                        ),
                      ),
                    ),
                  ),
                ),
                BlocBuilder<EditorBloc, EditorState>(
                  cubit: _editorBloc,
                  buildWhen: (previous, current) =>
                      current is EdChangeBottomPanelHeightState ||
                      current is EdEndEditingState ||
                      current is EdResumeEditingSate,
                  builder: (context, state) {
                    return AnimatedContainer(
                      height: state is EdChangeBottomPanelHeightState
                          ? state.height
                          : 200,
                      duration: Constants.standardAnimationDuration,
                      // flex: 5,
                      child: state is EdEndEditingState
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                CustomMaterialButton(
                                  onPressed: () {},
                                  infiniteWidth: true,
                                  child: Text(
                                    'Сохранить',
                                    style: TextStyle(
                                      color:
                                          Theme.of(context).primaryColorLight,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                CustomTextButton(
                                  title: 'Отменить редактирование',
                                  onPressed: () {},
                                  isActive: false,
                                  fontSize: 16,
                                  color: Constants.colorLightGrey,
                                ),
                              ],
                            )
                          : Column(
                              children: [
                                ModeSwitcherWidget(
                                  buttons: [
                                    'Фильтры',
                                    'Редактор',
                                  ],
                                  controller: _editorBloc.modePageController,
                                ),
                                Flexible(
                                  fit: FlexFit.loose,
                                  child: PageView(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    controller: _editorBloc.modePageController,
                                    children: [
                                      Column(
                                        children: [
                                          Expanded(
                                            child: ListView(
                                              scrollDirection: Axis.horizontal,
                                              children: List.generate(
                                                10,
                                                (index) => FilterButtonWidget(
                                                  onPressed: () {},
                                                  child: Container(
                                                    color: Colors.amber
                                                        .withOpacity(
                                                            index / 10),
                                                  ),
                                                  title: 'Фильтр $index',
                                                ),
                                              ),
                                            ),
                                          ),
                                          const CustomSliderWidget(),
                                        ],
                                      ),
                                      EditBottomPageViewWidget(),
                                    ],
                                  ),
                                )
                              ],
                            ),
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
