import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:timeline/timeline/timeline_state.dart';

class TimelineRender extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, TimelineParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, TimelineParentData> {
  final TimelineState timeline;

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

      if (childParentData.dateTime! < timeline.startTime ||
          childParentData.dateTime! > timeline.endTime) {
        child = childParentData.nextSibling;
        continue;
      }
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
    var child = firstChild;
    while (child != null) {
      final childParentData = child.parentData! as TimelineParentData;

      if (childParentData.dateTime! < timeline.startTime ||
          childParentData.dateTime! > timeline.endTime) {
        child = childParentData.nextSibling;
        continue;
      }
      final itemOffsetX = timeline.tickBackgroundWidth;
      final itemOffsetY = (childParentData.dateTime! - timeline.startTime) *
          timeline.getScale(size);
      childParentData.offset = Offset(itemOffsetX, itemOffsetY);
      context.paintChild(child, childParentData.offset + offset);
      child = childParentData.nextSibling;
    }
  }
}

class TimelineParentData extends ContainerBoxParentData<RenderBox> {
  double? dateTime;
}
