import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:garna/global/constants.dart';
import 'package:garna/global/utilities/garna_app_icons.dart';
import 'package:garna/screens/app_gallery/bloc/app_gallery_bloc.dart';
import 'package:garna/screens/editor/editor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as imageLib;
import 'package:path/path.dart';

class BottomGalleryMenuWidget extends StatelessWidget {
  const BottomGalleryMenuWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        BottomGalleryMenuItemWidget(
          onPressed: () => BlocProvider.of<AppGalleryBloc>(context).add(
            AppGalSelectAssetEvent(
              BlocProvider.of<AppGalleryBloc>(context).selectedAsset,
            ),
          ),
          icon: GarnaAppIcons.cancel,
          title: 'Отмена',
        ),
        BottomGalleryMenuItemWidget(
          onPressed: () async {
            final asset = BlocProvider.of<AppGalleryBloc>(context).assets.firstWhere(
              (element) => element.identifier == BlocProvider.of<AppGalleryBloc>(context).selectedAsset
            );

            // showDialog(
            //   context: context, 
            //   child: Center(
            //     child: CircularProgressIndicator(strokeWidth: 1)
            //   )
            // );
            
            // final data = await asset.getByteData(quality: 80);
            // final bytes = data.buffer.asUint8List();

            // Navigator.pop(context);
            Navigator.of(context).pushNamed(EditorScreen.id, arguments: asset);
          },
          icon: GarnaAppIcons.icedit,
          title: 'Редактировать',
        ),
        BottomGalleryMenuItemWidget(
          onPressed: () => showModalBottomSheet(
            backgroundColor: Colors.transparent,
            context: context,
            builder: (context) => CupertinoActionSheet(
              message: const Text('Действия'),
              cancelButton: CupertinoActionSheetAction(
                  // isDestructiveAction: true,
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Отмена')),
              actions: [
                CupertinoActionSheetAction(
                  onPressed: () {},
                  child: const Text('Сохранить в фотопленку'),
                ),
                CupertinoActionSheetAction(
                  onPressed: () {},
                  child: const Text('Скопировать правки'),
                ),
                CupertinoActionSheetAction(
                  isDestructiveAction: true,
                  onPressed: () {},
                  child: const Text('Удалить'),
                ),
              ],
            ),
          ),
          icon: GarnaAppIcons.icmore,
          title: 'Еще',
        ),
      ],
    );
  }
}

class BottomGalleryMenuItemWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final Function onPressed;
  const BottomGalleryMenuItemWidget({
    Key key,
    @required this.icon,
    @required this.title,
    @required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        color: Colors.transparent,
        padding: Constants.standardPadding,
        child: Column(
          children: [
            Icon(
              icon,
              color: Theme.of(context).accentColor,
              size: 30,
            ),
            const SizedBox(
              height: Constants.standardPaddingDouble,
            ),
            Text(
              title,
              style: TextStyle(
                color: Theme.of(context).accentColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
