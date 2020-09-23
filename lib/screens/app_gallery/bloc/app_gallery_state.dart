part of 'app_gallery_bloc.dart';

abstract class AppGalleryState extends Equatable {
  const AppGalleryState();

  @override
  List<Object> get props => [];
}

class AppGalleryInitial extends AppGalleryState {}

class AppGalUpdateAppGalleryState extends AppGalleryState {
  final int id;

  AppGalUpdateAppGalleryState(this.id);

  @override
  List<Object> get props => [id];
}

class AppGalSelectedAssetState extends AppGalleryState {
  final int id;

  AppGalSelectedAssetState(this.id);

  @override
  List<Object> get props => [id];
}

class AppGalShowSnackbarState extends AppGalleryState {
  final String message;

  AppGalShowSnackbarState(this.message);

  @override
  List<Object> get props => [message];
}

class AppGalCloseSnackbarState extends AppGalleryState {}
