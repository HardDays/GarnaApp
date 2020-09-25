part of 'editor_bloc.dart';

abstract class EditorEvent extends Equatable {
  const EditorEvent();

  @override
  List<Object> get props => [];
}

class EdChangeActiveFilterEvent extends EditorEvent {
  final String title;

  EdChangeActiveFilterEvent(this.title);

  @override
  List<Object> get props => [title];
}

class EdChangeBottomPanelHeightEvent extends EditorEvent {
  final double height;

  EdChangeBottomPanelHeightEvent(this.height);

  @override
  List<Object> get props => [height];
}

class EdShowOrHideFrameButtonEvent extends EditorEvent {
  final bool show;

  EdShowOrHideFrameButtonEvent(this.show);

  @override
  List<Object> get props => [show];
}

class EdEndEditingEvent extends EditorEvent {}

class EdResumeEditingEvent extends EditorEvent {}
