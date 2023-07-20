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
  final double minScale = 60 / Duration.millisecondsPerDay;

  // TODO 阈值
  final double thresholdScale = 900 / Duration.millisecondsPerDay;
  final double maxScale = 1500 / Duration.millisecondsPerDay;

  double _start;
  late double _end;
  late double _height; // 窗口高度
  PaintCallback? onNeedPaint; // 标记是否需要更新

  double get start => _start;

  double get end => _end;

  double get height => _height;

  double get scale => _height / (_end - _start);

  DateTime get startTime => DateTime.fromMillisecondsSinceEpoch(_start.toInt());

  DateTime get endTime => DateTime.fromMillisecondsSinceEpoch(_end.toInt());

  TimelineController(
      {required DateTime startTime,
      this.tickWidth = 40,
      this.tickSubWidth = 5,
      this.tickIntervalHeight = 100,
      this.tickBackgroundWidth = 60,
      this.tickBackgroundColor = Colors.grey,
      this.tickColor = Colors.black})
      : _start = startTime.millisecondsSinceEpoch.toDouble();

  /// 初始化视图，根据height自动计算end
  void initViewport(double height) {
    _height = height;
    _end =
        _start + _height / (tickIntervalHeight / Duration.millisecondsPerDay);
  }

  /// 更新视图
  void setViewport(double newStart, double newEnd, double newHeight) {
    _start = newStart;
    _end = newEnd;
    _height = newHeight;

    if (onNeedPaint != null) {
      onNeedPaint!();
    }
  }

  /// 绘制刻度栏
  void paintTicks(PaintingContext context, Offset offset, Size size) {
    var canvas = context.canvas;
    var tickPaint = Paint()..color = tickColor;
    var backgroundPaint = Paint()..color = tickBackgroundColor;

    // 绘制刻度区域背景
    canvas.drawRect(
        Rect.fromLTWH(offset.dx, offset.dy, tickBackgroundWidth, size.height),
        backgroundPaint);

    paintTicksByDay(canvas, tickPaint, offset, size);
  }

  /// 动态绘制子组件
  void paintItems(PaintingContext context, Offset offset, Size size,
      RenderBox? firstChild) {
    // 裁剪画布为控件显示区域，防止子组件超出父组件
    context.canvas.clipRect(offset & size);
    // 绘制子组件
    var child = firstChild;
    while (child != null) {
      final childParentData = child.parentData! as TimelineParentData;

      // 确定子组件的offset
      final itemOffsetX = tickBackgroundWidth;
      final itemOffsetY = (childParentData.dateTime! - start) * scale;
      childParentData.offset = Offset(itemOffsetX, itemOffsetY);

      // 子组件在画面内进行绘制
      if (childParentData.dateTime! + child.size.height / scale > start &&
          childParentData.dateTime! < end) {
        context.paintChild(child, childParentData.offset + offset);
      }

      child = childParentData.nextSibling;
    }
  }

  void paintTicksByDay(
      Canvas canvas, Paint tickPaint, Offset offset, Size size) {
    // 计算tick所在时间节点
    var tickTime =
        DateTime(startTime.year, startTime.month, startTime.day - 1); // 日
    var tickPosition = (tickTime.millisecondsSinceEpoch - start) * scale;
    var tickInternal = Duration.millisecondsPerDay * scale;
    var tickInternalTime = const Duration(days: 1);
    var tickTextStype = const TextStyle(fontSize: 14);

    // 绘制刻度
    while (tickPosition <= size.height) {
      if (tickPosition >= 0) {
        // 主刻度
        canvas.drawRect(
            Rect.fromLTWH(offset.dx + tickBackgroundWidth - tickWidth,
                tickPosition + offset.dy, tickWidth, 1.5),
            tickPaint);
        // 文本
        TextPainter(
            text: TextSpan(
                text: TimelineUtils.formatDay(tickTime), style: tickTextStype),
            textDirection: TextDirection.ltr,
            ellipsis: '.')
          ..layout(maxWidth: tickBackgroundWidth)
          ..paint(canvas, Offset(offset.dx + 20, tickPosition + offset.dy + 2));
        if (tickTime.month == 1 && tickTime.day == 1) {
          TextPainter(
              text: TextSpan(
                  text: tickTime.year.toString(),
                  style: tickTextStype.copyWith(fontWeight: FontWeight.bold)),
              textDirection: TextDirection.ltr,
              ellipsis: '.')
            ..layout(maxWidth: tickBackgroundWidth)
            ..paint(
                canvas, Offset(offset.dx + 20, tickPosition + offset.dy - 20));
        }
      }
      tickTime = tickTime.add(tickInternalTime);
      tickPosition += tickInternal;
    }
    //         // 副刻度
    //         canvas.drawRect(
    //             Rect.fromLTWH(offset.dx + tickBackgroundWidth - tickSubWidth,
    //                 tickPosition + offset.dy, tickSubWidth, 1),
    //             tickPaint);
  }
}
