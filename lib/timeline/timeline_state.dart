import 'dart:math';

import 'package:flutter/scheduler.dart';

typedef PaintCallback();

/// timeline 数据存储
class TimelineState {
  double _newStartTime = 0; // 开始时间
  double _newEndTime = 0; // 结束时间
  double _originStartTime = 0; // 初始渲染开始时间
  double _originEndTime = 0; // 初始渲染结束时间
  double _height = 0; // 窗口高度
  double _velocity = 0; // 变化速度
  double _lastFrameTime = 0.0;
  PaintCallback? onNeedPaint; // 标记是否需要更新

  static const double MoveSpeed = 20.0;
  static const double Deceleration = 9.0; // TODO

  double get newStartTime => _newStartTime;

  double get newEndTime => _newEndTime;

  double get originEndTime => _originEndTime;

  double get originStartTime => _originStartTime;

  TimelineState({required double startTime, required double endTime}) {
    _newStartTime = startTime;
    _newEndTime = endTime;
    _originStartTime = startTime;
    _originEndTime = endTime;
  }

  /// 更新视图
  void setViewport({double? startTime, double? endTime, double? height, double? velocity, bool animate = false}) {
    _newStartTime = startTime ?? _newStartTime;
    _newEndTime = endTime ?? _newEndTime;
    _height = height ?? _height;
    _velocity = velocity ?? _velocity;
    SchedulerBinding.instance.scheduleFrameCallback(beginFrame);
  }

  void beginFrame(Duration timeStamp) {
    final double t = timeStamp.inMicroseconds / Duration.microsecondsPerMillisecond / 1000.0;
    if (_lastFrameTime == 0) {
      _lastFrameTime = t;
      SchedulerBinding.instance.scheduleFrameCallback(beginFrame);
      return;
    }

    double elapsed = t - _lastFrameTime;
    _lastFrameTime = t;

    if (!advance(elapsed)) {
      SchedulerBinding.instance.scheduleFrameCallback(beginFrame);
    }

    if (onNeedPaint != null) {
      onNeedPaint!();
    }
  }

  bool advance(double elapsed)
  {
    // 每个时间单位对应的高度
    double scale = _height/(_originEndTime-_originStartTime);

    // Attenuate velocity and displace targets.
    _velocity *= 1.0 - min(1.0, elapsed*Deceleration);
    double displace = _velocity*elapsed;
    _newStartTime -= displace;
    _newEndTime -= displace;

    // Animate movement.
    double speed = min(1.0, elapsed*MoveSpeed);
    double ds = _newStartTime - _originStartTime;
    double de = _newEndTime - _originEndTime;

    bool doneRendering = true;
    bool scaling = true;
    if((ds*scale).abs() < 1.0 && (de*scale).abs() < 1.0)
    {
      scaling = false;
      _originStartTime = _newStartTime;
      _originEndTime = _newEndTime;
    }
    else
    {
      doneRendering = false;
      _originStartTime += ds*speed;
      _originEndTime += de*speed;
    }

    return doneRendering;
  }
}
