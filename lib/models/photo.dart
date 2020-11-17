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
  final String originalImagePath;

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
    this.originalImagePath
  });

  factory Photo.empty(String path) {
    return Photo(
      originalImagePath: path
    );
  }

  Map<String, dynamic> toJson() {
    
  }

}