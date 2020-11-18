import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:bitmap/bitmap.dart';
import 'package:bitmap/transformations.dart' as bmp;
import 'package:flutter/cupertino.dart';
import 'package:vector_math/vector_math.dart' as vm;
import 'package:image/image.dart' as img;
import 'package:garna/models/photo.dart';
import 'package:get/get.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:path_provider/path_provider.dart';

// part 'editor_event.dart';
// part 'editor_state.dart';

enum FilterMode {
  exposure,
  contrast,
  saturation,
  whiteBalance,
  correction,
}

enum AlignMode {
  alignment,
  skew
}

enum AlignType {
  vertical,
  horizontal
}

Bitmap applyFilters(Map<String, dynamic> params) {
  final contrastBmp = bmp.contrast(params['bitmap'], params['contrast']);
  return bmp.adjustColor(contrastBmp, exposure: params['exposure'], saturation: params['saturation'], blacks: params['whiteBalance'].toInt());
}

Future<Bitmap> applyTransform(Map<String, dynamic> params) async {
  final bitmap = params['bitmap'] as Bitmap;
  final cropTopLeft = params['cropTopLeft'] as Offset;
  final cropBottomRight = params['cropBottomRight'] as Offset;


  // final image = img.Image.fromBytes(bitmap.width, bitmap.height, bitmap.content);

  // final rotated = img.copyRotate(image, vm.degrees(params['angle']));
  // print(rotated.width);
  // print(bitmap.width);
  // final topLeft = Offset(bitmap.width * cropTopLeft.dx, bitmap.height * cropTopLeft.dy);
  // final bottomRight = Offset(bitmap.width * cropBottomRight.dx, bitmap.height * cropBottomRight.dy);
  // final sizeCrop = bottomRight - topLeft;

  // final cropped = img.copyCrop(rotated, topLeft.dx.toInt(), topLeft.dy.toInt(), sizeCrop.dx.toInt(), sizeCrop.dy.toInt());

  // return Bitmap.fromHeadless(cropped.width, cropped.height, cropped.getBytes());

  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder);
  
  final completer = Completer<ui.Image>();
  ui.decodeImageFromList(bitmap.buildHeaded(), (image)=> completer.complete(image));
  final image = await completer.future;

  final topLeft = Offset(bitmap.width * cropTopLeft.dx, bitmap.height * cropTopLeft.dy);
  final bottomRight = Offset(bitmap.width * cropBottomRight.dx, bitmap.height * cropBottomRight.dy);
  
  final size = Offset(bitmap.width.toDouble(), bitmap.height.toDouble());
  final sizeCrop = bottomRight - topLeft;

  canvas.clipRect(Rect.fromPoints(topLeft, bottomRight));
  
  canvas.translate(size.dx * 0.5, size.dy * 0.5);
  canvas.rotate(params['angle']);
  canvas.translate(-size.dx * 0.5, -size.dy * 0.5);

  canvas.drawImage(image, Offset.zero, Paint());
  
  final picture = recorder.endRecording();
  final result = await picture.toImage(size.dx.toInt(), size.dy.toInt());

  // final recorderClip = ui.PictureRecorder();
  // final canvasClip = Canvas(recorderClip);

  // canvasClip.drawImageRect(result, Rect.fromPoints(topLeft, bottomRight), Rect.fromLTWH(0, 0, sizeCrop.dx, sizeCrop.dy), Paint());
  // final pictureClip = recorderClip.endRecording();
  // final resultClip = await pictureClip.toImage(sizeClip.dx.toInt(), sizeClip.dy.toInt());
  //final bytes = (await resultClip.toByteData()).buffer.asUint8List();
  // return Bitmap.fromHeadless(resultClip.width, resultClip.height, bytes);
  
  final imageRes = img.Image.fromBytes(result.width, result.height, (await result.toByteData()).buffer.asUint8List());
  final cropped = img.copyCrop(imageRes, topLeft.dx.toInt(), topLeft.dy.toInt(), sizeCrop.dx.toInt(), sizeCrop.dy.toInt());

  // final bytes = (await resultClip.toByteData()).buffer.asUint8List();
  return Bitmap.fromHeadless(cropped.width, cropped.height, cropped.getBytes());
}

Future<Uint8List> computeResult(Map<String, dynamic> params) async {
  final bitmap = params['bitmap'] as Bitmap; 
  
  final result = await applyTransform(params);
  params['bitmap'] = result;

  //final bytes = applyFilters(params).buildHeaded();
  return applyFilters(params).buildHeaded();
}

class EditorController extends GetxController { 

  // final originalMediumBitmap = Rx<Bitmap>();
  // final originalSmallBitmap = Rx<Bitmap>();

  Bitmap _originalMediumBitmap;
  Bitmap _originalSmallBitmap;

  Bitmap _mediumBitmap;
  Bitmap _smallBitmap;

  double _contrast = 1.0;
  double _exposure = 0.0;
  double _saturation = 1.0;
  double _whiteBalance = 0.0;
  double _angle = 0.0;
  Offset _cropTopLeft = Offset(0, 0);
  Offset _cropBottomRight = Offset(0, 0);

  final filterMode = FilterMode.correction.obs;
  final alignMode = AlignMode.alignment.obs;
  final alignType = AlignType.vertical.obs;

  final contrast = 1.0.obs;
  final exposure = 0.0.obs;
  final saturation = 1.0.obs;
  final whiteBalance = 0.0.obs;

  final angle = 0.0.obs;
  final skewX = 0.0.obs;
  final skewY = 0.0.obs;
  final cropTopLeft = Rx<Offset>();
  final cropBottomRight = Rx<Offset>();

  final mediumImage = Rx<Uint8List>();
  final smallImage = Rx<Uint8List>();

  Map<String, dynamic> _filterParams(Bitmap bitmap) {
    return {
      'contrast': _contrast,
      'whiteBalance': _whiteBalance,
      'exposure': _exposure,
      'saturation': _saturation,
      'bitmap': bitmap
    };
  }

  Map<String, dynamic> _transformParams(Bitmap bitmap) {
    return {
      'angle': _angle,
      'cropTopLeft': _cropTopLeft,
      'cropBottomRight': _cropBottomRight,
      'bitmap': bitmap
    };
  }

  Future _updateFilters() async {
    mediumImage.value = applyFilters(_filterParams(_mediumBitmap)).buildHeaded();
    await Future.delayed(Duration(milliseconds: 200));
    smallImage.value = null;
  }

  Future init(Photo photo) async {
    _contrast = photo.contrast;
    _exposure = photo.exposure;
    _whiteBalance = (photo.whiteBalance.toInt() << 16) + (photo.whiteBalance.toInt() << 8) + (photo.whiteBalance.toInt()).toDouble();
    _saturation = photo.saturation;
    _angle = photo.angle;
    _cropTopLeft = Offset(photo.cropLeftX, photo.cropTopY);
    _cropBottomRight = Offset(photo.cropRightX, photo.cropBottomY);

    contrast.value = _contrast;
    exposure.value = _exposure;
    whiteBalance.value = photo.whiteBalance;
    saturation.value = _saturation;
    angle.value = _angle;
    cropTopLeft.value = _cropTopLeft;
    cropBottomRight.value = _cropBottomRight;

    _originalMediumBitmap = await Bitmap.fromProvider(FileImage(File(photo.mediumPath)));
    _originalSmallBitmap = await Bitmap.fromProvider(FileImage(File(photo.smallPath)));

    _mediumBitmap = _originalMediumBitmap.cloneHeadless();
    _smallBitmap = _originalSmallBitmap.cloneHeadless();

    mediumImage.value = applyFilters(_filterParams(_mediumBitmap)).buildHeaded();
  }

  double closeValue(double from, double to, double value) {
    final dx = (to - from) / 4;
    final eps = (to - from) / 40;
    for (double i = from; i < to; i += dx) {
      if ((value - i).abs() < eps) {
        return i;
      }
    } 
    return value;
  }

  void applyContrast(double value, {bool small = true}) async {
    contrast.value = value;
    if (small) {
      final dv = (1.25 - 0.75) / 30;
      if ((value - _contrast).abs() > dv) {
        _contrast = value;
        smallImage.value = applyFilters(_filterParams(_smallBitmap)).buildHeaded();
      } 
    } else {
      _contrast = value;
      await _updateFilters();
    }
  }

  void applyExposure(double value, {bool small = true}) async {
    exposure.value = value;
    if (small) {
      final dv = (0.5 - -0.5) / 30;
      if ((value - _exposure).abs() > dv) {
        _exposure = value;
        smallImage.value = applyFilters(_filterParams(_smallBitmap)).buildHeaded();
      } 
    } else {
      _exposure = value;
      await _updateFilters();
    }
  }

  void applySaturation(double value, {bool small = true}) async {
    saturation.value = value;
    if (small) {
      final dv = (0.5 - -0.5) / 30;
      if ((value - _saturation).abs() > dv) {
        _saturation = value;
        mediumImage.value = applyFilters(_filterParams(_smallBitmap)).buildHeaded();
      } 
    } else {
      _saturation = value;
      await _updateFilters();
    }
  }

  void applyWhiteBalance(double value, {bool small = true}) async {
    whiteBalance.value = value;
    final blacks = (value.toInt() << 16) + (value.toInt() << 8) + (value.toInt());

    if (small) {
      final dv = (100.0) / 30;
      if ((blacks - _whiteBalance).abs() > dv) {
        _whiteBalance = blacks.toDouble();
        smallImage.value = applyFilters(_filterParams(_smallBitmap)).buildHeaded();
      } 
    } else {
      _whiteBalance = blacks.toDouble();
      await _updateFilters();
    }
  }

  Future setFilterMode(FilterMode value) async {
    if (filterMode.value != value) {
      if (filterMode.value == FilterMode.correction && value != FilterMode.correction) {
        mediumImage.value = null;
        filterMode.value = value;
        angle.value = 0;

        _smallBitmap = await applyTransform(_transformParams(_smallBitmap));
        smallImage.value = applyFilters(_filterParams(_smallBitmap)).buildHeaded();

        _mediumBitmap = await applyTransform(_transformParams(_mediumBitmap));
        mediumImage.value = applyFilters(_filterParams(_mediumBitmap)).buildHeaded();
        smallImage.value = null;
      } else if (value == FilterMode.correction) {
        mediumImage.value = null;
        await Future.delayed(Duration(milliseconds: 100));
        filterMode.value = value;
        angle.value = _angle;

        _smallBitmap = _originalSmallBitmap.cloneHeadless();
        _mediumBitmap = _originalMediumBitmap.cloneHeadless();

        mediumImage.value = applyFilters(_filterParams(_mediumBitmap)).buildHeaded();
      } else {
        filterMode.value = value;
      }
    }
  }

  void setCrop(Offset topLeft, Offset bottomRight) {
    _cropTopLeft = topLeft;
    _cropBottomRight = bottomRight;
    cropTopLeft.value = topLeft;
    cropBottomRight.value = bottomRight;
  }

  void rotate(double value) {
    _angle = closeValue(-3.14, 3.14, value);
    angle.value = _angle;
  }

  Future<Uint8List> result(String path) async {
    final bitmap = await Bitmap.fromProvider(FileImage(File(path)));
    final Map<String, dynamic> params = {};
    params.addAll(_filterParams(bitmap));
    params.addAll(_transformParams(bitmap));

    return await computeResult(params);
  }

  void close() {

  }
}








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

// Uint8List applyContrast(Map<String, dynamic> params) {
//   return bmp.contrast(params['bitmap'], params['rate']).buildHeaded();
// }

// Uint8List applyColor(Map<String, dynamic> params) {
//   return bmp.adjustColor(params['bitmap'], 
//     exposure: params['exposure'], 
//     saturation: params['saturation'],
//     blacks: params['blacks']
//   ).buildHeaded();
// }


// В пизду этот конченый фреймворк, используем нормальный getx

// class EditorBloc extends Bloc<EditorEvent, EditorState> {
//   EditorBloc() : super(EditorState());

//   final PageController _pageController = PageController();

//   //Uint8List _originalImage;
//   // Uint8List _compressedImage;
//   // Uint8List _imageBytes;
//   // bool _computing = false;
//   // CancelableOperation _compute;
//   //imageLib.Image _image;

//   Bitmap _originalMediumBitmap;
//   Bitmap _originalSmallBitmap;

//   Bitmap _mediumBitmap;
//   Bitmap _smallBitmap;

//   bool _alignMode = true;

//   double _angle = 0;
//   bool _verticalAlign = true;
//   int _aspectIndex = 0;
//   final aspectValues = [
//     [1, 1],
//     [2, 3],
//     [3, 4],
//     [4, 5],
//     [9, 16]
//   ];

//   double _skewX = 0;
//   double _skewY = 0;

//   int _filterIndex = 0;
//   final _filterValues = [
//     1.0,
//     0.0,
//     1.0,
//     0.0
//   ];
//   final _filterLimits = [
//     [0.75, 1.25],
//     [-0.5, 0.5],
//     [0.25, 1.75],
//     [0.0, 100.0]
//   ];

//   List<double> get limits => _filterLimits[_filterIndex - 1];

//   //PageController get pageController => _pageController;

//   void _saveFilters(Bitmap bitmap) {      
//     if (_filterIndex - 1 != 0) {
//       bmp.contrastCore(bitmap.content, _filterValues[0]);
//     }
//     double exposure;
//     if (_filterIndex - 1 != 1) {
//       exposure = _filterValues[1];
//     }
//     double saturation;
//     if (_filterIndex - 1 != 2) {
//       saturation = _filterValues[2];
//     }
//     int blacks;
//     if (_filterIndex - 1 != 3) {
//       final value = _filterValues[3].toInt();
//       blacks = (value << 16) + (value << 8) + (value);
//     }
   
//     bmp.adjustColorCore(bitmap.content, exposure: exposure, saturation: saturation, blacks: blacks);
//   }

//   void _saveTransformations() {

//   }

//   Stream<EditorState> _applyFilter(Bitmap bitmap) async *{
//     final value = _filterValues[_filterIndex - 1];
    
//     Uint8List bytes;
//     if (_filterIndex == 1) {
//       // final clone = _image.clone();
//       // imageLib.contrast(clone, value);
//       // bytes = imageLib.encodePng(clone);
//       bytes = bmp.contrast(bitmap, value).buildHeaded();
//       // if (!_computing) {
//       //   _computing = true;
//       //   _compute = CancelableOperation.fromFuture(
//       //     compute(applyContrast, {
//       //       'rate': value,
//       //       'bitmap': bitmap
//       //     }),
//       //   );
//       //   _compute.value.then((res){ 
//       //       _computing = false;
//       //       add(EdReturnImageEvent(res));
//       //     }
//       //   );
//       // }
//       // compute(applyContrast, {
//       //   'rate': value,
//       //   'bitmap': bitmap
//       // }).then(
//       //   (res)=> add(EdReturnImageEvent(res))
//       // );
//     } else if (_filterIndex == 2) {
//       bytes = bmp.adjustColor(bitmap, exposure: value).buildHeaded();
//     } else if (_filterIndex == 3) {
//       bytes = bmp.adjustColor(bitmap, saturation: value).buildHeaded();
//     } else if (_filterIndex == 4) {
//       final blacks = (value.toInt() << 16) + (value.toInt() << 8) + (value.toInt());
//       bytes = bmp.adjustColor(bitmap, blacks: blacks).buildHeaded();
//     }
//     if (bytes != null) {
//       yield EdImageState(bytes);
//     }
//   }

//   // final diff = (value - _filterValues[_index - 1]).abs();
//   // final timeDiff = DateTime.now().difference(_lastEdit).inMilliseconds;
//   // if (diff > 0.05 && timeDiff > 1000) {

//   //   yield EdChangeSlideFilterState(value);
//   //   _filterValues[_index - 1] = value;

//   //   final filter = ImageFilter(name: 'name');
//   //   filter.addSubFilter(BrightnessSubFilter(value - 0.5));
//   //   filter.apply(_imageBytes, _image.width, _image.height);
    
//   //   imageLib.Image image = imageLib.Image.fromBytes(_image.width, _image.height, _imageBytes);
//   //   yield EdImageState(imageLib.encodePng(image));
//   //   _imageBytes = _image.clone().getBytes();
//   //   _lastEdit = DateTime.now();
//   // } else {
//   //   yield EdChangeSlideFilterState(value);
//   // }


//   Future<File> _compress(String path, double targetWidth, double targetHeight) async {
//     final directory = await getApplicationDocumentsDirectory();
//     final tempPath = directory.path + '/' + path;
    
//     final props = await FlutterNativeImage.getImageProperties(tempPath);
//     final scaleW = props.width / targetWidth;
//     final scaleH = props.height / targetHeight;
//     final scale = max(1.0, min(scaleW, scaleH));
//     final width = props.width ~/ scale;
//     final height = props.height ~/ scale;

//     return await FlutterNativeImage.compressImage(tempPath, targetWidth: width, targetHeight: height);
//   }

//   @override
//   Stream<EditorState> mapEventToState(EditorEvent event) async* {
//     if (event is EdInitEvent) {
//       print(event.image.name);
//       final bdata = await event.image.getByteData(quality: 80);
//       final data = bdata.buffer.asUint8List();

//       final directory = await getApplicationDocumentsDirectory();
//       final originalPath = directory.path + '/original';

//       final tempFile = File(originalPath);
//       await tempFile.writeAsBytes(data);

//       final mediumFile = await _compress('original', 1024, 768);
//       yield EdImageState(await mediumFile.readAsBytes());
//       final smallFile = await _compress('original', 320, 240);

//       _mediumBitmap = await Bitmap.fromProvider(FileImage(mediumFile));
//       _smallBitmap = await Bitmap.fromProvider(FileImage(smallFile));
//       _originalMediumBitmap = _mediumBitmap.cloneHeadless();
//       _originalSmallBitmap = _smallBitmap.cloneHeadless();
//             //_image = imageLib.decodeImage(await smallFile.readAsBytes());
//     } else if (event is EdChangeActiveFilterEvent) {
//       _filterIndex = event.index;
//       if (event.index > 0) {
//         yield EdChangeActiveFilterState(event.index);
//         _mediumBitmap = _originalMediumBitmap.cloneHeadless();
//         _smallBitmap = _originalSmallBitmap.cloneHeadless();
//         _saveFilters(_smallBitmap);
//         _saveFilters(_mediumBitmap);
//         yield* _applyFilter(_mediumBitmap);
//         yield EdChangeSlideFilterState(_filterValues[_filterIndex - 1]);
//       } else {
//         yield EdChangeActiveFilterState(event.index);
//         yield EdAlignModeState(_alignMode);
//         await Future.delayed(Duration(milliseconds: 10));
//         yield EdAlignVerticalState(_verticalAlign);
//         await Future.delayed(Duration(milliseconds: 10));
//         yield EdImageTransformState(_angle, _skewX, _skewY);
//       }
//     } else if (event is EdChangeSlideFilterEvent) {
//       final min = limits[0];
//       final max = limits[1];
//       final dv = (max - min) / 30;
//       final diff = (event.value - _filterValues[_filterIndex - 1]).abs();
//        if (diff > dv) {
//         // if (_compute != null ) {
//         //   await _compute.cancel();
//         // }
//         _filterValues[_filterIndex - 1] = event.value;
//         yield EdChangeSlideFilterState(event.value);
//         yield* _applyFilter(_smallBitmap);
//        } else {
//         yield EdChangeSlideFilterState(event.value);
//       }
//     } else if (event is EdEndSlideFilterEvent) {
//       _filterValues[_filterIndex - 1] = event.value;
//        yield EdChangeSlideFilterState(_filterValues[_filterIndex - 1]);
//       yield* _applyFilter(_mediumBitmap);
//     } else if (event is EdChangeAngleEvent) {
//       _angle = event.angle;
//       yield EdImageTransformState(_angle, _skewX, _skewY);
//     } else if (event is EdChangeAlignModeEvent) {
//       _alignMode = event.value;
//       // flutter_bloc - кусок ебучего говна, который невозможно использовать
//       yield EdAlignModeState(event.value);
//       await Future.delayed(Duration(milliseconds: 10));
//       yield EdAlignVerticalState(_verticalAlign);
//       await Future.delayed(Duration(milliseconds: 10));
//       yield EdImageTransformState(_angle, _skewX, _skewY);
//     } else if (event is EdChangeAlignVerticalEvent) {
//       _verticalAlign = event.value;
//       yield EdAlignVerticalState(event.value);
//     } else if (event is EdChangeSkewXEvent) {
//       _skewX = event.value;
//       yield EdImageTransformState(_angle, _skewX, _skewY);
//     }  else if (event is EdChangeSkewYEvent) {
//       _skewY = event.value;
//       yield EdImageTransformState(_angle, _skewX, _skewY);
//     } else if (event is EdReturnImageEvent) {
//       yield EdImageState(event.image);
//     }
//   }

//   @override
//   Future<void> close() async {
//     // await Future.delayed(Duration.zero)
//     //     .then((value) => _pageController.dispose())
//     //     .whenComplete(() {});
//     return super.close();
//   }

//   // final List<EditButtonWidget> _editButtonsList = [
//   //   EditButtonWidget(
//   //     icon: GarnaAppIcons.cut,
//   //     title: 'Корректировка',
//   //     onPressed: () {},
//   //   ),
//   //   EditButtonWidget(
//   //     icon: GarnaAppIcons.contrast,
//   //     title: 'Контраст',
//   //     onPressed: () {},
//   //   ),
//   //   EditButtonWidget(
//   //     icon: GarnaAppIcons.exposition,
//   //     title: 'Экспозиция',
//   //     onPressed: () {},
//   //   ),
//   //   EditButtonWidget(
//   //     icon: GarnaAppIcons.satturation,
//   //     title: 'Насыщенность',
//   //     onPressed: () {},
//   //   ),
//   //   EditButtonWidget(
//   //     icon: GarnaAppIcons.whitebalance,
//   //     title: 'Баланс белого',
//   //     onPressed: () {},
//   //   ),
//   //   EditButtonWidget(
//   //     icon: GarnaAppIcons.lightAreas,
//   //     title: 'Светлые участки',
//   //     onPressed: () {},
//   //   ),
//   //   EditButtonWidget(
//   //     icon: GarnaAppIcons.shadows,
//   //     title: 'Тени',
//   //     onPressed: () {},
//   //   ),
//   //   EditButtonWidget(
//   //     icon: GarnaAppIcons.woodgraining,
//   //     title: 'Зернистость',
//   //     onPressed: () {},
//   //   ),
//   // ];
//   //List<EditButtonWidget> get editButtonList => _editButtonsList;
//   // String get selectedEditItem =>
//   //     _selectedEditItem ?? _editButtonsList.first.title;
// }
