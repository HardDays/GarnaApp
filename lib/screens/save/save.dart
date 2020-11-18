import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:garna/global/constants.dart';
import 'package:garna/global/widgets/custom_material_button.dart';
import 'package:garna/models/photo.dart';
import 'package:garna/screens/save/bloc/save_bloc.dart';
import 'package:get/get.dart';
import 'package:garna/screens/app_gallery/app_gallery.dart';


class SaveScreen extends StatefulWidget {
  final Photo photo;
  final Uint8List smallFiltered;
  final Uint8List originalFiltered;

  const SaveScreen({Key key, this.photo, this.smallFiltered, this.originalFiltered}) : super(key: key);

  static const String id = '/save';

  @override
  _SaveScreenState createState() => _SaveScreenState();
}

class _SaveScreenState extends State<SaveScreen> {

  final _controller = SaveController();
 
  @override
  void initState() {
    super.initState();

  }

  @override
  void dispose() {
    super.dispose();
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

  void _onCancel() {
    Get.offAll(AppGalleryScreen());
  }

  void _onSave() async {
    _showLoader();
    await _controller.save(widget.photo, widget.originalFiltered, widget.smallFiltered);
    Get.back();
    Get.offAll(AppGalleryScreen(), arguments: true);
    Get.rawSnackbar(
      message: 'Сохранено',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Constants.colorDarkGold,
    );
  }

  Widget _buildTopButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomMaterialButton(
          margin: const EdgeInsets.all(Constants.standardPaddingDouble / 2),
          padding: Constants.standardPaddingDouble / 2,
          onPressed: ()=> Get.back(),
          color: Colors.transparent,
          child: Text(
            'Отмена',
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).primaryColorLight,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImage() {
    return  InteractiveViewer(
      child: Image(
        gaplessPlayback: true,
        image: MemoryImage(widget.originalFiltered)
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            _buildTopButtons(),
            Container(
              width: Get.width,
              height: Get.height * 0.7,
              padding: Constants.standardPadding,
              child: _buildImage(),
            ),
            Spacer(),
            CustomMaterialButton(
              infiniteWidth: true,
              margin: const EdgeInsets.symmetric(horizontal: 52),
              child: Text('Сохранить',
                style: TextStyle(
                  color: Theme.of(context).primaryColorLight,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              onPressed: _onSave,
            ),
            InkWell(
              onTap: _onCancel,
              child: Padding(
                padding: Constants.standardPadding * 2,
                child: const Text('Отменить редактирование',
                  style: TextStyle(
                    color: Constants.colorLightGrey,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

