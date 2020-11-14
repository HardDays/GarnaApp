import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:async/async.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:garna/global/utilities/garna_app_icons.dart';
import 'package:garna/screens/editor/widgets/edit_button_widget.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photofilters/filters/subfilters.dart';
import 'package:photofilters/photofilters.dart';
import 'package:photofilters/utils/image_filter_utils.dart';
import 'package:photofilters/filters/image_filters.dart';
import 'package:image/image.dart' as imageLib;
import 'package:bitmap/bitmap.dart';
import 'package:bitmap/transformations.dart' as bmp;

part 'editor_event.dart';
part 'editor_state.dart';

// List<int> applyFilter(Map<String, dynamic> params) {
//   //print('kek');
//   Filter filter = params["filter"];
//   imageLib.Image image = params["image"];
//   List<int> _bytes = image.getBytes();
//   if (filter != null) {
//     filter.apply(_bytes, image.width, image.height);
//   }
//   imageLib.Image _image = imageLib.Image.fromBytes(image.width, image.height, _bytes);
//  _bytes = imageLib.encodePng(_image);

//   return _bytes;
// }

Uint8List applyContrast(Map<String, dynamic> params) {
  return bmp.contrast(params['bitmap'], params['rate']).buildHeaded();
}

// Uint8List applyColor(Map<String, dynamic> params) {
//   return bmp.adjustColor(params['bitmap'], 
//     exposure: params['exposure'], 
//     saturation: params['saturation'],
//     blacks: params['blacks']
//   ).buildHeaded();
// }

class EditorBloc extends Bloc<EditorEvent, EditorState> {
  EditorBloc() : super(EditorState());

  final PageController _pageController = PageController();

  //Uint8List _originalImage;
  // Uint8List _compressedImage;
  // Uint8List _imageBytes;
  // bool _computing = false;
  // CancelableOperation _compute;
  //imageLib.Image _image;

  Bitmap _originalMediumBitmap;
  Bitmap _originalSmallBitmap;

  Bitmap _mediumBitmap;
  Bitmap _smallBitmap;

  bool _alignMode = true;

  double _angle = 0;
  bool _verticalAlign = true;
  int _aspectIndex = 0;
  final aspectValues = [
    [1, 1],
    [2, 3],
    [3, 4],
    [4, 5],
    [9, 16]
  ];

  double _skewX = 0;
  double _skewY = 0;

  int _filterIndex = 0;
  final _filterValues = [
    1.0,
    0.0,
    1.0,
    0.0
  ];
  final _filterLimits = [
    [0.75, 1.25],
    [-0.5, 0.5],
    [0.25, 1.75],
    [0.0, 100.0]
  ];

  List<double> get limits => _filterLimits[_filterIndex - 1];

  PageController get pageController => _pageController;

  void _saveFilters(Bitmap bitmap) {      
    if (_filterIndex - 1 != 0) {
      bmp.contrastCore(bitmap.content, _filterValues[0]);
    }
    double exposure;
    if (_filterIndex - 1 != 1) {
      exposure = _filterValues[1];
    }
    double saturation;
    if (_filterIndex - 1 != 2) {
      saturation = _filterValues[2];
    }
    int blacks;
    if (_filterIndex - 1 != 3) {
      final value = _filterValues[3].toInt();
      blacks = (value << 16) + (value << 8) + (value);
    }
   
    bmp.adjustColorCore(bitmap.content, exposure: exposure, saturation: saturation, blacks: blacks);
  }

  void _saveTransformations() {

  }

  Stream<EditorState> _applyFilter(Bitmap bitmap) async *{
    final value = _filterValues[_filterIndex - 1];
    
    Uint8List bytes;
    if (_filterIndex == 1) {
      // final clone = _image.clone();
      // imageLib.contrast(clone, value);
      // bytes = imageLib.encodePng(clone);
      bytes = bmp.contrast(bitmap, value).buildHeaded();
      // if (!_computing) {
      //   _computing = true;
      //   _compute = CancelableOperation.fromFuture(
      //     compute(applyContrast, {
      //       'rate': value,
      //       'bitmap': bitmap
      //     }),
      //   );
      //   _compute.value.then((res){ 
      //       _computing = false;
      //       add(EdReturnImageEvent(res));
      //     }
      //   );
      // }
      // compute(applyContrast, {
      //   'rate': value,
      //   'bitmap': bitmap
      // }).then(
      //   (res)=> add(EdReturnImageEvent(res))
      // );
    } else if (_filterIndex == 2) {
      bytes = bmp.adjustColor(bitmap, exposure: value).buildHeaded();
    } else if (_filterIndex == 3) {
      bytes = bmp.adjustColor(bitmap, saturation: value).buildHeaded();
    } else if (_filterIndex == 4) {
      final blacks = (value.toInt() << 16) + (value.toInt() << 8) + (value.toInt());
      bytes = bmp.adjustColor(bitmap, blacks: blacks).buildHeaded();
    }
    if (bytes != null) {
      yield EdImageState(bytes);
    }
  }

  // final diff = (value - _filterValues[_index - 1]).abs();
  // final timeDiff = DateTime.now().difference(_lastEdit).inMilliseconds;
  // if (diff > 0.05 && timeDiff > 1000) {

  //   yield EdChangeSlideFilterState(value);
  //   _filterValues[_index - 1] = value;

  //   final filter = ImageFilter(name: 'name');
  //   filter.addSubFilter(BrightnessSubFilter(value - 0.5));
  //   filter.apply(_imageBytes, _image.width, _image.height);
    
  //   imageLib.Image image = imageLib.Image.fromBytes(_image.width, _image.height, _imageBytes);
  //   yield EdImageState(imageLib.encodePng(image));
  //   _imageBytes = _image.clone().getBytes();
  //   _lastEdit = DateTime.now();
  // } else {
  //   yield EdChangeSlideFilterState(value);
  // }


  Future<File> _compress(String path, double targetWidth, double targetHeight) async {
    final directory = await getApplicationDocumentsDirectory();
    final tempPath = directory.path + '/' + path;
    
    final props = await FlutterNativeImage.getImageProperties(tempPath);
    final scaleW = props.width / targetWidth;
    final scaleH = props.height / targetHeight;
    final scale = max(1.0, min(scaleW, scaleH));
    final width = props.width ~/ scale;
    final height = props.height ~/ scale;

    return await FlutterNativeImage.compressImage(tempPath, targetWidth: width, targetHeight: height);
  }

  @override
  Stream<EditorState> mapEventToState(EditorEvent event) async* {
    if (event is EdInitEvent) {
      print(event.image.name);
      final bdata = await event.image.getByteData(quality: 80);
      final data = bdata.buffer.asUint8List();

      final directory = await getApplicationDocumentsDirectory();
      final originalPath = directory.path + '/original';

      final tempFile = File(originalPath);
      await tempFile.writeAsBytes(data);

      final mediumFile = await _compress('original', 1024, 768);
      yield EdImageState(await mediumFile.readAsBytes());
      final smallFile = await _compress('original', 320, 240);

      _mediumBitmap = await Bitmap.fromProvider(FileImage(mediumFile));
      _smallBitmap = await Bitmap.fromProvider(FileImage(smallFile));
      _originalMediumBitmap = _mediumBitmap.cloneHeadless();
      _originalSmallBitmap = _smallBitmap.cloneHeadless();
            //_image = imageLib.decodeImage(await smallFile.readAsBytes());
    } else if (event is EdChangeActiveFilterEvent) {
      _filterIndex = event.index;
      if (event.index > 0) {
        yield EdChangeActiveFilterState(event.index);
        _mediumBitmap = _originalMediumBitmap.cloneHeadless();
        _smallBitmap = _originalSmallBitmap.cloneHeadless();
        _saveFilters(_smallBitmap);
        _saveFilters(_mediumBitmap);
        yield* _applyFilter(_mediumBitmap);
        yield EdChangeSlideFilterState(_filterValues[_filterIndex - 1]);
      } else {
        yield EdChangeActiveFilterState(event.index);
        yield EdAlignModeState(_alignMode);
        await Future.delayed(Duration(milliseconds: 10));
        yield EdAlignVerticalState(_verticalAlign);
        await Future.delayed(Duration(milliseconds: 10));
        yield EdImageTransformState(_angle, _skewX, _skewY);
      }
    } else if (event is EdChangeSlideFilterEvent) {
      final min = limits[0];
      final max = limits[1];
      final dv = (max - min) / 30;
      final diff = (event.value - _filterValues[_filterIndex - 1]).abs();
       if (diff > dv) {
        // if (_compute != null ) {
        //   await _compute.cancel();
        // }
        _filterValues[_filterIndex - 1] = event.value;
        yield EdChangeSlideFilterState(event.value);
        yield* _applyFilter(_smallBitmap);
       } else {
        yield EdChangeSlideFilterState(event.value);
      }
    } else if (event is EdEndSlideFilterEvent) {
      _filterValues[_filterIndex - 1] = event.value;
       yield EdChangeSlideFilterState(_filterValues[_filterIndex - 1]);
      yield* _applyFilter(_mediumBitmap);
    } else if (event is EdChangeAngleEvent) {
      _angle = event.angle;
      yield EdImageTransformState(_angle, _skewX, _skewY);
    } else if (event is EdChangeAlignModeEvent) {
      _alignMode = event.value;
      // flutter_bloc - кусок ебучего говна, который невозможно использовать
      yield EdAlignModeState(event.value);
      await Future.delayed(Duration(milliseconds: 10));
      yield EdAlignVerticalState(_verticalAlign);
      await Future.delayed(Duration(milliseconds: 10));
      yield EdImageTransformState(_angle, _skewX, _skewY);
    } else if (event is EdChangeAlignVerticalEvent) {
      _verticalAlign = event.value;
      yield EdAlignVerticalState(event.value);
    } else if (event is EdChangeSkewXEvent) {
      _skewX = event.value;
      yield EdImageTransformState(_angle, _skewX, _skewY);
    }  else if (event is EdChangeSkewYEvent) {
      _skewY = event.value;
      yield EdImageTransformState(_angle, _skewX, _skewY);
    } else if (event is EdReturnImageEvent) {
      yield EdImageState(event.image);
    }
  }

  @override
  Future<void> close() async {
    // await Future.delayed(Duration.zero)
    //     .then((value) => _pageController.dispose())
    //     .whenComplete(() {});
    return super.close();
  }

  // final List<EditButtonWidget> _editButtonsList = [
  //   EditButtonWidget(
  //     icon: GarnaAppIcons.cut,
  //     title: 'Корректировка',
  //     onPressed: () {},
  //   ),
  //   EditButtonWidget(
  //     icon: GarnaAppIcons.contrast,
  //     title: 'Контраст',
  //     onPressed: () {},
  //   ),
  //   EditButtonWidget(
  //     icon: GarnaAppIcons.exposition,
  //     title: 'Экспозиция',
  //     onPressed: () {},
  //   ),
  //   EditButtonWidget(
  //     icon: GarnaAppIcons.satturation,
  //     title: 'Насыщенность',
  //     onPressed: () {},
  //   ),
  //   EditButtonWidget(
  //     icon: GarnaAppIcons.whitebalance,
  //     title: 'Баланс белого',
  //     onPressed: () {},
  //   ),
  //   EditButtonWidget(
  //     icon: GarnaAppIcons.lightAreas,
  //     title: 'Светлые участки',
  //     onPressed: () {},
  //   ),
  //   EditButtonWidget(
  //     icon: GarnaAppIcons.shadows,
  //     title: 'Тени',
  //     onPressed: () {},
  //   ),
  //   EditButtonWidget(
  //     icon: GarnaAppIcons.woodgraining,
  //     title: 'Зернистость',
  //     onPressed: () {},
  //   ),
  // ];
  //List<EditButtonWidget> get editButtonList => _editButtonsList;
  // String get selectedEditItem =>
  //     _selectedEditItem ?? _editButtonsList.first.title;
}
