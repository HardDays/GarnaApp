class Photo {

  final int id;
  final double contrast;
  final double exposure;
  final double whiteBalance;
  final double saturation;
  final double angle;
  final double cropLeftX;
  final double cropTopY;
  final double cropRightX;
  final double cropBottomY;
  final double skewX;
  final double skewY;
  final String originalPath;
  final String smallPath;
  final String mediumPath;
  final String filteredOriginalPath;
  final String filteredSmallPath;

  Photo({
    this.id,
    this.contrast = 1.0,
    this.exposure = 0.0,
    this.whiteBalance = 0.0,
    this.saturation = 1.0,
    this.angle = 0.0,
    this.cropLeftX = 0.0,
    this.cropTopY = 0.0,
    this.cropRightX = 1.0,
    this.cropBottomY = 1.0,
    this.skewX = 0.0,
    this.skewY = 0.0,
    this.originalPath,
    this.smallPath,
    this.mediumPath,
    this.filteredOriginalPath,
    this.filteredSmallPath
  });

  factory Photo.empty(String originalPath, String smallPath, String mediumPath, String filteredSmallPath, String filteredOriginalPath) {
    return Photo(
      originalPath: originalPath,
      smallPath: smallPath,
      mediumPath: mediumPath,
      filteredOriginalPath: filteredOriginalPath,
      filteredSmallPath: filteredSmallPath
    );
  }

  Photo copy({double contrast, double exposure, double whiteBalance, double saturation, double angle, double cropLeftX, double cropTopY, double cropRightX, double cropBottomY, double skewX, double skewY }) {
    return Photo(
      id: id,
      smallPath: smallPath,
      originalPath: originalPath,
      mediumPath: mediumPath,
      filteredOriginalPath: filteredOriginalPath,
      filteredSmallPath: filteredSmallPath,
      contrast: contrast ?? this.contrast,
      whiteBalance: whiteBalance ?? this.whiteBalance,
      exposure: exposure ?? this.exposure,
      saturation: saturation ?? this.saturation,
      angle: angle ?? this.angle,
      cropLeftX: cropLeftX ?? this.cropLeftX,
      cropTopY: cropTopY ?? this.cropTopY,
      cropRightX: cropRightX ?? this.cropRightX,
      cropBottomY: cropBottomY ?? this.cropBottomY,
      skewX: skewX ?? this.skewX,
      skewY: skewY ?? this.skewY,
    );
  }

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      id: json['id'],
      contrast: json['contrast'],
      exposure: json['exposure'],
      whiteBalance: json['whiteBalance'],
      saturation: json['saturation'],
      angle: json['angle'],
      cropLeftX: json['cropLeftX'],
      cropRightX: json['cropRightX'],
      cropBottomY: json['cropBottomY'],
      cropTopY: json['cropTopY'],
      skewX: json['skewX'],
      skewY: json['skewY'],
      originalPath: json['originalPath'],
      smallPath: json['smallPath'],
      mediumPath: json['mediumPath'],
      filteredOriginalPath: json['filteredOriginalPath'],
      filteredSmallPath: json['filteredSmallPath']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'contrast': contrast,
      'exposure': exposure,
      'whiteBalance': whiteBalance,
      'saturation': saturation,
      'angle': angle,
      'cropLeftX': cropLeftX,
      'cropTopY': cropTopY,
      'cropRightX': cropRightX,
      'cropBottomY': cropBottomY,
      'skewX': skewX,
      'skewY': skewY,
      'originalPath': originalPath,
      'smallPath': smallPath,
      'mediumPath': mediumPath,
      'filteredOriginalPath': filteredOriginalPath,
      'filteredSmallPath': filteredSmallPath,
    };
  }
  

}