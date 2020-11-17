// part of 'editor_bloc.dart';

// class EditorState extends Equatable {

//   @override
//   List<Object> get props => [];
// }

// class EdImageState extends EditorState {
//   final Uint8List image;

//   EdImageState(this.image);

//   @override
//   List<Object> get props => [Random().nextInt(10000)];
// }

// class EdImageTransformState extends EditorState {
//   final double skewX;
//   final double skewY;
//   final double angle;

//   EdImageTransformState(this.angle, this.skewX, this.skewY);

//   @override
//   List<Object> get props => [angle, skewX, skewY];
// }



// // class EdBufferImageState extends EditorState {
// //   final Uint8List image;

// //   EdBufferImageState(this.image);

// //   @override
// //   List<Object> get props => [Random().nextInt(10000)];
// // }

// class EdChangeActiveFilterState extends EditorState {
//   final int index;
//   EdChangeActiveFilterState(this.index);

//   @override
//   List<Object> get props => [index];
// }

// class EdChangeSlideFilterState extends EditorState {
//   final double value;

//   EdChangeSlideFilterState(this.value);

//   @override
//   List<Object> get props => [value, min, max];
// }

// class EdAlignModeState extends EditorState {
//   final bool value;

//   EdAlignModeState(this.value);

//   @override
//   List<Object> get props => [value];
// }

// class EdAlignVerticalState extends EditorState {
//   final bool value;

//   EdAlignVerticalState(this.value);

//   @override
//   List<Object> get props => [value];
// }

// class EdAspectState extends EditorState {
//   final int from;
//   final int to;

//   EdAspectState(this.from, this.to);

//   @override
//   List<Object> get props => [from, to];
// }