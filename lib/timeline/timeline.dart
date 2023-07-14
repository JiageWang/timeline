import 'package:flutter/cupertino.dart';
import 'package:timeline/timeline/timeline_render_widget.dart';
import 'package:timeline/timeline/timeline_state.dart';

class Timeline extends StatefulWidget {
  const Timeline({Key? key}) : super(key: key);

  @override
  State<Timeline> createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> {
  final TimelineState _timelineState = TimelineState(startTime: 100, endTime: 1000);
  Offset? _lastFocalPoint;
  double? _startTime;
  double? _endTime;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onScaleStart: _scaleStart,
      onScaleUpdate: _scaleUpdate,
      child: TimelineRenderWidget(_timelineState),
    );
  }

  void _scaleStart(ScaleStartDetails details) {
    _lastFocalPoint = details.focalPoint;
    _startTime = _timelineState.startTime;
    _endTime = _timelineState.endTime;
    _timelineState.setViewport();
  }

  void _scaleUpdate(ScaleUpdateDetails details) {
    // 单位时间所占高度
    double scale = context.size!.height / (_endTime! - _startTime!);

    // 计算focus点的偏移量
    double focusTime = _startTime! + details.focalPoint.dy / scale;
    double focusTimeDiff =
        (_lastFocalPoint!.dy - details.focalPoint.dy) / scale;
    print("${focusTime}, ${focusTimeDiff}");

    // 计算渲染开始时间和结束时间
    // Ts' = Tp + (s/s') * (Ts - Tp) + diff
    // Te' = Tp + (s/s') * (Te - Tp) + diff
    _timelineState.setViewport(
        startTime: focusTime + (_startTime! - focusTime) * details.scale + focusTimeDiff,
        endTime: focusTime + (_endTime! - focusTime) * details.scale + focusTimeDiff,
        height: context.size!.height);
  }
}
