import 'package:video_player/video_player.dart';

class VideoModel{
  int id,category,creator,views,likedCount;
  List<dynamic> liked;
  String title,description,contentOne,contentTwo,type,authorAvatar,authorName,thumbnail,media;
  VideoModel({this.id=0,
    this.category=0,
    this.creator=0,
    this.views=0,
    this.title="",
    this.authorAvatar="",
    this.authorName="",
    this.thumbnail="",
    this.description="",
    this.contentOne="",
    this.contentTwo="",
    this.likedCount=0,
  this.type="",
    this.liked=const <dynamic>[],
    this.media=""});

  factory VideoModel.fromMap(Map<String,dynamic> json){
    return new VideoModel(
      liked: json['liked'],
      description: json['description'] as String,
      type: json['type'] as String,
      media: json['media'] ?? "",
      likedCount: json['liked_count'],
      id: json['id'] as int,
      //category: json['category'] as int,
      creator: json['creator'] as int,
      title: json['title'] as String,
      contentOne: json['content_one']?? json['upload_link_one'] ?? "",
      contentTwo: json['content_two']?? json['upload_link_two']??"",
      views: json['views'] ?? 0,
      authorAvatar: json['author_avatar']==null ?"":json['author_avatar'] as String,
      authorName: json['author_name']==null ?"":json['author_name'] as String ,
      thumbnail: json['thumbnail_url']
    );
  }
}