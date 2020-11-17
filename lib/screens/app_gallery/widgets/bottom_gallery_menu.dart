
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:garna/global/constants.dart';


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
        width: 120,
        color: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: Theme.of(context).accentColor,
              size: 30,
            ),
            const SizedBox(
              height: Constants.standardPaddingDouble /2, 
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
