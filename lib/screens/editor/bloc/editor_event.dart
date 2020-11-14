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

class EdChangeAngleEvent extends EditorEvent {
  final double angle;

  EdChangeAngleEvent(this.angle);

  @override
  List<Object> get props => [angle];
}

class EdChangeAlignModeEvent extends EditorEvent {
  final bool value;

  EdChangeAlignModeEvent(this.value);

  @override
  List<Object> get props => [value];
}

class EdChangeAlignVerticalEvent extends EditorEvent {
  final bool value;

  EdChangeAlignVerticalEvent(this.value);

  @override
  List<Object> get props => [value];
}

class EdChangeSkewXEvent extends EditorEvent {
  final double value;

  EdChangeSkewXEvent(this.value);

  @override
  List<Object> get props => [value];
}

class EdChangeSkewYEvent extends EditorEvent {
  final double value;

  EdChangeSkewYEvent(this.value);

  @override
  List<Object> get props => [value];
}

class EdChangeAspectEvent extends EditorEvent {
  final int index;

  EdChangeAspectEvent(this.index);

  @override
  List<Object> get props => [index];
}

class EdInitEvent extends EditorEvent {
  final Asset image;

  EdInitEvent(this.image);

  @override
  List<Object> get props => [image.hashCode];
}