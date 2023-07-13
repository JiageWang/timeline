import 'package:flutter/cupertino.dart';

class TimelineRenderObject extends RenderBox {
  @override
  void performLayout() {
    size = constraints.biggest;
  }

  @override
  void performResize() {
    size = constraints.biggest;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    super.paint(context, offset);
  }
}
