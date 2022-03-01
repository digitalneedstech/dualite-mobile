import 'package:video_player/video_player.dart';

class VideoControllerModel{
  int active;
  VideoPlayerController? controller1,controller2;
  VideoControllerModel({this.active=1,this.controller1,this.controller2});
}