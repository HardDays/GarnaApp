import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garna/global/constants.dart';
import 'package:garna/global/utilities/garna_app_icons.dart';
import 'package:garna/screens/app_gallery/widgets/app_gallery_photo.dart';
import 'package:garna/screens/app_gallery/widgets/bottom_gallery_menu.dart';
import 'package:garna/screens/app_gallery/widgets/custom_snackbar_widget.dart';
import 'package:garna/screens/app_gallery/widgets/empty_gallery.dart';

import 'bloc/app_gallery_bloc.dart';

class AppGalleryScreen extends StatefulWidget {
  const AppGalleryScreen({Key key}) : super(key: key);

  static const String id = '/';

  @override
  _AppGalleryScreenState createState() => _AppGalleryScreenState();
}

class _AppGalleryScreenState extends State<AppGalleryScreen> {
  AppGalleryBloc _appGalleryBloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _appGalleryBloc ??= AppGalleryBloc();
  }

  @override
  void dispose() {
    _appGalleryBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _appGalleryBloc,
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              BlocBuilder<AppGalleryBloc, AppGalleryState>(
                buildWhen: (previous, current) =>
                    current is AppGalUpdateAppGalleryState,
                builder: (context, state) {
                  if (BlocProvider.of<AppGalleryBloc>(context).assets.isEmpty) {
                    return const EmptyGalleryWidget();
                    // return const SizedBox();
                  }
                  return Padding(
                    padding: const EdgeInsets.only(
                        top: Constants.standardPaddingDouble),
                    child: GridView.count(
                      // shrinkWrap: true,
                      crossAxisCount: 3,
                      childAspectRatio: Constants.gridViewChildAspectRatio,
                      children: _appGalleryBloc.assets
                          .map(
                            (e) => AppGalleryPhotoWidget(asset: e),
                          )
                          .cast<Widget>()
                          .toList(),
                    ),
                  );
                },
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: CustomSnackBarWidget(),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: BlocBuilder<AppGalleryBloc, AppGalleryState>(
                  buildWhen: (previous, current) =>
                      current is AppGalSelectedAssetState,
                  builder: (context, state) {
                    return _appGalleryBloc.selectedAsset == null
                        ? IconButton(
                            iconSize: 35,
                            icon: Icon(
                              GarnaAppIcons.plus,
                              color: Theme.of(context).accentColor,
                            ),
                            onPressed: () {
                              _appGalleryBloc.add(AppGalLoadPhotosEvent());
                            },
                          )
                        : const BottomGalleryMenuWidget();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
