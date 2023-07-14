import 'dart:math';

import 'package:flutter/scheduler.dart';

typedef PaintCallback();

/// timeline 数据存储
class TimelineState {
  double _zoom = 1; // 缩放比例
  double _startTime = 0; // 开始时间
  double _endTime = 0; // 结束时间
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


  TimelineState({required double startTime, required double endTime}) {
    _startTime = startTime;
    _endTime = endTime;
  }

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

//   void beginFrame(Duration timeStamp) {
//     final double t =
//         timeStamp.inMicroseconds / Duration.microsecondsPerMillisecond / 1000.0;
//     if (_lastFrameTime == 0) {
//       _lastFrameTime = t;
//       SchedulerBinding.instance.scheduleFrameCallback(beginFrame);
//       return;
//     }
//
//     double elapsed = t - _lastFrameTime;
//     _lastFrameTime = t;
//
//     if (!advance(elapsed)) {
//       SchedulerBinding.instance.scheduleFrameCallback(beginFrame);
//     }
//
//     if (onNeedPaint != null) {
//       onNeedPaint!();
//     }
//   }
//
//   bool advance(double elapsed) {
//     // 每个时间单位对应的高度
//     double scale = _height / (_endTime - _startTime);
//
//     // Attenuate velocity and displace targets.
//     _velocity *= 1.0 - min(1.0, elapsed * Deceleration);
//     double displace = _velocity * elapsed;
//     _newStartTime -= displace;
//     _newEndTime -= displace;
//
//     // Animate movement.
//     double speed = min(1.0, elapsed * MoveSpeed);
//     double ds = _newStartTime - _startTime;
//     double de = _newEndTime - _endTime;
//
//     bool doneRendering = true;
//     bool scaling = true;
//     if ((ds * scale).abs() < 1.0 && (de * scale).abs() < 1.0) {
//       scaling = false;
//       _startTime = _newStartTime;
//       _endTime = _newEndTime;
//     } else {
//       doneRendering = false;
//       _startTime += ds * speed;
//       _endTime += de * speed;
//     }
//
//     return doneRendering;
//   }


  @override
  String toString() {
    return "timeline(startTime: ${startTime}, endTime ${endTime})";
  }
}
