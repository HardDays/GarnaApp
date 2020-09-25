part of 'editor_bloc.dart';

abstract class EditorState extends Equatable {
  const EditorState();

  @override
  List<Object> get props => [];
}

class EditorInitial extends EditorState {}

class EdChangeActiveFilterState extends EditorState {
  final String id;

  EdChangeActiveFilterState(this.id);

  @override
  List<Object> get props => [id];
}

class EdChangeBottomPanelHeightState extends EditorState {
  final double height;

  EdChangeBottomPanelHeightState(this.height);

  @override
  List<Object> get props => [height];
}

class EdShowOrHideFrameButtonState extends EditorState {
  final bool show;

  EdShowOrHideFrameButtonState(this.show);

  @override
  List<Object> get props => [show];
}

class EdEndEditingState extends EditorState {}

class EdResumeEditingSate extends EditorState {}
