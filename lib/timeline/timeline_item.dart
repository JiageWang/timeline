import 'package:flutter/material.dart';
import 'package:timeline/timeline/timeline_item_render.dart';

class TimelineItem extends SingleChildRenderObjectWidget {
  /// 时间点
  final double dateTime;

  const TimelineItem({
    Key? key,
    required this.dateTime,
    required Widget child,
  }) : super(key: key, child: child);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return TimelineItemRender(
      dateTime: dateTime,
    );
  }

  @override
  void updateRenderObject(BuildContext context, TimelineItemRender renderObject) {
    renderObject.dateTime = dateTime;
  }
}

