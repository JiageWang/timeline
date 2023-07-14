import 'package:flutter/cupertino.dart';
import 'package:timeline/timeline/timeline_render_object.dart';
import 'package:timeline/timeline/timeline_state.dart';

class TimelineRenderWidget extends LeafRenderObjectWidget {
  final TimelineState timelineState;
  const TimelineRenderWidget(this.timelineState, {super.key});

  @override
  RenderObject createRenderObject(BuildContext context) {
    return TimelineRenderObject(timelineState);
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant TimelineRenderObject renderObject) {
    renderObject;
  }
}
