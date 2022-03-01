import 'package:dualites/models/user_profile_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

class GalleryState extends Equatable {
  @override
  List<Object> get props => [];
}
class PostVideoLoadingState extends GalleryState {}
class VideoDeepLinkCreationInProgressState extends GalleryState {}
class PostVideoErrorState extends GalleryState {
  final String message;
  PostVideoErrorState({required this.message});
}

class VideoDeepLinkCreationErrorState extends GalleryState {
  final String message;
  VideoDeepLinkCreationErrorState({required this.message});
}
class VideoDeepLinkCreationSuccessState extends GalleryState {
  final String deepLinkUrl;
  VideoDeepLinkCreationSuccessState({required this.deepLinkUrl});
}

class PostVideoSuccessState extends GalleryState {
  final int video_id;
  PostVideoSuccessState({required this.video_id});
}