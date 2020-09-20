import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:garna/global/constants.dart';
import 'package:garna/global/utilities/garna_app_icons.dart';

class BottomGalleryMenuWidget extends StatelessWidget {
  const BottomGalleryMenuWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget buildCupertinoActionSheetItem(String text) {
      return Padding(
        padding: Constants.standardPadding,
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 16),
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        BottomGalleryMenuItemWidget(
          onPressed: () {},
          icon: GarnaAppIcons.cancel,
          title: 'Отмена',
        ),
        BottomGalleryMenuItemWidget(
          onPressed: () {},
          icon: GarnaAppIcons.icedit,
          title: 'Редактировать',
        ),
        BottomGalleryMenuItemWidget(
          onPressed: () => showModalBottomSheet(
            context: context,
            builder: (context) => CupertinoActionSheet(
              message: const Text('Действия'),
              cancelButton: CupertinoActionSheetAction(
                  // isDestructiveAction: true,
                  onPressed: () {},
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
                // buildCupertinoActionSheetItem('Сохранить в фотопленку'),
                // buildCupertinoActionSheetItem('Скопировать правки'),
                // buildCupertinoActionSheetItem('Удалить'),
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
      child: Padding(
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
