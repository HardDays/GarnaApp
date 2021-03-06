import 'package:flutter/material.dart';
import 'package:garna/screens/app_gallery/app_gallery.dart';
import 'package:garna/screens/editor/editor.dart';
import 'package:garna/screens/subscribe/subscribe.dart';

import 'global/constants.dart';

void main() {
  runApp(GarnaApp());
}

class GarnaApp extends StatelessWidget {
  GarnaApp({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Garna App',
      theme: Constants().appTheme,
      // initialRoute: SubscribeScreen.id,
      routes: {
        AppGalleryScreen.id: (context) => const AppGalleryScreen(),
        SubscribeScreen.id: (context) => const SubscribeScreen(),
        EditorScreen.id: (context) => EditorScreen(
              asset: ModalRoute.of(context).settings.arguments,
            ),
      },
      // home: ,
    );
  }
}
