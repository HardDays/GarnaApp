import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

part 'app_gallery_event.dart';
part 'app_gallery_state.dart';

class AppGalleryBloc extends Bloc<AppGalleryEvent, AppGalleryState> {
  AppGalleryBloc() : super(AppGalleryInitial());
  // {
  // _initAppGalleryBloc();
  // add(AppGalCheckPermissionsEvent());
  // }

  // Future<void> _initAppGalleryBloc() async {
  //   if (!await Permission.mediaLibrary.isGranted) {
  //     await Permission.mediaLibrary.request();
  //   }
  // }
  String _selectedAsset;

  List<Asset> _assets = [];

  List<Asset> get assets => _assets;
  String get selectedAsset => _selectedAsset;

  @override
  Stream<AppGalleryState> mapEventToState(
    AppGalleryEvent event,
  ) async* {
    // if (event is AppGalCheckPermissionsEvent) {
    //   if (!await Permission.mediaLibrary.isGranted) {
    //     await Permission.mediaLibrary.request().then((value) => print(value));
    //   }
    // } else
    if (event is AppGalLoadPhotosEvent) {
      await MultiImagePicker.pickImages(
        maxImages: 10,
      ).then((value) {
        value.forEach((element) {
          if (!_assets.contains(element)) {
            _assets.add(element);
          }
        });
      });
      yield AppGalUpdateAppGalleryState(DateTime.now().millisecondsSinceEpoch);
    } else if (event is AppGalSelectAssetEvent) {
      _selectedAsset =
          event.identifier == _selectedAsset ? null : event.identifier;
      yield AppGalSelectedAssetState(DateTime.now().millisecondsSinceEpoch);
    }
  }
}
