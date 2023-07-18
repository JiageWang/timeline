import 'package:flutter/rendering.dart';

import '../core/timeline_controller.dart';
import '../core/timeline_parent_data.dart';

class TimelineRender extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, TimelineParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, TimelineParentData> {
  final TimelineController timeline;

  TimelineRender(this.timeline) {
    timeline.onNeedPaint = () {
      markNeedsPaint();
    };
  }

  /// 设置ParentData
  @override
  void setupParentData(covariant RenderObject child) {
    if (child.parentData is! TimelineParentData) {
      child.parentData = TimelineParentData();
    }
  }

  @override
  bool hitTestSelf(Offset position) => true;

  @override
  void performLayout() {
    size = constraints.biggest;

    var child = firstChild;
    while (child != null) {
      final childParentData = child.parentData! as TimelineParentData;

      var itemWidth = size.width - timeline.tickBackgroundWidth;
      child.layout(
        BoxConstraints(minWidth: itemWidth, maxWidth: itemWidth),
      );
      child = childParentData.nextSibling;
    }
  }

  @override
  void performResize() {
    size = constraints.biggest;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    timeline.paintTicks(context, offset, size);
    timeline.paintItems(context, offset, size, firstChild);
  }
}
