import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garna/global/constants.dart';
import 'package:garna/global/utilities/garna_app_icons.dart';
import 'package:garna/global/widgets/custom_material_button.dart';
import 'package:garna/main.dart';
import 'package:garna/screens/editor/bloc/editor_bloc.dart';
import 'package:garna/screens/editor/widgets/custom_image_slider.dart';
import 'package:garna/screens/editor/widgets/custom_slider.dart';
import 'package:garna/screens/editor/widgets/custom_text_button.dart';
import 'package:garna/screens/editor/widgets/edit_button_widget.dart';
import 'package:garna/screens/editor/widgets/editor_mode_switcher.dart';
import 'package:garna/screens/editor/widgets/filter_button.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:image/image.dart' as imageLib;

class EditorScreen extends StatefulWidget {
  final Asset asset;
  const EditorScreen({Key key, this.asset}) : super(key: key);

  static const String id = '/editor';

  @override
  _EditorScreenState createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  final _editorBloc = EditorBloc();
  final _names = [
    'Корректировка',
    'Контраст',
    'Экспозиция',
    'Насыщенность',
    'Баланс белого'
  ];
  final _icons = [
    GarnaAppIcons.cut,
    GarnaAppIcons.contrast,
    GarnaAppIcons.exposition,
    GarnaAppIcons.satturation,
    GarnaAppIcons.whitebalance
  ];

  @override
  void initState() {
    super.initState();

    _editorBloc.add(EdInitEvent(widget.asset));
  }

  @override
  void dispose() {
    _editorBloc.pageController.dispose();
    _editorBloc.close();
    super.dispose();
  }

  void _onFilterSelect(int index) {
    _editorBloc.add(EdChangeActiveFilterEvent(index));
  }

  void _onFilterSliderChanged(double value) {
   _editorBloc.add(EdChangeSlideFilterEvent(value));
  }
  
   void _onFilterSliderEnd(double value) {
   _editorBloc.add(EdEndSlideFilterEvent(value));
  }

  Widget _buildButtons() {
    return Flexible(
      fit: FlexFit.loose,
      child: BlocBuilder<EditorBloc, EditorState>(
        buildWhen: (previous, current) => current is EdChangeActiveFilterState,
        builder: (context, state) {
          int currentIndex = 0;
          if (state is EdChangeActiveFilterState) {
            currentIndex = state.index;
          }
          return ListView(
            scrollDirection: Axis.horizontal,
            children: List.generate(_names.length, 
              (index) => EditButtonWidget(
                icon: _icons[index],
                title: _names[index],
                selected: currentIndex == index,
                onPressed: ()=> _onFilterSelect(index),
              ),
            )
          );
        }
      )
    );
  }

   Widget _buildSlider() {
    return BlocBuilder<EditorBloc, EditorState>(
      buildWhen: (previous, current) => current is EdChangeSlideFilterState,
      builder: (context, state) {
        final min = _editorBloc.filterLimits[_editorBloc.index - 1][0];
        final max = _editorBloc.filterLimits[_editorBloc.index - 1][1];
        double value = (max + min) * 0.5;
        if (state is EdChangeSlideFilterState) {
          value = state.value;
        }
        return Slider(
          value: value,
          min: min,
          max: max,
          onChanged: _onFilterSliderChanged,
          onChangeEnd: _onFilterSliderEnd,
        );
      }
    );
  }


  Widget _buildFilter() {
    return BlocBuilder<EditorBloc, EditorState>(
      buildWhen: (previous, current) => current is EdChangeActiveFilterState,
      builder: (context, state) {
        if (state is EdChangeActiveFilterState && state.index > 0) {
         return _buildSlider();
        } else {
          return Container();
        }
      }
    );
  }

  Widget _buildImage() {
    // return FutureBuilder(
    //   future: _editorBloc.image,
    //   builder: (BuildContext context, AsyncSnapshot<Uint8List> snapshot) {
    //     if (snapshot.hasData) {
    //       return Expanded(
    //         flex: 6,
    //         child: FittedBox(
    //           fit: BoxFit.contain,
    //           child: ConstrainedBox(
    //             constraints: const BoxConstraints(minWidth: 1, minHeight: 1),
    //             child: Image(
    //               gaplessPlayback: true,
    //               image: MemoryImage(snapshot.data)
    //             )
    //           )
    //         )
    //       );     
    //     } else {
    //       return Container();
    //     }
    //   }
    // );
    return BlocBuilder<EditorBloc, EditorState>(
      buildWhen: (previous, current) => current is EdImageState,
      builder: (context, state) {
        if (state is EdImageState) {
          return Expanded(
            flex: 6,
            child: FittedBox(
              fit: BoxFit.contain,
              child: ConstrainedBox(
                constraints: const BoxConstraints(minWidth: 1, minHeight: 1),
                child: Image(
                  gaplessPlayback: true,
                  image: MemoryImage(state.image)
                )
              )
            )
          );     
        } else {
          return Expanded(
            flex: 6,
            child: Center(
              child: CircularProgressIndicator(),
            )
          );
        }
      }
    );
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
                      margin: const EdgeInsets.all(Constants.standardPaddingDouble / 2),
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
                _buildImage(),
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
                                          color: Colors.amber.withOpacity(index / 10),
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
                                _buildButtons(),
                                // Row(
                                //   mainAxisAlignment:
                                //       MainAxisAlignment.spaceAround,
                                //   children: [
                                //     CustomTextButton(
                                //       isActive: true,
                                //       onPressed: () {},
                                //       title: 'Выравнивание',
                                //     ),
                                //     CustomTextButton(
                                //       isActive: false,
                                //       onPressed: () {},
                                //       title: 'Наклон',
                                //     ),
                                //   ],
                                // ),
                                // Row(
                                //   mainAxisAlignment: MainAxisAlignment.center,
                                //   children: [
                                //     CustomMaterialButton(
                                //       color: Colors.transparent,
                                //       padding:
                                //           Constants.standardPaddingDouble / 2,
                                //       margin: EdgeInsets.zero,
                                //       child: Container(
                                //         width: 16,
                                //         height: 24,
                                //         decoration: BoxDecoration(
                                //           border: Border.all(
                                //             color:
                                //                 Theme.of(context).dividerColor,
                                //           ),
                                //         ),
                                //       ),
                                //       onPressed: () {},
                                //     ),
                                //     const SizedBox(
                                //       width: Constants.standardPaddingDouble,
                                //     ),
                                //     CustomMaterialButton(
                                //       color: Colors.transparent,
                                //       padding:
                                //           Constants.standardPaddingDouble / 2,
                                //       margin: EdgeInsets.zero,
                                //       child: Container(
                                //         width: 24,
                                //         height: 16,
                                //         decoration: BoxDecoration(
                                //           border: Border.all(
                                //             color:
                                //                 Theme.of(context).dividerColor,
                                //           ),
                                //         ),
                                //       ),
                                //       onPressed: () {},
                                //     ),
                                //   ],
                                // ),
                                _buildFilter()
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
