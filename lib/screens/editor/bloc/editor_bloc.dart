import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:garna/global/utilities/garna_app_icons.dart';
import 'package:garna/screens/editor/widgets/edit_button_widget.dart';

part 'editor_event.dart';
part 'editor_state.dart';

class EditorBloc extends Bloc<EditorEvent, EditorState> {
  EditorBloc() : super(EditorInitial());

  final PageController _pageController = PageController();

  PageController get pageController => _pageController;

  @override
  Future<void> close() async {
    // await Future.delayed(Duration.zero)
    //     .then((value) => _pageController.dispose())
    //     .whenComplete(() {});
    return super.close();
  }

  @override
  Stream<EditorState> mapEventToState(
    EditorEvent event,
  ) async* {
    if (event is EdChangeActiveFilterEvent) {
      _selectedEditItem = event.title;
      yield EdChangeActiveFilterState(_selectedEditItem);
    }
  }

  final List<EditButtonWidget> _editButtonsList = [
    EditButtonWidget(
      icon: GarnaAppIcons.cut,
      title: 'Корректировка',
      onPressed: () {},
    ),
    EditButtonWidget(
      icon: GarnaAppIcons.contrast,
      title: 'Контраст',
      onPressed: () {},
    ),
    EditButtonWidget(
      icon: GarnaAppIcons.exposition,
      title: 'Экспозиция',
      onPressed: () {},
    ),
    EditButtonWidget(
      icon: GarnaAppIcons.satturation,
      title: 'Насыщенность',
      onPressed: () {},
    ),
    EditButtonWidget(
      icon: GarnaAppIcons.whitebalance,
      title: 'Баланс белого',
      onPressed: () {},
    ),
    EditButtonWidget(
      icon: GarnaAppIcons.lightAreas,
      title: 'Светлые участки',
      onPressed: () {},
    ),
    EditButtonWidget(
      icon: GarnaAppIcons.shadows,
      title: 'Тени',
      onPressed: () {},
    ),
    EditButtonWidget(
      icon: GarnaAppIcons.woodgraining,
      title: 'Зернистость',
      onPressed: () {},
    ),
  ];
  List<EditButtonWidget> get editButtonList => _editButtonsList;

  String _selectedEditItem;
  String get selectedEditItem =>
      _selectedEditItem ?? _editButtonsList.first.title;
}
