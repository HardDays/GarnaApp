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
