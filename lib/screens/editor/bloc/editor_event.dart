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
