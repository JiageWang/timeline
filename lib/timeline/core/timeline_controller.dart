import 'package:flutter/material.dart';
import 'package:timeline/timeline/core/timeline_utils.dart';
import 'package:timeline/timeline/widget/timeline_item.dart';
import 'package:timeline/timeline/render/timeline_item_render.dart';
import 'package:timeline/timeline/render/timeline_widget_render.dart';

import 'timeline_parent_data.dart';

typedef PaintCallback = void Function();

/// timeline 数据存储
class TimelineController {
  /// 刻度栏配置
  final double tickWidth = 15;
  final double tickSubWidth = 5;
  final Duration tickIntervalTime = const Duration(days: 1); // 标签时间间隔
  final Duration tickSubIntervalTime = const Duration(hours: 6); // 标签时间间隔
  final double tickIntervalHeight = 100; // 标签间距高度
  final double tickBackgroundWidth = 60; // 左侧标签区域总宽度
  final Color tickColor = Colors.black; // 标签颜色
  final Color tickBackgroundColor = Colors.grey; // 标签背景颜色

  double _startTime = DateTime(1970, 1, 1).millisecondsSinceEpoch.toDouble(); // 开始时间
  double _endTime = DateTime(1971, 2, 1).millisecondsSinceEpoch.toDouble(); // 结束时间
  double _height = 0; // 窗口高度
  PaintCallback? onNeedPaint; // 标记是否需要更新

  double get startTime => _startTime;

  double get endTime => _endTime;

  // 每分钟对应像素高度
  double get scale => _height / (endTime - startTime);

  /// 更新视图
  void setViewport({double? startTime,
    double? endTime,
    double? height,
    bool animate = false}) {
    _startTime = startTime ?? _startTime;
    _endTime = endTime ?? _endTime;
    _height = height ?? _height;

    if (onNeedPaint != null) {
      onNeedPaint!();
    }
  }

  @override
  String toString() {
    return "timeline(startTime: ${startTime}, endTime ${endTime})";
  }


  /// 绘制刻度栏
  void paintTicks(PaintingContext context, Offset offset, Size size) {
    var canvas = context.canvas;
    var height = size.height;
    var scale = getScale(size);
    var tickPaint = Paint()
      ..color = tickColor;
    var backgroundPaint = Paint()
      ..color = tickBackgroundColor;
    canvas.drawRect(
        Rect.fromLTWH(offset.dx, offset.dy, tickBackgroundWidth, height),
        backgroundPaint);

    // 计算tick所在时间节点
    DateTime startDateTime = DateTime.fromMillisecondsSinceEpoch(startTime.round());
    DateTime tickDateTime = DateTime(startDateTime.year, startDateTime.month, startDateTime.day);
    var tickTime = tickDateTime.millisecondsSinceEpoch;
    // 计算tick相对于start所在高度
    var tickPosition = (tickTime - startTime) * scale;
    var tickInternalHeight = tickIntervalTime.inMilliseconds * scale;

    // 绘制主刻度
    while (tickPosition <= height) {
      if(tickPosition < 0){
        tickDateTime = tickDateTime.add(tickIntervalTime);
        tickPosition += tickInternalHeight;
      }else{
        TextPainter(
            text: TextSpan(text: TimelineUtils.formatDay(tickDateTime)),
            textDirection: TextDirection.ltr,
            ellipsis: '.')
          ..layout(maxWidth: tickBackgroundWidth - tickWidth)
          ..paint(canvas, Offset(offset.dx, tickPosition));
        canvas.drawRect(
            Rect.fromLTWH(offset.dx + tickBackgroundWidth - tickWidth,
                tickPosition, tickWidth, 1.5),
            tickPaint);
        tickDateTime = tickDateTime.add(tickIntervalTime);
        tickPosition += tickInternalHeight;
      }
    }

    // 绘制副刻度
    // var tickSubTime =
    //     (startTime / tickSubIntervalTime).ceil() * tickSubIntervalTime;
    // var tickSubPosition = (tickSubTime - startTime) * scale;
    //
    // while (tickSubPosition <= height) {
    //   canvas.drawRect(
    //       Rect.fromLTWH(offset.dx + tickBackgroundWidth - tickSubWidth,
    //           tickSubPosition, tickSubWidth, 1),
    //       tickPaint);
    //   tickSubTime += tickSubIntervalTime;
    //   tickSubPosition += tickSubIntervalTime * scale;
    // }
  }

  /// 动态绘制子组件
  void paintItems(PaintingContext context, Offset offset, Size size, RenderBox? firstChild) {
    var child = firstChild;
    while (child != null) {
      final childParentData = child.parentData! as TimelineParentData;

      if (childParentData.dateTime! < startTime ||
          childParentData.dateTime! > endTime) {
        child = childParentData.nextSibling;
        continue;
      }
      final itemOffsetX = tickBackgroundWidth;
      final itemOffsetY = (childParentData.dateTime! - startTime) * getScale(size);
      context.paintChild(child, Offset(itemOffsetX, itemOffsetY)+ offset);
      child = childParentData.nextSibling;
    }
  }

  /// 获取比例：每单位时间对应高度 s = h / (Te - Ts)
  getScale(size) {
    return size.height / (endTime - startTime);
  }
}
