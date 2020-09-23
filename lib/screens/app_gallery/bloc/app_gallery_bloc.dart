import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:garna/global/constants.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

part 'app_gallery_event.dart';
part 'app_gallery_state.dart';

class AppGalleryBloc extends Bloc<AppGalleryEvent, AppGalleryState> {
  AppGalleryBloc() : super(AppGalleryInitial()) {
    init();
  }

  void init() {
    _isSnackbarActiveStream.stream.listen((isActive) {
      _isSnackbarActive = isActive;
      if (!isActive && _snackbarQueue.isNotEmpty) {
        Future.delayed(Constants.standardAnimationDuration).then((value) {
          add(AppGalShowSnackbarEvent(_snackbarQueue.first));
          _snackbarQueue.removeAt(0);
        });
      }
    });
  }

  String _selectedAsset;
  List<Asset> _assets = [];
  List<Asset> get assets => _assets;
  String get selectedAsset => _selectedAsset;

  List<String> _snackbarQueue = [];
  bool _isSnackbarActive = false;
  Timer _snackbarTimer;
  final StreamController<bool> _isSnackbarActiveStream =
      StreamController<bool>()..add(false);

  @override
  Future<void> close() {
    _snackbarTimer.cancel();
    _isSnackbarActiveStream.close();
    return super.close();
  }

  @override
  Stream<AppGalleryState> mapEventToState(
    AppGalleryEvent event,
  ) async* {
    if (event is AppGalLoadPhotosEvent) {
      try {
        await MultiImagePicker.pickImages(
          // cupertinoOptions: CupertinoOptions(

          // ),
          materialOptions: const MaterialOptions(
            actionBarColor: '#000000',
            statusBarColor: '#000000',
            actionBarTitle: 'Альбом',
            selectCircleStrokeColor: '#9B712F',
            selectionLimitReachedText: 'Больше выбрать нельзя',
            allViewTitle: 'Все фото',
          ),
          cupertinoOptions: const CupertinoOptions(
            backgroundColor: '#000000',
            // selectionCharacter:
          ),
          maxImages: 10,
        ).then((value) {
          value.forEach((element) {
            if (_assets.every((el) => el.identifier != element.identifier)) {
              _assets.add(element);
            }
          });
        });
        yield AppGalUpdateAppGalleryState(
            DateTime.now().millisecondsSinceEpoch);
      } catch (e) {}
    } else if (event is AppGalSelectAssetEvent) {
      _selectedAsset =
          event.identifier == _selectedAsset ? null : event.identifier;
      yield AppGalSelectedAssetState(DateTime.now().millisecondsSinceEpoch);
    } else if (event is AppGalShowSnackbarEvent) {
      if (!_isSnackbarActive) {
        yield AppGalShowSnackbarState(event.message);
        _isSnackbarActiveStream.sink.add(true);
        _snackbarTimer = Timer(
          Constants.customSnackbarDuration +
              Constants.standardAnimationDuration,
          () => add(AppGalCloseSnackbarEvent()),
        );
      } else {
        _snackbarQueue.add(event.message);
      }
    } else if (event is AppGalCloseSnackbarEvent) {
      _snackbarTimer.cancel();
      if (_isSnackbarActive) {
        _isSnackbarActiveStream.sink.add(false);
      }
      yield AppGalCloseSnackbarState();
    }
  }
}
