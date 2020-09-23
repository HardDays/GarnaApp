import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garna/global/constants.dart';
import 'package:garna/global/utilities/garna_app_icons.dart';
import 'package:garna/global/widgets/custom_material_button.dart';
import 'package:garna/main.dart';
import 'package:garna/screens/editor/bloc/editor_bloc.dart';
import 'package:garna/screens/editor/widgets/custom_image_slider.dart';
import 'package:garna/screens/editor/widgets/custom_slider.dart';
import 'package:garna/screens/editor/widgets/custom_text_button.dart';
import 'package:garna/screens/editor/widgets/editor_mode_switcher.dart';
import 'package:garna/screens/editor/widgets/filter_button.dart';
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
    _editorBloc.pageController.dispose();
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomMaterialButton(
                      margin: const EdgeInsets.all(
                          Constants.standardPaddingDouble / 2),
                      padding: Constants.standardPaddingDouble / 2,
                      onPressed: () {},
                      color: Colors.transparent,
                      child: Text(
                        'Отмена',
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).primaryColorLight,
                        ),
                      ),
                    ),
                    CustomMaterialButton(
                      color: Colors.transparent,
                      onPressed: () {},
                      margin: const EdgeInsets.all(
                          Constants.standardPaddingDouble / 2),
                      padding: Constants.standardPaddingDouble / 2,
                      child: Text(
                        'Дальше',
                        style: TextStyle(
                          color: Theme.of(context).accentColor,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  flex: 6,
                  // fit: FlexFit.tight,
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: ConstrainedBox(
                      constraints:
                          const BoxConstraints(minWidth: 1, minHeight: 1),
                      child: Image(
                        image: AssetThumbImageProvider(widget.asset,
                            width: 100, height: 100),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Column(
                    children: [
                      EditorModeSwitcherWidget(
                        buttons: [
                          'Фильтры',
                          'Редактор',
                        ],
                        controller: _editorBloc.pageController,
                      ),
                      Flexible(
                        fit: FlexFit.loose,
                        child: PageView(
                          physics: const NeverScrollableScrollPhysics(),
                          controller: _editorBloc.pageController,
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
                                              .withOpacity(index / 10),
                                        ),
                                        title: 'Фильтр $index',
                                      ),
                                    ),
                                  ),
                                ),
                                const CustomSliderWidget(),
                              ],
                            ),
                            Column(
                              children: [
                                Flexible(
                                  fit: FlexFit.loose,
                                  child: ListView(
                                    scrollDirection: Axis.horizontal,
                                    children: _editorBloc.editButtonList,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    CustomTextButton(
                                      isActive: true,
                                      onPressed: () {},
                                      title: 'Выравнивание',
                                    ),
                                    CustomTextButton(
                                      isActive: false,
                                      onPressed: () {},
                                      title: 'Наклон',
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CustomMaterialButton(
                                      color: Colors.transparent,
                                      padding:
                                          Constants.standardPaddingDouble / 2,
                                      margin: EdgeInsets.zero,
                                      child: Container(
                                        width: 16,
                                        height: 24,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color:
                                                Theme.of(context).dividerColor,
                                          ),
                                        ),
                                      ),
                                      onPressed: () {},
                                    ),
                                    const SizedBox(
                                      width: Constants.standardPaddingDouble,
                                    ),
                                    CustomMaterialButton(
                                      color: Colors.transparent,
                                      padding:
                                          Constants.standardPaddingDouble / 2,
                                      margin: EdgeInsets.zero,
                                      child: Container(
                                        width: 24,
                                        height: 16,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color:
                                                Theme.of(context).dividerColor,
                                          ),
                                        ),
                                      ),
                                      onPressed: () {},
                                    ),
                                  ],
                                ),
                                const CustomImageSliderWidget()
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
