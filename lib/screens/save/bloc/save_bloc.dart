import 'dart:typed_data';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:garna/models/photo.dart';
import 'package:garna/storage/photo_database.dart';
import 'package:flutter/services.dart';

class SaveController {

  final _database = PhotoDatabase();

  Future save(Photo photo, Uint8List original, Uint8List small) async {
    final smallFile = File(photo.filteredSmallPath);
    await smallFile.writeAsBytes(small);

    final originalFile = File(photo.filteredOriginalPath);
    await originalFile.writeAsBytes(original);

    await _database.update(photo);

    PaintingBinding.instance.imageCache.clear();
  }

}