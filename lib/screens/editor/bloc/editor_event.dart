part of 'editor_bloc.dart';

abstract class EditorEvent extends Equatable {
  const EditorEvent();

  @override
  List<Object> get props => [];
}

class EdChangeActiveFilterEvent extends EditorEvent {
  final int index;

  EdChangeActiveFilterEvent(this.index);

  @override
  List<Object> get props => [index];
}


class EdReturnImageEvent extends EditorEvent {
  final Uint8List image;

  EdReturnImageEvent(this.image);

  @override
  List<Object> get props => [image.hashCode];
}

class EdChangeSlideFilterEvent extends EditorEvent {
  final double value;

  EdChangeSlideFilterEvent(this.value);

  @override
  List<Object> get props => [value];
}

class EdEndSlideFilterEvent extends EditorEvent {
  final double value;

  EdEndSlideFilterEvent(this.value);

  @override
  List<Object> get props => [value];
}

class EdInitEvent extends EditorEvent {
  final Asset image;

  EdInitEvent(this.image);

  @override
  List<Object> get props => [image.hashCode];
}