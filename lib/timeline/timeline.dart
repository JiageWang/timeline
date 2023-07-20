import 'package:flutter/cupertino.dart';
import 'package:flutter/src/gestures/events.dart';
import 'package:timeline/timeline/core/timeline_controller.dart';
import 'package:timeline/timeline/widget/timeline_item.dart';
import 'package:timeline/timeline/widget/timeline_widget.dart';

class Timeline extends StatefulWidget {
  final List<TimelineItem> items;

  const Timeline({Key? key, required this.items}) : super(key: key);

  @override
  State<Timeline> createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> {
  late TimelineController _timeline;

  Offset? _lastFocalPoint;

  double? _start;

  double? _end;

  @override
  void initState() {
    widget.items.sort((a, b) => a.dateTime.compareTo(b.dateTime));
    _timeline = TimelineController(startTime: widget.items.first.dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        _timeline.initViewport(constraints.maxHeight);
        return Listener(
          onPointerSignal: _pointerSignal,
          child: GestureDetector(
            onScaleStart: _scaleStart,
            onScaleUpdate: _scaleUpdate,
            child: TimelineWidget(
              timelineState: _timeline,
              children: widget.items,
            ),
          ),
        );
      },
    );
  }

  void _scaleStart(ScaleStartDetails details) {
    // print("===========================scale start=============================");
    _lastFocalPoint = details.focalPoint;
    _start = _timeline.start;
    _end = _timeline.end;
  }

  void _scaleUpdate(ScaleUpdateDetails details) {
    // print("===========================scale update=============================");
    // 单位时间所占高度
    double scale = context.size!.height / (_end! - _start!);

    // 计算focus点的偏移量
    double focusTime = _start! + details.focalPoint.dy / scale;
    double focusTimeDiff =
        (_lastFocalPoint!.dy - details.focalPoint.dy) / scale;

    // 计算渲染开始时间和结束时间
    // Ts' = Tp + (s/s') * (Ts - Tp) + diff
    // Te' = Tp + (s/s') * (Te - Tp) + diff
    var start =
        focusTime + (_start! - focusTime) / details.scale + focusTimeDiff;
    var end = focusTime + (_end! - focusTime) / details.scale + focusTimeDiff;
    var height = context.size!.height;
    if (height / (end - start) < _timeline.minScale ||
        height / (end - start) > _timeline.maxScale) {
      return;
    }
    _timeline.setViewport(start, end, height);
  }

  void _pointerSignal(PointerSignalEvent event) {
    print("===========================scroll=============================");
    var scrollEvent = event as PointerScrollEvent;

    // 缩放倍数
    double zoom = event.scrollDelta.dy > 0 ? 1.1 : 0.9;

    // 计算focus点的偏移量
    double focusTime =
        _timeline.start + scrollEvent.position.dy / _timeline.scale;

    // 计算渲染开始时间和结束时间
    // Ts' = Tp + zoom * (Ts - Tp)
    // Te' = Tp + zoom * (Te - Tp)
    var start = focusTime + (_timeline.start - focusTime) * zoom;
    var end = focusTime + (_timeline.end - focusTime) * zoom;
    var height = context.size!.height;
    _timeline.setViewport(start, end, height);
  }
}
