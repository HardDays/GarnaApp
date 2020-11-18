import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:garna/global/constants.dart';
import 'package:garna/global/utilities/garna_app_icons.dart';
import 'package:garna/models/photo.dart';
import 'package:garna/screens/app_gallery/widgets/app_gallery_photo.dart';
import 'package:garna/screens/app_gallery/widgets/bottom_gallery_menu.dart';
import 'package:garna/screens/app_gallery/widgets/custom_snackbar_widget.dart';
import 'package:garna/screens/app_gallery/widgets/empty_gallery.dart';
import 'package:garna/screens/editor/editor.dart';
import 'package:get/get.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

import 'bloc/app_gallery_bloc.dart';

class AppGalleryScreen extends StatefulWidget {
  const AppGalleryScreen({Key key}) : super(key: key);

  static const String id = '/';

  @override
  _AppGalleryScreenState createState() => _AppGalleryScreenState();
}

class _AppGalleryScreenState extends State<AppGalleryScreen> {

  final _galleryController = AppGalleryController();

  @override
  void initState() {
    super.initState();
    
    _galleryController.init();   
  }

  void _showLoader() {
    Get.dialog(
      Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
        )        
      )
    );
  }

  void _onAddPhoto() async {
    try {
      final res = await MultiImagePicker.pickImages(
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
      );
      _showLoader();
      await _galleryController.addPhotos(res);
      Get.back();
    } catch (ex) {
      Get.back();
    }
  }

  void _onSelectPhoto(int index) {
    if ( _galleryController.selectedIndex.value != index) {
      _galleryController.selectedIndex.value = index;
    } else {
      _galleryController.selectedIndex.value = null;
    }
  }

  void _onCancel() {
    _galleryController.selectedIndex.value = null;
  }

  void _onEdit() async {
    Get.to(
      EditorScreen(
        photo: _galleryController.photos[_galleryController.selectedIndex.value]
      )
    );
  }

  void _onMore() {
    Get.bottomSheet(
      CupertinoActionSheet(
        message: const Text('Действия'),
        cancelButton: CupertinoActionSheetAction(
            // isDestructiveAction: true,
        onPressed: ()=> Get.back(),
        child: const Text('Отмена')),
        actions: [
          CupertinoActionSheetAction(
            onPressed: _onSavePhoto,
            child: const Text('Сохранить в фотопленку'),
          ),
          CupertinoActionSheetAction(
            onPressed: _onCopyPhoto,
            child: const Text('Скопировать правки'),
          ),
          CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: _onRemovePhoto,
            child: const Text('Удалить'),
          ),
        ],
      ),
    );
  }

  void _onSavePhoto() {
    _galleryController.savePhoto();
    Get.back();
  }

  void _onCopyPhoto() async {
    Get.back();
    _showLoader();
    await _galleryController.copyPhoto();
    Get.back();
  }

  void _onRemovePhoto() {
    _galleryController.removePhoto();
    Get.back();
  }
  
  Widget _buildPhotos(List<Photo> photos) {
    return Padding(
      padding: const EdgeInsets.only(top: Constants.standardPaddingDouble),
      child: GridView.count(
        // shrinkWrap: true,
        crossAxisCount: 3,
        childAspectRatio: Constants.gridViewChildAspectRatio,
        children: List.generate(photos.length, 
          (index) {
            final photo = photos[index];
            return Container(
              margin: Constants.gridViewElementMargin,
              decoration: BoxDecoration(
                border: Border.all(
                  color: photo == null || _galleryController.selectedIndex.value == index ? Theme.of(context).accentColor : Colors.transparent
                ),
              ),
              child: photo != null ? 
              InkWell(
                onTap: ()=> _onSelectPhoto(index),
                child: Image(
                  fit: BoxFit.cover,
                  image: FileImage(File(photo.filteredSmallPath)),
                ),  
              ) : 
              Container(),
            );
          }
        )
      ),
    );    
  }

  Widget _buildGallery() {
    return Obx(
      () {
        final photos = _galleryController.photos.value;
        if (photos != null) {
          if (photos.isNotEmpty) {
            return _buildPhotos(photos);
          } else {
            return _buildPhotos(List.generate(9, (index) => null));
          }     
        } else {
          return const Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
            ),
          ); 
        }
      }
    );
  }

  Widget _buildActions() {
     return Obx(
      () {
        if (_galleryController.selectedIndex.value != null) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              BottomGalleryMenuItemWidget(
                onPressed: _onCancel,
                icon: GarnaAppIcons.cancel,
                title: 'Отмена',
              ),
              BottomGalleryMenuItemWidget(
                onPressed: _onEdit,
                icon: GarnaAppIcons.icedit,
                title: 'Редактировать',
              ),
              BottomGalleryMenuItemWidget(
                onPressed: _onMore,
                icon: GarnaAppIcons.icmore,
                title: 'Еще',
              ),
            ],
          );
        } else {
          return IconButton(
            iconSize: 35,
            icon: Icon(
              GarnaAppIcons.plus,
              color: Theme.of(context).accentColor,
            ),
            onPressed: _onAddPhoto
          );
        }             
      }         
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _buildGallery()
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        color: Colors.black,
        width: MediaQuery.of(context).size.width,
        height: 70,
        child: _buildActions(),
      )
    );
  }
}
