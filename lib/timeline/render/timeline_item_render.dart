import 'package:flutter/rendering.dart';

import '../core/timeline_parent_data.dart';

class TimelineItemRender extends RenderProxyBox {
  TimelineItemRender({
    required double dateTime,
  }) : _dateTime = dateTime;

  double _dateTime;

  double get dateTime => _dateTime;

  set dateTime(double value) {
    if (value == _dateTime) return;
    markNeedsLayout();
    _dateTime = value;
    parentData!.dateTime = _dateTime;
    markParentNeedsLayout(); // 更新时间点时标记为需要重新布局
  }

  @override
  TimelineParentData? get parentData {
    if (super.parentData == null) return null;
    return super.parentData! as TimelineParentData;
  }

  @override
  void attach(covariant PipelineOwner owner) {
    super.attach(owner);
    parentData!.dateTime = dateTime;
  }

  @override
  bool get sizedByParent => false;

  @override
  void performLayout() {
    // 由子元素决定尺寸
    child!.layout(constraints, parentUsesSize: true);
    size = Size.copy(child!.size);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    context.paintChild(child!, offset);
  }
}
