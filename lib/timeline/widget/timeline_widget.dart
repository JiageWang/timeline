import 'package:flutter/widgets.dart';

import '../core/timeline_controller.dart';
import '../render/timeline_widget_render.dart';

class TimelineWidget extends MultiChildRenderObjectWidget {
  final TimelineController timelineState;

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
