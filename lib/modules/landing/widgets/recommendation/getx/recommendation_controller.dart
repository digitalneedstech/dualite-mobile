import 'package:dualites/modules/home/widgets/models/video_list.dart';
import 'package:dualites/modules/home/widgets/models/video_model.dart';
import 'package:dualites/modules/landing/widgets/recommendation/getx/recommendation_service.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RecommendationController extends GetxController{
  List<VideoModel?> videosList = [];
  bool isLoading = true;
  String errorMessage="";
  String nextUrl='https://dualite.xyz/api/v1/videos/recommended/';
  RecommendationProvider recommendationProvider;
  RecommendationController({required this.recommendationProvider});

  @override
  void onInit() {
    getVideosModel();
    super.onInit();
  }


  void getVideosModel()async{
    SharedPreferences preferences=await SharedPreferences.getInstance();
    String? key =preferences.getString("key");
    if(key!=null) {
      final dynamic response =
      await recommendationProvider.getRecommendedVideos(
          "https://dualite.xyz/api/v1/videos/recommended/", key);
      if (response is VideosList) {
        List<VideoModel?> videos=response.results;
        Iterable<VideoModel?> list=response.results.where((element) => element!=null);
        nextUrl = response.next;
        videosList.addAll(list);
        isLoading = false;
        update();
      }
      else {
        isLoading = false;
        errorMessage = response;
        update();
      }
    }
  }
}