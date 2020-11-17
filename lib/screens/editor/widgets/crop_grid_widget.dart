import 'dart:math';

import 'package:flutter/material.dart';

class RectClipper extends CustomClipper<Path> {
  final Offset topLeftRatio;
  final Offset topRightRatio;

  RectClipper(this.topLeftRatio, this.topRightRatio);

  @override
  Path getClip(Size size) {
    final path = Path();
    path.addRect(Rect.fromPoints(topLeftRatio, topRightRatio));
    path.addRect(new Rect.fromLTWH(0.0, 0.0, size.width, size.height));
    path.fillType = PathFillType.evenOdd;
    return path;
  }
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

class CropGridController {

  Offset _topLeft = Offset(0, 0);
  Offset _bottomRight = Offset(0, 0);

  Offset _topLeftRatio = Offset(0, 0);
  Offset _bottomRightRatio = Offset(1.0, 1.0);

  Offset get topLeftRatio => _topLeftRatio;
  Offset get bottomRightRatio => _bottomRightRatio;

  CropGridController([this._topLeftRatio = const Offset(0, 0), this._bottomRightRatio = const Offset(1.0, 1.0)]);

  Function(int, int) _onAspect;

  void cropAspect(int aspectX, int aspectY) {
    _onAspect(aspectX, aspectY);
  }
}

class CropGridWidget extends StatefulWidget {
  // final Offset topLeftRatio;
  // final Offset bottomRightRatio;

  final CropGridController controller;
  final Function(Offset, Offset) onCropEnd;
  
  CropGridWidget({this.controller, this.onCropEnd});

  @override
  _CropGridWidgetState createState() => _CropGridWidgetState();
}

enum PointerType {
  topLeft, 
  topRight, 
  bottomLeft, 
  bottomRight
}

class _CropGridWidgetState extends State<CropGridWidget> {

  bool _initialized = false;

  PointerType _pointerType;

  Offset _topLeft = Offset(-5, -5);
  Offset _bottomRight = Offset(-5, -5);

  @override
  void initState() {
    super.initState();

    if (widget.controller != null) {
      widget.controller._onAspect = _onAspect;
      _topLeft = widget.controller._topLeft;
      _bottomRight = widget.controller._bottomRight;
      _initialized = true;
    }
  
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(Duration(milliseconds: 300));
      setState(() {
        final size = _renderSize;
        if (widget.controller.topLeftRatio != null) {
          _topLeft = Offset(size.dx * widget.controller.topLeftRatio.dx, size.dy * widget.controller.topLeftRatio.dy) - Offset(5, 5);
        }
        if (widget.controller.bottomRightRatio != null) {
          _bottomRight = Offset(size.dx * widget.controller.bottomRightRatio.dx, size.dy * widget.controller.bottomRightRatio.dy);
        } else {
          _bottomRight = _renderSize;
        }
        _initialized = true;
      });
      _updateController();
    });
  }

  Offset get _renderSize {
    RenderBox render = context.findRenderObject();
    return Offset(render.size.width, render.size.height) - Offset(25, 25);
  }

  void _updateController() {
    final size = _renderSize;
    widget.controller._topLeftRatio = Offset((_topLeft.dx + 5) / size.dx, (_topLeft.dy + 5.0) / size.dy);
    widget.controller._bottomRightRatio = Offset(_bottomRight.dx / size.dx, _bottomRight.dy / size.dy);
    widget.controller._topLeft = _topLeft;
    widget.controller._bottomRight = _bottomRight;
  }

  void _onAspect(int aspectX, int aspectY) {
    if (aspectX == 0 && aspectY == 0) {
      setState(() {
        _topLeft = Offset(-5, -5);
        _bottomRight = _renderSize;
      });
    } else {
      final size = _renderSize;
      final ratio = (size.dy * aspectX) / (size.dy * aspectY);

      final width = size.dy * ratio;
      final height = size.dy;

      double scale = 1;
      if (width > size.dx) {
        scale = size.dx / width;
      } else if (height > size.dy) {
        scale = size.dy / height;
      }

      setState(() {
        _topLeft = size * 0.5 - Offset(width * scale, height * scale) * 0.5 - Offset(5, 5);
        _bottomRight = size * 0.5 + Offset(width * scale, height * scale) * 0.5;
      });
    }
    _updateController();
  }
 
  void _onPointerMove(PointerMoveEvent event) {
    final size = _renderSize;
    final position = event.localPosition - Offset(15, 15);

    final dx = min(size.dx, max(-5.0, position.dx));
    final dy = min(size.dy, max(-5.0, position.dy));

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
    } else {
      final dx = event.delta.dx;
      final dy = event.delta.dy;
      if (_topLeft.dx + dx >= -5 && _bottomRight.dx + dx < size.dx) {
        setState(() {
          _topLeft += Offset(dx, 0);
          _bottomRight += Offset(dx, 0);
        });
      }
      
      if (_topLeft.dy + dy >= -5 && _bottomRight.dy + dy < size.dy) {
        setState(() {
          _topLeft += Offset(0, dy);
          _bottomRight += Offset(0, dy);
        });
      }
      // if (rect.contains(newBottomRight)) {
      //   setState(() {
      //     _bottomRight = newBottomRight;
      //   });
      // }
    }
    _updateController();
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

    final renderSize = _renderSize;
    
    final topLeftMargin = _topLeft + Offset(5, 5);
    final bottomRightMargin = renderSize - _bottomRight;

    if (widget.onCropEnd != null) {
      widget.onCropEnd(topLeftMargin, bottomRightMargin);
    }
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
              color: _initialized ? Colors.white : Colors.transparent, 
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
        color: _initialized ? Colors.white : Colors.transparent,
        width: width,
        height: height,
      )
    );
  }

  Widget _buildBackground(double width, double height) {
    return IgnorePointer(
      child: ClipPath(
        clipper: RectClipper(_topLeft + Offset(15, 15), _bottomRight + Offset(15, 15)),
        child: Container(
          color: _initialized ? Colors.black.withOpacity(0.5) : Colors.transparent,
        ),
      ),
    );
  }

  Widget _buildForeground(double width, double height) {
    return Positioned(
      top: _topLeft.dy + 15,
      left: _topLeft.dx + 15,
      width: width,
      height: height,
      child: Container(
        color: Colors.transparent,
      ),
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
          _buildForeground(width, height),
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
        ],
      )
    );
  }
}
