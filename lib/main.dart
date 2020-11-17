import 'package:flutter/material.dart';
import 'package:garna/screens/app_gallery/app_gallery.dart';
import 'package:garna/screens/editor/editor.dart';
import 'package:garna/screens/subscribe/subscribe.dart';
import 'package:get/get.dart';

import 'global/constants.dart';

void main() {
  runApp(GarnaApp());
}

class GarnaApp extends StatelessWidget {
  GarnaApp({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Garna App',
      theme: Constants().appTheme,
      // initialRoute: SubscribeScreen.id,
      routes: {
        AppGalleryScreen.id: (context) => const AppGalleryScreen(),
        SubscribeScreen.id: (context) => const SubscribeScreen(),
      },
      // home: ,
    );
  }
}
