import 'package:flutter/material.dart';
import 'package:garna/global/constants.dart';

class EmptyGalleryWidget extends StatelessWidget {
  const EmptyGalleryWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      // padding: const EdgeInsets.all(8.0),
      padding: const EdgeInsets.only(top: Constants.standardPaddingDouble),
      child: GridView.count(
        // shrinkWrap: true,
        crossAxisCount: 3,
        childAspectRatio: Constants.gridViewChildAspectRatio,
        // padding: EdgeInsets.all(4.0),
        children: List.generate(
          9,
          (index) => Container(
            margin: Constants.gridViewElementMargin,
            decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context).accentColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
