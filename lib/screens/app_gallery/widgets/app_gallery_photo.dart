import 'package:flutter/material.dart';
import 'package:garna/global/constants.dart';
import 'package:garna/screens/app_gallery/bloc/app_gallery_bloc.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class AppGalleryPhotoWidget extends StatelessWidget {
  final Asset asset;
  const AppGalleryPhotoWidget({
    Key key,
    @required this.asset,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // onTap: () => BlocProvider.of<AppGalleryBloc>(context)
      //     .add(AppGalSelectAssetEvent(asset.identifier)),
      child: Stack(
        fit: StackFit.passthrough,
        children: [
          Container(
            margin: Constants.gridViewElementMargin,
            child: AssetThumb(
              asset: asset,
              width: 200,
              height: 200,
            ),
          ),
          // BlocBuilder<AppGalleryBloc, AppGalleryState>(
          //   buildWhen: (previous, current) =>
          //       current is AppGalSelectedAssetState,
          //   builder: (context, state) {
          //     return Container(
          //       margin: Constants.gridViewElementMargin,
          //       decoration: BoxDecoration(
          //         border:
          //             BlocProvider.of<AppGalleryBloc>(context).selectedAsset ==
          //                     asset.identifier
          //                 ? Border.all(color: Theme.of(context).accentColor)
          //                 : null,
          //       ),
          //     );
          //   },
          // ),
        ],
      ),
    );
  }
}
