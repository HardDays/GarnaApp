import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garna/screens/app_gallery/bloc/app_gallery_bloc.dart';

import '../../../global/constants.dart';

class CustomSnackBarWidget extends StatefulWidget {
  CustomSnackBarWidget({Key key}) : super(key: key);

  @override
  _CustomSnackBarWidgetState createState() => _CustomSnackBarWidgetState();
}

class _CustomSnackBarWidgetState extends State<CustomSnackBarWidget> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<AppGalleryBloc>(context)
        .where((state) =>
            state is AppGalShowSnackbarState ||
            state is AppGalCloseSnackbarState)
        .listen((st) {
      if (st is AppGalShowSnackbarState) {
        message = st.message;
        isActive = true;
      } else {
        isActive = false;
      }
      setState(() {});
    });
  }

  bool isActive = false;
  String message = '';
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragEnd: (details) {
        BlocProvider.of<AppGalleryBloc>(context)
            .add(AppGalCloseSnackbarEvent());
      },
      child: AnimatedContainer(
        duration: Constants.standardAnimationDuration,
        curve: Curves.linear,
        height: isActive ? 48 : 0,
        child: Container(
          alignment: Alignment.center,
          padding: Constants.standardPadding,
          color: Theme.of(context).accentColor,
          child: Text(
            message,
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).primaryColorLight,
            ),
          ),
        ),
      ),
    );
  }
}
