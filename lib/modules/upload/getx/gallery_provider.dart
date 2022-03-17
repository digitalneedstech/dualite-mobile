import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:dualites/modules/home/widgets/models/video_content_model.dart';
import 'package:dualites/modules/home/widgets/models/video_model.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GalleryProvider{
  Dio dio;
  GalleryProvider(this.dio);
  Future<List<AssetEntity>> loadGalleryAssets()async{
      final List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(
        onlyAll: true,
        filterOption: FilterOptionGroup(
      imageOption: const FilterOption(
          sizeConstraint: SizeConstraint(ignoreSize: true),
    ),
    ),
      );
      if(albums.isNotEmpty) {
        final List<AssetEntity> entities = await albums.first.getAssetListPaged(
          page: 0,
          size: 50,
        );
        if (entities.isEmpty)
          return [];

        return entities.where((element) => element.type == AssetType.video)
            .toList();
      }
      return [];

  }




  Future<dynamic> postVideoContentRequest1(String url) async {
    String postVideoFileResponse="";

    SharedPreferences preferences=await SharedPreferences.getInstance();
    String? authKey=preferences.getString("key");
    if(authKey!=null) {
      try {
        var response = await dio.post(url, options: Options(
            contentType: 'multipart/form-data',
            headers: {
              "Authorization": "token $authKey"
            }
        ));
        return VideoContentModel.fromMap(response.data);
      } on DioError catch (e) {
        if (DioErrorType.receiveTimeout == e.type ||
            DioErrorType.connectTimeout == e.type) {
          postVideoFileResponse = "Server is not reachable. Please verify your internet connection and try again";
        } else if (DioErrorType.response == e.type) {
          postVideoFileResponse ="Server responded with wrong error code";
        }
        else {
          postVideoFileResponse ="There was some issue observed on server side";
        }
      }
    }
    return postVideoFileResponse;
  }

  Future<Map<bool,String>> postThumbnailFile(
      String url,File thumbnail) async {
    Map<bool,String> postVideoFileResponse={};

    SharedPreferences preferences=await SharedPreferences.getInstance();
    String? authKey=preferences.getString("key");
    if(authKey!=null) {
      try {
        String thumbnailImagePath = thumbnail.path
            .split('/')
            .last;
        var formData = new FormData.fromMap({
          "thumbnail": await MultipartFile.fromFile(
              thumbnail.path, filename: thumbnailImagePath)
        });
        var response = await dio.post(url, data: formData, options: Options(
            contentType: 'multipart/form-data',
            headers: {
              "Authorization": "token $authKey"
            }
        ));
        postVideoFileResponse = {true: response.data["thumbnail"]};
      } on DioError catch (e) {
        if (DioErrorType.receiveTimeout == e.type ||
            DioErrorType.connectTimeout == e.type) {
          postVideoFileResponse = {
            false: "Server is not reachable. Please verify your internet connection and try again"
          };
        } else if (DioErrorType.response == e.type) {
          postVideoFileResponse =
          {false: "Server responded with wrong error code"};
        }
        /*else if (DioErrorType.DEFAULT == e.type) {
        if (e.message.contains('SocketException')) {
          postVideoFileResponse={false:"There was socket issue from server side encountered"};
        }
        else {
          postVideoFileResponse={false:"There was some issue observed on server side"};
        }
      } */ else {
          postVideoFileResponse =
          {false: "There was some issue observed on server side"};
        }
      }
    }
    return Future.value(postVideoFileResponse);
  }

  Future<dynamic> postVideoContentRequest2(
      String url,String title,String description,String type,String tags,String thumbnailUrl,String contentOne,String contentTwo) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? authKey = preferences.getString("key");
    if (authKey != null) {
      try {
        var formData = {
        "title":title,
        "description":description,
        "type":type,
        "tags":tags=="" ?["Movies", "Video",
    ] :[tags],
    "thumbnail_url":thumbnailUrl,
    "content_one":contentOne,
    "content_two":contentTwo
    };
    var response = await dio.post(url,data: formData,options:Options(
    contentType: "application/json",
    headers: {
    "Authorization": "token $authKey"
    }
    ));
    return VideoModel.fromMap(response.data);

    } on DioError catch (e) {
    if (DioErrorType.receiveTimeout == e.type ||
    DioErrorType.connectTimeout == e.type) {
    return "Server is not reachable. Please verify your internet connection and try again";

    } else if (DioErrorType.response == e.type) {
    return "Server responded with wrong error code";
    } /*else if (DioErrorType.DEFAULT == e.type) {
        if (e.message.contains('SocketException')) {
          postVideoFileResponse={false:"There was socket issue from server side encountered"};
        }
        else {
          postVideoFileResponse={false:"There was some issue observed on server side"};
        }
      } */else {
    return "There was some issue observed on server side";
    }

    }
  }
  }

  Future<dynamic> postVideoFiles(
      String url,File file1) async {
    Map<bool,String> postVideoFileResponse={};
    try {
      Uint8List video = File(file1.path).readAsBytesSync();

      Options options = Options(
          contentType: "video/*",
          headers: {
            'Content-Length': video.length,

          }
      );
      var response = await dio.put(url,
          options: options,
            data: Stream.fromIterable(video.map((e) => [e])),
          );
      if(response.statusCode==200)
        return true;
      return false;
    } on DioError catch (e) {
      if (DioErrorType.receiveTimeout == e.type ||
          DioErrorType.connectTimeout == e.type) {
        postVideoFileResponse={false:"Server is not reachable. Please verify your internet connection and try again"};

      } else if (DioErrorType.response == e.type) {
        postVideoFileResponse={false:"Server responded with wrong error code"};
      } /*else if (DioErrorType.DEFAULT == e.type) {
        if (e.message.contains('SocketException')) {
          postVideoFileResponse={false:"There was socket issue from server side encountered"};
        }
        else {
          postVideoFileResponse={false:"There was some issue observed on server side"};
        }
      } */else {
        postVideoFileResponse={false:"There was some issue observed on server side"};
      }

    }
    return Future.value(postVideoFileResponse);
  }

}