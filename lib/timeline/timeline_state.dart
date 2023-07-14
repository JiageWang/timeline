import 'package:flutter/material.dart';
import 'package:timeline/timeline/timeline_item.dart';
import 'package:timeline/timeline/timeline_item_render.dart';
import 'package:timeline/timeline/timeline_render.dart';

typedef PaintCallback();

/// timeline 数据存储
class TimelineState {
  /// 刻度栏配置
  final double tickWidth = 15;
  final double tickSubWidth = 5;
  final double tickIntervalTime = 100; // 标签时间间隔
  final double tickSubIntervalTime = 20; // 标签时间间隔
  final double tickIntervalHeight = 100; // 标签间距高度
  final double tickBackgroundWidth = 60; // 左侧标签区域总宽度
  final Color tickColor = Colors.black; // 标签颜色
  final Color tickBackgroundColor = Colors.grey; // 标签背景颜色

  double _zoom = 1; // 缩放比例
  double _startTime = -100; // 开始时间
  double _endTime = 100; // 结束时间
  double _renderStartTime = 0; // 初始渲染开始时间
  double _renderEndTime = 0; // 初始渲染结束时间
  double _height = 0; // 窗口高度
  double _velocity = 0; // 变化速度
  PaintCallback? onNeedPaint; // 标记是否需要更新

  static const double MoveSpeed = 20.0;
  static const double Deceleration = 9.0; // TODO

  double get zoom => _zoom;

  double get startTime => _startTime;

  double get endTime => _endTime;

  double get renderStartTime => _renderStartTime;

  double get renderEndTime => _renderEndTime;

  TimelineState();

  /// 更新视图
  void setViewport({double? startTime,
    double? endTime,
    double? height,
    bool animate = false}) {
    _startTime = startTime ?? _startTime;
    _endTime = endTime ?? _endTime;
    _height = height ?? _height;

    _renderStartTime = _startTime;
    _renderEndTime = _endTime;
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
    var tickTime = (startTime / tickIntervalTime).ceil() * tickIntervalTime;
    // 计算tick相对于start所在高度
    var tickPosition = (tickTime - startTime) * scale;
    // print("${tickTime}s, ${tickPosition}px, ${getScale()}px/s");

    // 绘制主刻度
    while (tickPosition <= height) {
      TextPainter(
          text: TextSpan(text: tickTime.toString()),
          textDirection: TextDirection.ltr,
          ellipsis: '.')
        ..layout(maxWidth: tickBackgroundWidth - tickWidth)
        ..paint(canvas, Offset(offset.dx, tickPosition));
      canvas.drawRect(
          Rect.fromLTWH(offset.dx + tickBackgroundWidth - tickWidth,
              tickPosition, tickWidth, 1.5),
          tickPaint);
      tickTime += tickIntervalTime;
      tickPosition += tickIntervalTime * scale;
    }

    // 绘制福刻度
    var tickSubTime =
        (startTime / tickSubIntervalTime).ceil() * tickSubIntervalTime;
    var tickSubPosition = (tickSubTime - startTime) * scale;

    while (tickSubPosition <= height) {
      canvas.drawRect(
          Rect.fromLTWH(offset.dx + tickBackgroundWidth - tickSubWidth,
              tickSubPosition, tickSubWidth, 1),
          tickPaint);
      tickSubTime += tickSubIntervalTime;
      tickSubPosition += tickSubIntervalTime * scale;
    }
  }


  /// 获取比例：每单位时间对应高度 s = h / (Te - Ts)
  getScale(size) {
    return size.height / (endTime - startTime);
  }
}
