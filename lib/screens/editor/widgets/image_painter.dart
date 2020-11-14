import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';


class ImagePainter extends CustomPainter {

  final Uint8List image;

  ImagePainter(this.image);

  @override
  void paint(Canvas canvas, Size size) {
    //canvas.drawImage(ui.Image. , offset, paint)
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}