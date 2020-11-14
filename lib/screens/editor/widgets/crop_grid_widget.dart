import 'dart:math';

import 'package:flutter/material.dart';

class CropGridWidget extends StatefulWidget {
  const CropGridWidget({
    Key key,
  }) : super(key: key);

  @override
  _CropGridWidgetState createState() => _CropGridWidgetState();
}

enum PointerType {
  topLeft, topRight, bottomLeft, bottomRight
}

class _CropGridWidgetState extends State<CropGridWidget> {

  PointerType _pointerType;

  Offset _topLeft = Offset(0, 0);
  Offset _bottomRight = Offset(100, 100);

  // void _onTopLeft(Velocity velocity, Offset offset) {
  //   setState(() {
  //     RenderBox render = context.findRenderObject();
  //     final local = render.globalToLocal(offset);
  //     _topLeft = local;
  //   });
  // }

  // void _onBottomRight(Velocity velocity, Offset offset) {
  //   setState(() {
  //     RenderBox render = context.findRenderObject();
  //     final local = render.globalToLocal(offset);
  //     _bottomRight = local;
  //   });
  // }

  void _onPointerMove(PointerMoveEvent event) {
    RenderBox render = context.findRenderObject();
    final position = event.localPosition;

    final dx = min(render.size.width - 25, max(-5.0, position.dx));
    final dy = min(render.size.height - 25, max(-5.0, position.dy));

    final maxSize = 50.0;
   // print('${dx} ${_bottomRight.dx - dx}');

    if (_pointerType == PointerType.topLeft) {
      setState(() {
        _topLeft = Offset(_bottomRight.dx - dx < maxSize ? _topLeft.dx : dx, _bottomRight.dy - dy < maxSize ? _topLeft.dy : dy);
      });
    } else if (_pointerType == PointerType.bottomRight) {
      setState(() {
        _bottomRight = Offset(dx - _topLeft.dx < maxSize ? _bottomRight.dx : dx, dy - _topLeft.dy < maxSize ? _bottomRight.dy : dy);
      });
    } else if (_pointerType == PointerType.bottomLeft) {
      setState(() {
        _topLeft = Offset(_bottomRight.dx - dx < maxSize ? _topLeft.dx : dx, _topLeft.dy);
        _bottomRight = Offset(_bottomRight.dx, dy - _topLeft.dy < maxSize ? _bottomRight.dy : dy);
      });
    } else if (_pointerType == PointerType.topRight) {
      setState(() {
        _topLeft = Offset(_topLeft.dx, _bottomRight.dy - dy < maxSize ? _topLeft.dy : dy);
        _bottomRight = Offset(dx - _topLeft.dx < maxSize ? _bottomRight.dx : dx, _bottomRight.dy);
      });
    }
  }

  void _onPointerStart(PointerType type) {
    setState(() {
      _pointerType = type;
    });
  }

  void _onPointerEnd() {
    setState(() {
      _pointerType = null;
    });
  }

  Widget _buildButton(double x, double y, PointerType type) {
    return Positioned(
      left: x,
      top: y,
      child: Draggable(
        onDragStarted: ()=> _onPointerStart(type),
        onDragEnd: (evt)=> _onPointerEnd(),
        feedback: Container(),
        child: Container(
          width: 30,
          height: 30,
          color: Colors.transparent,
          alignment: Alignment.center,
          child: Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle
            ),
          )
        )
      ),
    );
  }

  Widget _buildLine(double x, double y, double width, double height) {  //Offset from, Offset to) {
    return Positioned(
      left: x + 15,
      top: y + 15,
      child: Container(
        color: Colors.white,
        width: width,
        height: height,
      )
    );
  }

  Widget _buildBackground(double width, double height) {
    return Positioned(
      left: _topLeft.dx + 15,
      top: _topLeft.dy + 15,
      child: Container(
        width: width,
        height: height,
        color: Colors.black.withOpacity(0.3),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = _bottomRight.dx - _topLeft.dx;
    final height = _bottomRight.dy - _topLeft.dy;
    return  Listener(
      onPointerMove: _onPointerMove,
      child: Stack(
        children: [
          _buildBackground(width, height),

          _buildLine(_topLeft.dx, _topLeft.dy, width, 2),
          _buildLine(_topLeft.dx, _bottomRight.dy, width, 2),
          _buildLine(_topLeft.dx, _topLeft.dy, 2, height),
          _buildLine(_bottomRight.dx, _topLeft.dy, 2, height),

          _buildLine(_topLeft.dx, _topLeft.dy + height * 0.33, width, 0.5),
          _buildLine(_topLeft.dx, _topLeft.dy + height * 0.66, width, 0.5),
          _buildLine(_topLeft.dx + width * 0.33, _topLeft.dy, 0.5, height),
          _buildLine(_topLeft.dx + width * 0.66, _topLeft.dy, 0.5, height),

          _buildButton(_topLeft.dx, _topLeft.dy, PointerType.topLeft),
          _buildButton(_bottomRight.dx, _bottomRight.dy, PointerType.bottomRight),
          _buildButton(_topLeft.dx, _bottomRight.dy, PointerType.bottomLeft),
          _buildButton(_bottomRight.dx, _topLeft.dy, PointerType.topRight),
          // Positioned(
          //   left: _topLeft.dx + 15,
          //   top: _topLeft.dy + 15,
          //   child: _buildHorizontalLine(_topLeft, _bottomRight)
          // ),
          // Positioned(
          //   left: _topLeft.dx + 15,
          //   top: _bottomRight.dy + 15,
          //   child: _buildHorizontalLine(_topLeft, _bottomRight)
          // ),
          // Positioned(
          //   left: _topLeft.dx + 15,
          //   top: _topLeft.dy + 15,
          //   child: _buildVerticalLine(_topLeft, _bottomRight)
          // ),
          // Positioned(
          //   left: _bottomRight.dx + 15,
          //   top: _topLeft.dy + 15,
          //   child: _buildVerticalLine(_topLeft, _bottomRight)
          // ),
          // Positioned(
          //   left: _topLeft.dx + 5,
          //   top: _bottomRight.dy + 5,
          //   child: _buildVerticalLine(_topLeft, _bottomRight)
          // ),
        ],
      )
    );
  }
}
