import 'package:flutter/material.dart';
import 'package:garna/global/constants.dart';
import 'package:garna/global/widgets/custom_material_button.dart';

class FilterButtonWidget extends StatelessWidget {
  final Widget child;
  final String title;
  final Function onPressed;
  const FilterButtonWidget({
    Key key,
    @required this.child,
    @required this.title,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 6),
      width: 72,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            fit: FlexFit.loose,
            child: Text(
              title,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: TextStyle(
                  color: Theme.of(context).primaryColorLight, fontSize: 10),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(
                vertical: Constants.standardPaddingDouble / 2),
            height: 72,
            // ),
            child: ClipRRect(
              borderRadius: Constants.standardBorderRadius,
              child: CustomMaterialButton(
                color: Colors.transparent,
                onPressed: onPressed,
                margin: EdgeInsets.zero,
                padding: 0,
                child: child,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
