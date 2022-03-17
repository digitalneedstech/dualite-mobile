import 'package:dualites/modules/reels/models/video_controller_model.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoInfo extends StatefulWidget {
  VideoPlayerController videoPlayerController;
  final Function? callback;
  final Function? longPressCallback;
  VideoInfo({
    this.longPressCallback,required this.videoPlayerController,this.callback});
  VideoInfoState createState()=>VideoInfoState();
}
class VideoInfoState extends State<VideoInfo>{
  bool play = true;

  Widget build(BuildContext context) {
    return FlatButton(
          padding: EdgeInsets.all(0),
          onLongPress: (){
            if(widget.longPressCallback!=null)
              widget.longPressCallback!();
          },
          onPressed: () {
            if (widget.callback != null) {
              widget.callback!();
            }
          }, child: AspectRatio(
      aspectRatio: widget.videoPlayerController.value.aspectRatio,
            child: Container(
        width: MediaQuery
              .of(context)
              .size
              .width,
        height: MediaQuery
              .of(context)
              .size
              .height,
        child: VideoPlayer(widget.videoPlayerController),
      ),
          ));

  }
}