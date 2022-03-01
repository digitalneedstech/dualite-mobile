import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class PlayerWidget extends StatefulWidget {
  final VideoPlayerController videoPlayerController;
  final bool looping;
  final bool autoplay;
  final DeviceOrientation deviceOrientation;

  PlayerWidget({
    required this.videoPlayerController,
   required this.looping,required this.autoplay,this.deviceOrientation=DeviceOrientation.landscapeRight
  });

  @override
  PlayerWidgetState createState() => PlayerWidgetState();
}

class PlayerWidgetState extends State<PlayerWidget> {
  late ChewieController _chewieController;

  @override
  void initState() {
    super.initState();

  }



  @override
  void dispose() {
    super.dispose();
    _chewieController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _chewieController = ChewieController(
      deviceOrientationsOnEnterFullScreen: [widget.deviceOrientation],
      fullScreenByDefault: false,
      videoPlayerController: widget.videoPlayerController,
      aspectRatio:widget.videoPlayerController.value.aspectRatio,
      autoInitialize: true,
      looping: widget.looping,
      allowFullScreen: true,
      //autoPlay: widget.autoplay,
      /*


      errorBuilder: (context, errorMessage) {
        return Center(
          child: Text(
            errorMessage,
            style: TextStyle(color: Colors.white),
          ),
        );
      },*/
    );
    return Chewie(
          controller: _chewieController,
        );
  }

}