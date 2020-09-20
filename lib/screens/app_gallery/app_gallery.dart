import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garna/global/constants.dart';
import 'package:garna/global/utilities/garna_app_icons.dart';
import 'package:garna/screens/app_gallery/widgets/app_gallery_photo.dart';
import 'package:garna/screens/app_gallery/widgets/bottom_gallery_menu.dart';
import 'package:garna/screens/app_gallery/widgets/empty_gallery.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import 'bloc/app_gallery_bloc.dart';

class AppGalleryScreen extends StatefulWidget {
  const AppGalleryScreen({Key key}) : super(key: key);

  static const String id = '/';

  @override
  _AppGalleryScreenState createState() => _AppGalleryScreenState();
}

class _AppGalleryScreenState extends State<AppGalleryScreen> {
  // List<Asset> images = List<Asset>();
  // String _error = 'No Error Dectected';

  // @override
  // void initState() {
  //   super.initState();
  // }

  // Widget buildGridView() {
  //   return GridView.count(
  //     crossAxisCount: 3,
  //     children: List.generate(images.length, (index) {
  //       Asset asset = images[index];
  //       return AssetThumb(
  //         asset: asset,
  //         width: 300,
  //         height: 300,
  //       );
  //     }),
  //   );
  // }

  // Future<void> loadAssets() async {
  //   List<Asset> resultList = List<Asset>();
  //   String error = 'No Error Dectected';

  //   try {
  //     resultList = await MultiImagePicker.pickImages(
  //       maxImages: 300,
  //       enableCamera: true,
  //       selectedAssets: images,
  //       cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
  //       materialOptions: MaterialOptions(
  //         actionBarColor: "#abcdef",
  //         actionBarTitle: "Example App",
  //         allViewTitle: "All Photos",
  //         useDetailsView: false,
  //         selectCircleStrokeColor: "#000000",
  //       ),
  //     );
  //   } on Exception catch (e) {
  //     error = e.toString();
  //   }

  //   // If the widget was removed from the tree while the asynchronous platform
  //   // message was in flight, we want to discard the reply rather than calling
  //   // setState to update our non-existent appearance.
  //   if (!mounted) return;

  //   setState(() {
  //     images = resultList;
  //     _error = error;
  //   });
  // }

  // @override
  // Widget build(BuildContext context) {
  //   return new MaterialApp(
  //     home: new Scaffold(
  //       appBar: new AppBar(
  //         title: const Text('Plugin example app'),
  //       ),
  //       body: Column(
  //         children: <Widget>[
  //           Center(child: Text('Error: $_error')),
  //           RaisedButton(
  //             child: Text("Pick images"),
  //             onPressed: loadAssets,
  //             // onPressed: () async {
  //             //   print(await Permission.camera.isGranted);
  //             // },
  //           ),
  //           Expanded(
  //             child: buildGridView(),
  //           )
  //         ],
  //       ),
  //     ),
  //   );
  // }

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
          child: Column(
            children: [
              Expanded(
                child: BlocBuilder<AppGalleryBloc, AppGalleryState>(
                  buildWhen: (previous, current) =>
                      current is AppGalUpdateAppGalleryState,
                  builder: (context, state) {
                    if (BlocProvider.of<AppGalleryBloc>(context)
                        .assets
                        .isEmpty) {
                      return const EmptyGalleryWidget();
                    }
                    return GridView.count(
                      crossAxisCount: 3,
                      childAspectRatio: Constants.gridViewChildAspectRatio,
                      children: _appGalleryBloc.assets
                          .map(
                            (e) => AppGalleryPhotoWidget(asset: e),
                          )
                          .cast<Widget>()
                          .toList(),
                    );
                  },
                ),
              ),
              BlocBuilder<AppGalleryBloc, AppGalleryState>(
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
              )
            ],
          ),
        ),
        // floatingActionButton:
        // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}
