import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:garna/global/utilities/garna_app_icons.dart';
import 'package:garna/screens/editor/widgets/edit_button_widget.dart';

part 'editor_event.dart';
part 'editor_state.dart';

class EditorBloc extends Bloc<EditorEvent, EditorState> {
  EditorBloc() : super(EditorInitial()) {
    _modePageController.addListener(() {
      final double ratio = _modePageController.offset /
          _modePageController.position.maxScrollExtent;
      if (ratio == 0.0 || ratio == 1.0) {
        if (ratio == 0.0) {
          add(EdChangeBottomPanelHeightEvent(200));
          add(EdShowOrHideFrameButtonEvent(false));
        } else {
          add(EdChangeBottomPanelHeightEvent(
              selectedEditItem == _editButtonsList.first.title ? 300 : 200));
          if (selectedEditItem == _editButtonsList.first.title) {
            add(EdShowOrHideFrameButtonEvent(true));
          }
        }
      }
    });
  }

  final PageController _modePageController = PageController();
  PageController get modePageController => _modePageController;

  final PageController _editModePageConstroller = PageController();
  PageController get editModePageController => _editModePageConstroller;

  // @override
  // Future<void> close() async {
  //   // await Future.delayed(Duration.zero)
  //   //     .then((value) => _pageController.dispose())
  //   //     .whenComplete(() {});
  //   return super.close();
  // }

  @override
  Stream<EditorState> mapEventToState(
    EditorEvent event,
  ) async* {
    if (event is EdChangeActiveFilterEvent) {
      yield EdChangeBottomPanelHeightState(
          event.title == _editButtonsList.first.title ? 300 : 200);
      if (event.title == _editButtonsList.first.title ||
          selectedEditItem == _editButtonsList.first.title) {
        yield EdShowOrHideFrameButtonState(
            event.title == _editButtonsList.first.title);
      }
      _selectedEditItem = event.title;
      yield EdChangeActiveFilterState(_selectedEditItem);
    } else if (event is EdChangeBottomPanelHeightEvent) {
      yield EdChangeBottomPanelHeightState(event.height);
    } else if (event is EdShowOrHideFrameButtonEvent) {
      yield EdShowOrHideFrameButtonState(event.show);
    } else if (event is EdEndEditingEvent) {
      yield EdEndEditingState();
    } else if (event is EdResumeEditingEvent) {
      yield EdShowOrHideFrameButtonState(true);
      yield EdResumeEditingSate();
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
      isSatturationIcon: true,
      // icon: GarnaAppIcons.satturation,
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
