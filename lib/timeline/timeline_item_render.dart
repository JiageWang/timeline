
import 'package:flutter/rendering.dart';
import 'package:timeline/timeline/timeline_item.dart';
import 'package:timeline/timeline/timeline_render.dart';
import 'package:timeline/timeline/timeline_widget.dart';

class TimelineItemRender extends RenderProxyBox {
  TimelineItemRender({
    required double dateTime,
  }) : _dateTime = dateTime;

  double _dateTime;

  double get dateTime => _dateTime;

  set dateTime(double value) {
    if (value == _dateTime) return;

    _dateTime = value;
    parentData!.dateTime = _dateTime;
    markParentNeedsLayout(); // 更新时间点时标记为需要重新布局
  }

  @override
  TimelineParentData? get parentData {
    if (super.parentData == null) return null;
    assert(
    super.parentData is TimelineParentData,
    '$TimelineItem can only be direct child of $TimelineWidget',
    );
    return super.parentData! as TimelineParentData;
  }

  @override
  void attach(covariant PipelineOwner owner) {
    super.attach(owner);
    parentData!.dateTime = dateTime;
  }

  @override
  void performLayout() {
    print("peform timeline item");
    // 由子元素决定尺寸
    child!.layout(constraints, parentUsesSize: true);
    size = Size.copy(child!.size);
  }

  // @override
  // bool get sizedByParent => true;
  //
  // // sizedByParent为true时用来计算盒子的大小
  // @override
  // Size computeDryLayout(BoxConstraints constraints) {
  //   return constraints.biggest;
  // }

  @override
  void paint(PaintingContext context, Offset offset) {
    print("paint timeline item");
    context.paintChild(child!, offset);
    // context.pushClipRect(
    //   needsCompositing,
    //   offset,
    //   Offset.zero & size,
    //   (context, offset) {
    //   },
    // );
  }
}
