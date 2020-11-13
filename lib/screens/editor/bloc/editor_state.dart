part of 'editor_bloc.dart';

class EditorState extends Equatable {

  @override
  List<Object> get props => [];
}

class EdImageState extends EditorState {
  final Uint8List image;

  EdImageState(this.image);

  @override
  List<Object> get props => [Random().nextInt(10000)];
}

class EdBufferImageState extends EditorState {
  final Uint8List image;

  EdBufferImageState(this.image);

  @override
  List<Object> get props => [Random().nextInt(10000)];
}

class EdChangeActiveFilterState extends EditorState {
  final int index;
  EdChangeActiveFilterState(this.index);

  @override
  List<Object> get props => [index];
}

class EdChangeSlideFilterState extends EditorState {
  final double value;

  EdChangeSlideFilterState(this.value);

  @override
  List<Object> get props => [value];
}