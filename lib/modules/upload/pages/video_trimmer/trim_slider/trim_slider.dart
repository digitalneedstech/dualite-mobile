import 'package:flutter/material.dart';
import 'package:video_editor/utils/controller.dart';

import 'package:helpers/helpers.dart';
import 'package:video_editor/video_editor.dart';
class TrimSliderWidget extends StatefulWidget{
  final VideoEditorController videoEditorController;
  final int index;
  final Function callback;
  TrimSliderWidget(this.videoEditorController,this.index,this.callback);
  TrimSliderWidgetState createState()=>TrimSliderWidgetState();
}
class TrimSliderWidgetState extends State<TrimSliderWidget>{
  @override
  Widget build(BuildContext context) {
    return
      Column(
        children: [
          AnimatedBuilder(
            animation: widget.videoEditorController.video,
            builder: (_, __) {
              final duration = widget.videoEditorController.video.value.duration.inSeconds;
              final pos = widget.videoEditorController.trimPosition * duration;
              final start = widget.videoEditorController.minTrim * duration;
              final end = widget.videoEditorController.maxTrim * duration;
             //widget.callback(duration);
              return Padding(
                padding: EdgeInsets.symmetric(horizontal:MediaQuery.of(context).size.height / 4),
                child: Row(children: [
                  TextDesigned(formatter(Duration(seconds: pos.toInt())),color: Colors.black,),
                  Expanded(child: SizedBox()),
                  OpacityTransition(
                    visible: widget.videoEditorController.isTrimming,
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      TextDesigned(formatter(Duration(seconds: start.toInt())),color: Colors.black,),
                      SizedBox(width: 10),
                      TextDesigned(formatter(Duration(seconds: end.toInt()))),
                    ]),
                  )
                ]),
              );
            },
          ),

      Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height*0.1,
        margin: const EdgeInsets.symmetric(vertical: 10),
        child: TrimSlider(
          controller: widget.videoEditorController,
          height: MediaQuery.of(context).size.height*0.1,
        ),
      )
    ]
    );

  }

  String formatter(Duration duration) => [
    duration.inMinutes.remainder(60).toString().padLeft(2, '0'),
    duration.inSeconds.remainder(60).toString().padLeft(2, '0')
  ].join(":");
}