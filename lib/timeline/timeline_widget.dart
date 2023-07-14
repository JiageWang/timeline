import 'package:flutter/cupertino.dart';
import 'package:timeline/timeline/timeline_render.dart';
import 'package:timeline/timeline/timeline_state.dart';

class TimelineWidget extends MultiChildRenderObjectWidget {
  final TimelineState timelineState;

  const TimelineWidget(
      {super.key, required this.timelineState, required super.children});

  @override
  RenderObject createRenderObject(BuildContext context) {
    return TimelineRender(timelineState);
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant TimelineRender renderObject) {
    renderObject;
  }
}
