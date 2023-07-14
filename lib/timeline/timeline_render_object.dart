import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:timeline/timeline/timeline_state.dart';

class TimelineRenderObject extends RenderBox {
  final double tickWidth = 50;
  final double tickIntervalTime = 100;
  final double tickIntervalHeight = 100;
  final Color tickColor = Colors.black;
  final Color tickBackgroundColor = Colors.grey;

  final TimelineState timeline;

  TimelineRenderObject(this.timeline) {
    timeline.onNeedPaint = () {
      markNeedsPaint();
    };
  }

  @override
  bool hitTestSelf(Offset position) => true;

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
    var canvas = context.canvas;
    var height = size.height;
    var tickPaint = Paint()..color = tickColor;
    var backgroundPaint = Paint()..color = tickBackgroundColor;
    canvas.drawRect(Rect.fromLTWH(offset.dx, offset.dy, tickWidth, height),
        backgroundPaint);

    // 计算tick所在时间节点
    var tickTime =
        (timeline.startTime / tickIntervalTime).ceil() * tickIntervalTime;
    // 计算tick相对于start所在高度
    var tickPosition = (tickTime - timeline.startTime) * getScale();
    // print("${tickTime}s, ${tickPosition}px, ${getScale()}px/s");

    while (tickPosition <= height) {
      TextPainter(
          text: TextSpan(text: tickTime.toString()),
          textDirection: TextDirection.ltr,
          ellipsis: '.')
        ..layout(maxWidth: 50)
        ..paint(canvas, Offset(offset.dx, tickPosition));
      canvas.drawRect(
          Rect.fromLTWH(offset.dx + 20, tickPosition, tickWidth - 20, 1),
          tickPaint);
      tickTime += tickIntervalTime;
      tickPosition += tickIntervalTime * getScale();
    }
  }

  /// 计算初始刻度位置
  findFirstTickPosition() {}

  /// 获取比例：每单位时间对应高度 s = h / (Te - Ts)
  getScale() {
    return size.height / (timeline.endTime - timeline.startTime);
  }
}
