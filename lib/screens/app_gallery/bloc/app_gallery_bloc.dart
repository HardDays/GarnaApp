
import 'dart:typed_data';
import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:gallery_saver/gallery_saver.dart';
import 'package:garna/models/photo.dart';
import 'package:garna/storage/photo_database.dart';
import 'package:path/path.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:uuid/uuid.dart';

class AppGalleryController extends GetxController {

  final _database = PhotoDatabase();
  final _uuid = Uuid();

  final photos = RxList<Photo>(null);
  final selectedIndex = RxInt(null);

  Future<String> _generateName(String prefix, String name) async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path + '/$prefix' + _uuid.v4() + name;
  }

  Future<File> _compress(String path, String preffix, double targetWidth, double targetHeight) async {    
    final props = await FlutterNativeImage.getImageProperties(path);
    final scaleW = props.width / targetWidth;
    final scaleH = props.height / targetHeight;
    final scale = max(1.0, min(scaleW, scaleH));
    final width = props.width ~/ scale;
    final height = props.height ~/ scale;

    final temp = await FlutterNativeImage.compressImage(path, targetWidth: width, targetHeight: height);
    final name = await _generateName(preffix, basename(path));
    return await temp.copy(name);
    
  }

  void init() async {
    await _database.init();
    final res = await _database.all();
    photos.assignAll(res);
  }

  Future addPhotos(List<Asset> assets) async {
    for (final asset in assets) {
      try {
        final bdata = await asset.getByteData(quality: 80);
        final data = bdata.buffer.asUint8List();

        final originalFile = File(await _generateName('original', asset.name));
        await originalFile.writeAsBytes(data);

        final mediumFile = await _compress(originalFile.path, 'medium', 1024, 768);
        final smallFile = await _compress(originalFile.path, 'small', 320, 240);
        final filteredSmall = await smallFile.copy(await _generateName('filtered_small', asset.name));
        final filteredOriginal = await originalFile.copy(await _generateName('filtered_original', asset.name));

        final photo = await _database.create(Photo.empty(originalFile.path, smallFile.path, mediumFile.path, filteredSmall.path, filteredOriginal.path));
        if (photo != null) {
          photos.add(photo);
        }
      } catch (ex) {
        print(ex);
      }
    }
  }

  Future copyPhoto() async {
    final current = photos.value[selectedIndex.value];
    
    final original = await _generateName('original_c', basename(current.originalPath));
    final medium = await _generateName('medium_c', basename(current.originalPath));
    final small = await _generateName('small_c', basename(current.originalPath));
    final filteredOriginal = await _generateName('filtered_original_c', basename(current.originalPath));
    final filteredSmall = await _generateName('filtered_small_c', basename(current.originalPath));

    await File(current.originalPath).copy(original);
    await File(current.mediumPath).copy(medium);
    await File(current.smallPath).copy(small);
    await File(current.filteredOriginalPath).copy(filteredOriginal);
    await File(current.filteredSmallPath).copy(filteredSmall);

    final copy = current.copy(
      isNew: true,
      originalPath: original,
      smallPath: small,
      mediumPath: medium,
      filteredOriginalPath: filteredOriginal,
      filteredSmallPath: filteredSmall
    );

    final photo = await _database.create(copy);
    if (photo != null) {
      photos.add(photo); 
    }
  }

  Future savePhoto() async {
    await GallerySaver.saveImage(photos.value[selectedIndex.value].filteredOriginalPath);
  }

  Future removePhoto() async {
    try {
      final photo = photos.value[selectedIndex.value];
      await File(photo.originalPath).delete();
      await File(photo.mediumPath).delete();
      await File(photo.smallPath).delete();
      await File(photo.filteredSmallPath).delete();
      await File(photo.filteredOriginalPath).delete();

      await _database.remove(photo);
      photos.removeAt(selectedIndex.value);
      selectedIndex.value = null;
    } catch (ex) {
    }
  }
}


// class AppGalleryBloc extends Bloc<AppGalleryEvent, AppGalleryState> {
//   AppGalleryBloc() : super(AppGalleryInitial()) {
//     init();
//   }

//   void init() {
//     _isSnackbarActiveStream.stream.listen((isActive) {
//       _isSnackbarActive = isActive;
//       if (!isActive && _snackbarQueue.isNotEmpty) {
//         Future.delayed(Constants.standardAnimationDuration).then((value) {
//           add(AppGalShowSnackbarEvent(_snackbarQueue.first));
//           _snackbarQueue.removeAt(0);
//         });
//       }
//     });
//   }

//   String _selectedAsset;
//   List<Asset> _assets = [];
//   List<Asset> get assets => _assets;
//   String get selectedAsset => _selectedAsset;

//   List<String> _snackbarQueue = [];
//   bool _isSnackbarActive = false;
//   Timer _snackbarTimer;
//   final StreamController<bool> _isSnackbarActiveStream =
//       StreamController<bool>()..add(false);

//   @override
//   Future<void> close() {
//     _snackbarTimer.cancel();
//     _isSnackbarActiveStream.close();
//     return super.close();
//   }

//   @override
//   Stream<AppGalleryState> mapEventToState(
//     AppGalleryEvent event,
//   ) async* {
//     if (event is AppGalLoadPhotosEvent) {
//       try {
//         await MultiImagePicker.pickImages(
//           // cupertinoOptions: CupertinoOptions(

//           // ),
//           materialOptions: const MaterialOptions(
//             actionBarColor: '#000000',
//             statusBarColor: '#000000',
//             actionBarTitle: 'Альбом',
//             selectCircleStrokeColor: '#9B712F',
//             selectionLimitReachedText: 'Больше выбрать нельзя',
//             allViewTitle: 'Все фото',
//           ),
//           cupertinoOptions: const CupertinoOptions(
//             backgroundColor: '#000000',
//             // selectionCharacter:
//           ),
//           maxImages: 10,
//         ).then((value) {
//           value.forEach((element) {
//             if (_assets.every((el) => el.identifier != element.identifier)) {
//               _assets.add(element);
//             }
//           });
//         });
//         yield AppGalUpdateAppGalleryState(
//             DateTime.now().millisecondsSinceEpoch);
//       } catch (e) {

//       }
//     } else if (event is AppGalSelectAssetEvent) {
//       _selectedAsset =
//           event.identifier == _selectedAsset ? null : event.identifier;
//       yield AppGalSelectedAssetState(DateTime.now().millisecondsSinceEpoch);
//     } else if (event is AppGalShowSnackbarEvent) {
//       if (!_isSnackbarActive) {
//         yield AppGalShowSnackbarState(event.message);
//         _isSnackbarActiveStream.sink.add(true);
//         _snackbarTimer = Timer(
//           Constants.customSnackbarDuration +
//               Constants.standardAnimationDuration,
//           () => add(AppGalCloseSnackbarEvent()),
//         );
//       } else {
//         _snackbarQueue.add(event.message);
//       }
//     } else if (event is AppGalCloseSnackbarEvent) {
//       _snackbarTimer.cancel();
//       if (_isSnackbarActive) {
//         _isSnackbarActiveStream.sink.add(false);
//       }
//       yield AppGalCloseSnackbarState();
//     }
//   }
// }
