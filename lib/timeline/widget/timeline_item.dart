import 'package:flutter/widgets.dart';

import '../render/timeline_item_render.dart';

class TimelineItem extends SingleChildRenderObjectWidget {
  /// 时间点
  final DateTime dateTime;

  const TimelineItem({
    Key? key,
    required this.dateTime,
    required Widget child,
  }) : super(key: key, child: child);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return TimelineItemRender(dateTime: dateTime.millisecondsSinceEpoch.toDouble());
  }

  @override
  void updateRenderObject(
      BuildContext context, TimelineItemRender renderObject) {
    renderObject.dateTime = dateTime.millisecondsSinceEpoch.toDouble();
  }
}
