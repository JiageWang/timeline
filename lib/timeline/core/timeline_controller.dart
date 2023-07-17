import 'package:flutter/material.dart';
import 'package:timeline/timeline/core/timeline_utils.dart';

import 'timeline_parent_data.dart';

typedef PaintCallback = void Function();

/// timeline 数据存储
class TimelineController {
  /// 刻度栏配置
  final double tickWidth;
  final double tickSubWidth;
  final double tickIntervalHeight; // 标签间距高度
  final double tickBackgroundWidth; // 左侧标签区域总宽度
  final Color tickColor; // 标签颜色
  final Color tickBackgroundColor; // 标签背景颜色
  final Duration tickIntervalTime = const Duration(days: 1); // 标签时间间隔
  final Duration tickSubIntervalTime = const Duration(hours: 6); // 标签时间间隔

  double _start;
  late double _end;
  late double _height; // 窗口高度
  PaintCallback? onNeedPaint; // 标记是否需要更新

  double get start => _start;

  double? get end => _end;

  double get height => _height;

  DateTime get startTime => DateTime.fromMillisecondsSinceEpoch(_start.toInt());

  DateTime get endTime => DateTime.fromMillisecondsSinceEpoch(_end.toInt());

  TimelineController({required DateTime startTime,
    this.tickWidth = 15,
    this.tickSubWidth = 5,
    this.tickIntervalHeight = 100,
    this.tickBackgroundWidth = 60,
    this.tickBackgroundColor = Colors.grey,
    this.tickColor = Colors.black})
      : _start = startTime.millisecondsSinceEpoch.toDouble();

  /// 初始化视图，根据height自动计算end
  void initViewport(double height) {
    _height = height;
    _end = _start +
        _height / (tickIntervalHeight / tickIntervalTime.inMilliseconds);
  }

  /// 更新视图
  void setViewport({double? newStart, double? newEnd, double? newHeight}) {
    _start = newStart ?? _start;
    _end = newEnd ?? _end;
    _height = newHeight ?? _height;

    if (onNeedPaint != null) {
      onNeedPaint!();
    }
  }

  /// 绘制刻度栏
  void paintTicks(PaintingContext context, Offset offset, Size size) {
    var scale = getScale(size);
    var canvas = context.canvas;
    var tickPaint = Paint()
      ..color = tickColor;
    var backgroundPaint = Paint()
      ..color = tickBackgroundColor;

    // 绘制刻度区域背景
    canvas.drawRect(
        Rect.fromLTWH(offset.dx, offset.dy, tickBackgroundWidth, size.height),
        backgroundPaint);

    // 计算tick所在时间节点
    var tickTime =
    DateTime(startTime.year, startTime.month, startTime.day); // 日
    var tick = tickTime.millisecondsSinceEpoch;
    // 计算tick相对于start所在高度
    var tickPosition = (tick - start) * scale;
    var tickInternalHeight = tickIntervalTime.inMilliseconds * scale;

    // 绘制主刻度
    while (tickPosition <= size.height) {
      if (tickPosition < 0) {
        tickTime = tickTime.add(tickIntervalTime);
        tickPosition += tickInternalHeight;
      } else {
        TextPainter(
            text: TextSpan(text: TimelineUtils.formatDay(tickTime)),
            textDirection: TextDirection.ltr,
            ellipsis: '.')
          ..layout(maxWidth: tickBackgroundWidth - tickWidth)
          ..paint(canvas, Offset(offset.dx, tickPosition));
        canvas.drawRect(
            Rect.fromLTWH(offset.dx + tickBackgroundWidth - tickWidth,
                tickPosition, tickWidth, 1.5),
            tickPaint);
        tickTime = tickTime.add(tickIntervalTime);
        tickPosition += tickInternalHeight;
      }
    }

    // 绘制副刻度
    // var tickSubTime =
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
  void paintItems(PaintingContext context, Offset offset, Size size,
      RenderBox? firstChild) {
    var child = firstChild;
    while (child != null) {
      final childParentData = child.parentData! as TimelineParentData;

      if (childParentData.dateTime! < start ||
          childParentData.dateTime! > end!) {
        child = childParentData.nextSibling;
        continue;
      }
      final itemOffsetX = tickBackgroundWidth;
      final itemOffsetY = (childParentData.dateTime! - start) * getScale(size);
      context.paintChild(child, Offset(itemOffsetX, itemOffsetY) + offset);
      child = childParentData.nextSibling;
    }
  }

  /// 获取比例：每单位时间对应高度 s = h / (Te - Ts)
  getScale(size) {
    if (end == null) {
      return tickIntervalHeight / tickIntervalTime.inMilliseconds;
    }
    return size.height / (end! - start);
  }
}
