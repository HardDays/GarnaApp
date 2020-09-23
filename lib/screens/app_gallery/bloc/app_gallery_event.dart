part of 'app_gallery_bloc.dart';

abstract class AppGalleryEvent extends Equatable {
  const AppGalleryEvent();

  @override
  List<Object> get props => [];
}

class AppGalLoadPhotosEvent extends AppGalleryEvent {}

class AppGalCheckPermissionsEvent extends AppGalleryEvent {}

class AppGalSelectAssetEvent extends AppGalleryEvent {
  final String identifier;

  AppGalSelectAssetEvent(this.identifier);

  @override
  List<Object> get props => [identifier];
}

class AppGalShowSnackbarEvent extends AppGalleryEvent {
  final String message;

  AppGalShowSnackbarEvent(this.message);

  @override
  List<Object> get props => [message];
}

class AppGalCloseSnackbarEvent extends AppGalleryEvent {}
