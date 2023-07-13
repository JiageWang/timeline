import 'package:flutter/cupertino.dart';
import 'package:timeline/timeline/timeline_render_widget.dart';
import 'package:timeline/timeline/timeline_state.dart';

class Timeline extends StatefulWidget {
  const Timeline({Key? key}) : super(key: key);

  @override
  State<Timeline> createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> {
  TimelineState _timelineState = TimelineState(startTime: -100, endTime: 100);
  Offset? _lastFocalPoint;
  double? _scaleStartYearStart;
  double? _scaleStartYearEnd;


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onScaleStart: _scaleStart,
      onScaleUpdate: _scaleUpdate,
      onScaleEnd: _scaleEnd,
      child: const TimelineRenderWidget(),
    );
  }



  void _scaleStart(ScaleStartDetails details)
  {
    _lastFocalPoint = details.focalPoint;
    _scaleStartYearStart = _timelineState.newStartTime;
    _scaleStartYearEnd = _timelineState.newStartTime;
    _timelineState.setViewport(velocity: 0.0, animate: true);
  }

  void _scaleUpdate(ScaleUpdateDetails details)
  {
    double changeScale = details.scale;
    double scale = (_scaleStartYearEnd!-_scaleStartYearStart!)/context.size!.height;

    double focus = _scaleStartYearStart! + details.focalPoint.dy * scale;
    double focalDiff = (_scaleStartYearStart! + _lastFocalPoint!.dy * scale) - focus;

    _timelineState.setViewport(
        startTime: focus + (_scaleStartYearStart!-focus)/changeScale + focalDiff,
        endTime: focus + (_scaleStartYearEnd!-focus)/changeScale + focalDiff,
        height: context.size!.height,
        animate: true);
  }

  void _scaleEnd(ScaleEndDetails details)
  {
    double scale = (_timelineState.newEndTime-_timelineState.newStartTime)/context.size!.height;
    _timelineState.setViewport(velocity: details.velocity.pixelsPerSecond.dy * scale, animate: true);
  }
}
