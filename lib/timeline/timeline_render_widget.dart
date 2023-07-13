import 'package:flutter/cupertino.dart';
import 'package:timeline/timeline/timeline_render_object.dart';

class TimelineRenderWidget extends LeafRenderObjectWidget{
  const TimelineRenderWidget({super.key});


  @override
  RenderObject createRenderObject(BuildContext context)
  {
    return new TimelineRenderObject();
  }

  @override
  void updateRenderObject(BuildContext context, covariant TimelineRenderObject renderObject)
  {
    renderObject;
  }
}

