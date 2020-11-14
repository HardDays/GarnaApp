import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garna/global/constants.dart';
import 'package:garna/global/utilities/garna_app_icons.dart';
import 'package:garna/global/widgets/custom_material_button.dart';
import 'package:garna/main.dart';
import 'package:garna/screens/editor/bloc/editor_bloc.dart';
import 'package:garna/screens/editor/widgets/crop_grid_widget.dart';
import 'package:garna/screens/editor/widgets/custom_image_slider.dart';
import 'package:garna/screens/editor/widgets/custom_slider.dart';
import 'package:garna/screens/editor/widgets/custom_text_button.dart';
import 'package:garna/screens/editor/widgets/edit_button_widget.dart';
import 'package:garna/screens/editor/widgets/editor_mode_switcher.dart';
import 'package:garna/screens/editor/widgets/filter_button.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:vector_math/vector_math_64.dart' as vm;
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

  double _closeValue(double from, double to, double value) {
    final dx = (to - from) / 4;
    final eps = (to - from) / 40;
    for (double i = from; i < to; i += dx) {
      if ((value - i).abs() < eps) {
        return i;
      }
    } 
    return value;
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

  void _onAlignVerticalChanged(bool value) {
    _editorBloc.add(EdChangeAlignVerticalEvent(value));
  }

  void _onAlignModeChanged(bool value) {
    _editorBloc.add(EdChangeAlignModeEvent(value));
  }

  void _onAngleChanged(double value) {
    _editorBloc.add(EdChangeAngleEvent(_closeValue(-3.14, 3.14, value)));
  }

  void _onSkewXChanged(double value) {
     _editorBloc.add(EdChangeSkewXEvent(_closeValue(-1, 1, value)));
  }

  void _onSkewYChanged(double value) {
    _editorBloc.add(EdChangeSkewYEvent(_closeValue(-1, 1, value)));
  }

  Widget _buildButtons() {
    final names = [
      'Корректировка',
      'Контраст',
      'Экспозиция',
      'Насыщенность',
      'Баланс белого'
    ];
    final icons = [
      GarnaAppIcons.cut,
      GarnaAppIcons.contrast,
      GarnaAppIcons.exposition,
      GarnaAppIcons.satturation,
      GarnaAppIcons.whitebalance
    ];
    return Container(
      height: 90,
      margin: const EdgeInsets.only(top: 10),
      child: BlocBuilder<EditorBloc, EditorState>(
        buildWhen: (previous, current) => current is EdChangeActiveFilterState,
        builder: (context, state) {
          int currentIndex = 0;
          if (state is EdChangeActiveFilterState) {
            currentIndex = state.index;
          }
          return ListView(
            scrollDirection: Axis.horizontal,
            children: List.generate(names.length, 
              (index) => EditButtonWidget(
                icon: icons[index],
                title: names[index],
                selected: currentIndex == index,
                onPressed: ()=> _onFilterSelect(index),
              ),
            )
          );
        }
      )
    );
  }

  Widget _buildFilter() {
    return BlocBuilder<EditorBloc, EditorState>(
      buildWhen: (previous, current) => current is EdChangeSlideFilterState,
      builder: (context, state) {
        final min = _editorBloc.limits[0]; 
        final max = _editorBloc.limits[1];
        double value = (max + min) * 0.5;
        if (state is EdChangeSlideFilterState) {
          value = state.value;
        }
        return Expanded(
          child: Slider(
            value: value,
            min: min,
            max: max,
            onChanged: _onFilterSliderChanged,
            onChangeEnd: _onFilterSliderEnd,
          )
        );
      }
    );
  }

  Widget _buildAlign() {
    final names = ['Оригинал', '1:1', '2:3', '3:4', '4:5', '9:16'];
    return Column(
      children: [
        BlocBuilder<EditorBloc, EditorState>(
          buildWhen: (previous, current) => current is EdImageTransformState,
          builder: (context, transformState) {
            double angle = 0;
            if (transformState is EdImageTransformState) {
              angle = transformState.angle;
            }
            return SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackShape: ImageSliderTrackShape(),
                thumbShape: ImageSliderThumbShape(),
                overlayColor: Colors.transparent,
              ),
              child: Slider(
                value: angle,
                min: -3.14,
                max: 3.14,
                onChanged: _onAngleChanged,
              )
            );
          }
        ),
        BlocBuilder<EditorBloc, EditorState>(
          buildWhen: (previous, current) => current is EdAlignVerticalState,
          builder: (context, state) {
            bool value = true;
            if (state is EdAlignVerticalState) {
              value = state.value;
            }
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomMaterialButton(
                  color: Colors.transparent,
                  padding: Constants.standardPaddingDouble / 2,
                  margin: EdgeInsets.zero,
                  child: Container(
                    width: 16,
                    height: 24,
                    decoration: BoxDecoration(
                      color: value ? Theme.of(context).accentColor : Colors.transparent,
                      border: Border.all(
                        color: value ? Theme.of(context).accentColor : Theme.of(context).dividerColor,
                      ),
                    ),
                  ),
                  onPressed: ()=> _onAlignVerticalChanged(true),
                ),
                const SizedBox(
                  width: Constants.standardPaddingDouble,
                ),
                CustomMaterialButton(
                  color: Colors.transparent,
                  padding: Constants.standardPaddingDouble / 2,
                  margin: EdgeInsets.zero,
                  child: Container(
                    width: 24,
                    height: 16,
                    decoration: BoxDecoration(
                      color: !value ? Theme.of(context).accentColor : Colors.transparent,
                      border: Border.all(
                        color: !value ? Theme.of(context).accentColor : Theme.of(context).dividerColor,
                      ),
                    ),
                  ),
                  onPressed: ()=> _onAlignVerticalChanged(false),
                ),
              ],
            );
          }
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,  
          children: List.generate(names.length, 
            (index) => Padding(
              padding: const EdgeInsets.only(left: 5, right: 5),
              child: CustomTextButton(
                title: names[index],
                isActive: false,
                onPressed: () {},
              )
            )
          )
        )
      ],
    );
  } 

  Widget _buildSkew() {
    return BlocBuilder<EditorBloc, EditorState>(
      buildWhen: (previous, current) => current is EdImageTransformState,
      builder: (context, transformState) {
        double skewX = 0;
        double skewY = 0;
        if (transformState is EdImageTransformState) {
          skewX = transformState.skewX;
          skewY = transformState.skewY;
        }
        return Column(
          children: [
            Stack(
              alignment: Alignment.centerLeft,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 40),
                  child: Text('x',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12
                    ),
                  ),
                ),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackShape: ImageSliderTrackShape(),
                    thumbShape: ImageSliderThumbShape(),
                    overlayColor: Colors.transparent,
                  ),
                  child: Slider(
                    value: skewX,
                    min: -1,
                    max: 1,
                    onChanged: _onSkewXChanged,
                  )
                )
                
              ]
            ),
            Stack(
              alignment: Alignment.centerLeft,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 40),
                  child: Text('y',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12
                    ),
                  ),
                ),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackShape: ImageSliderTrackShape(),
                    thumbShape: ImageSliderThumbShape(),
                    overlayColor: Colors.transparent,
                  ),
                  child: Slider(
                    value: skewY,
                    min: -1,
                    max: 1,
                    onChanged: _onSkewYChanged,
                  )
                ),
              ]
            ),
          ],
        );
      }
    );
  }

  Widget _buildCorrections() {
    return BlocBuilder<EditorBloc, EditorState>(
      buildWhen: (previous, current) => current is EdAlignModeState,
      builder: (context, state) {
        bool value = true;
        if (state is EdAlignModeState) {
          value = state.value;
        }
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CustomTextButton(
                  isActive: value,
                  onPressed: ()=> _onAlignModeChanged(true),
                  title: 'Выравнивание',
                ),
                CustomTextButton(
                  isActive: !value,
                  onPressed:  ()=> _onAlignModeChanged(false),
                  title: 'Наклон',
                ),
              ],
            ),
            value ? _buildAlign() : _buildSkew()
          ]
        );
      }
    );
  }

  Widget _buildControl() {
    return BlocBuilder<EditorBloc, EditorState>(
      buildWhen: (previous, current) => current is EdChangeActiveFilterState,
      builder: (context, state) {
        if (state is EdChangeActiveFilterState && state.index > 0) {
          return _buildFilter();
        } else {
          return _buildCorrections();
        }
      }
    );
  }
  
  Widget _buildImage(Uint8List image) {
    return  BlocBuilder<EditorBloc, EditorState>(
      buildWhen: (previous, current) => current is EdImageTransformState,
      builder: (context, transformState) {
        double angle = 0;
        double skewX = 0;
        double skewY = 0;
        if (transformState is EdImageTransformState) {
          angle = transformState.angle;
          skewX = transformState.skewX;
          skewY = transformState.skewY;
        }                  
        final scale = 1.0;//min(1.3, max(angle.abs() + 1, 1.0));
        return Padding(
          padding: const EdgeInsets.all(10),
          child: Transform(
            alignment: FractionalOffset.center,
            transform: Matrix4.identity()..rotateZ(angle)..rotateY(skewX)..rotateX(skewY)..scale(vm.Vector3(scale, scale, 1)),
            child: Image(
              gaplessPlayback: true,
              image: MemoryImage(image)
            )
          )
        );
      }
    );
  }

  Widget _buildCropGrid() {
    return Container(
      child: CropGridWidget()
    );
  }

  Widget _buildEditor() {
    return BlocBuilder<EditorBloc, EditorState>(
      buildWhen: (previous, current) => current is EdImageState,
      builder: (context, imageState) {
        if (imageState is EdImageState) {
          return Expanded(
            // child: FittedBox(
            //   fit: BoxFit.contain,
            //   child: ConstrainedBox(
            //     constraints: const BoxConstraints(minWidth: 1, minHeight: 1),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    _buildImage(imageState.image),
                    Positioned.fill(
                      child: _buildCropGrid() 
                    )
                  ]
              //   )
              // )
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
                      margin: const EdgeInsets.all(Constants.standardPaddingDouble / 2),
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
                _buildEditor(),
                Column(
                  children: [
                    EditorModeSwitcherWidget(
                      buttons: [
                        'Фильтры',
                        'Редактор',
                      ],
                      controller: _editorBloc.pageController,
                    ),
                    Container(
                      height: 260,
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
                              //const CustomSliderWidget(),
                            ],
                          ),
                          Column(
                            children: [
                              _buildButtons(),
                              _buildControl()
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
