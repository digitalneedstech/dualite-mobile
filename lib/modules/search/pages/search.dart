import 'package:date_format/date_format.dart';
import 'package:dio/dio.dart';
import 'package:dualites/models/user_profile_model.dart';
import 'package:dualites/modules/home/widgets/models/video_model.dart';
import 'package:dualites/modules/landing/landing_page.dart';
import 'package:dualites/modules/landing/widgets/person_follow.dart';
import 'package:dualites/modules/widgets/widgets.dart';
import 'package:dualites/shared/constants/routes.dart';
import 'package:dualites/shared/controller/video_list_controller.dart';
import 'package:dualites/shared/controller/video_list_provider.dart';
import 'package:dualites/shared/widgets/animate_list/animate_list.dart';
import 'package:dualites/shared/widgets/loading/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class SearchPage extends StatelessWidget {
  final VideoListController videoListController = Get.put(
      VideoListController(videoListProvider: VideoListProvider(dio: Dio())));

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async=>false,
      child: SafeArea(
        top: true,
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(children: [
              Row(
                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Text(
                      "Search",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                    ),
                  ),
                  //Expanded(child: SizedBox()),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: SearchTextField(
                  callback: (val) {
                    videoListController.getVideosFromSearchQuery(val);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0,horizontal: 8.0),
                child: SearchByCategoryListWidget((final String selectedCategory){
                  videoListController.selectedSearchCategory=selectedCategory;
                }),
              ),
              GetBuilder<VideoListController>(
                builder: (controller) {
                  return Expanded(
                    child: LoadingOverlay(
                        isLoading: controller.nextLoading,
                        child: AnimationLimiter(
                          child: controller.searchVideos.isEmpty && controller.searchProfiles.isEmpty ?
                          Center(child: Text("No data Found"),):ListView.builder(
                            physics: BouncingScrollPhysics(),
                            itemBuilder: (context, int index) {
                              if (controller.nextLoading) {
                                return Center(
                                  child: Lottie.asset(
                                      'assets/lotties/video_loader.json'),
                                );
                              }
                              if(videoListController.selectedSearchCategory=="CREATOR" && controller.searchProfiles.isNotEmpty){
                                UserProfileModel? userProfileModel=controller.searchProfiles[index];
                                return AnimateList(index: index,
                                widget: UserProfileTile(userProfileModel!));
                              }
                              else{
                                VideoModel? videoModel =controller.searchVideos[index];
                                return AnimateList(index: index,
                                    widget: VideoTile(videoModel!));
                              }
                            },
                            itemCount: controller.searchVideos.isNotEmpty ?controller.searchVideos.length:controller.searchProfiles.length,
                            shrinkWrap: true,
                            //padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 10.0),
                          ),
                        )),
                  );
                },
              ),
            ]),
          ),
        ),
      ),
    );
  }
}

class SearchTextField extends StatefulWidget {
  Function? callback;
  Function? changeCallback;

  SearchTextField({this.callback, this.changeCallback});

  SearchTextFieldState createState() => SearchTextFieldState();
}

class SearchTextFieldState extends State<SearchTextField> {
  String initialVal = "";

  @override
  Widget build(BuildContext context) {
    if (widget.callback != null) {
      return TextFormField(
        initialValue: initialVal,
        onChanged: (val) {
          setState(() {
            initialVal = val;
            if (widget.changeCallback != null)
              widget.changeCallback!(initialVal);
          });
        },
        decoration: InputDecoration(
            suffix: IconButton(
          onPressed: () => widget.callback!(initialVal)!,
          icon: Icon(Icons.search),
        )),
      );
    }
    return TextFormField(
        initialValue: initialVal,
        onChanged: (val) {
          setState(() {
            initialVal = val;
            if (widget.changeCallback != null)
              widget.changeCallback!(initialVal);
          });
        });
  }
}

class SearchByCategoryListWidget extends StatefulWidget{
  final Function callback;
  SearchByCategoryListWidget(this.callback);
  SearchByCategoryListWidgetState createState()=>SearchByCategoryListWidgetState();
}

class SearchByCategoryListWidgetState extends State<SearchByCategoryListWidget>{
  String selectedVal="PILLS";
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SearchCategoryWidget("CREATOR",selectedVal,(){
          updateSelectedCategoryAndExecuteCallback("CREATOR");
        }),
        SearchCategoryWidget("PILLS",selectedVal,(){
          updateSelectedCategoryAndExecuteCallback("PILLS");
        }),
        Expanded(child: SizedBox())
      ],
    );
  }

  updateSelectedCategoryAndExecuteCallback(String selectedCategory){
    setState(() {
      selectedVal=selectedCategory;
    });
    widget.callback(selectedVal);
  }
}

class SearchCategoryWidget extends StatefulWidget{
  final Function callback;
  final String selectedVal;
  final String categoryName;
  SearchCategoryWidget(this.categoryName,this.selectedVal,this.callback);
  SearchCategoryWidgetState createState()=>SearchCategoryWidgetState();
}
class SearchCategoryWidgetState extends State<SearchCategoryWidget>{
  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.only(right: 5.0),
      child: InkWell(
        onTap: ()=>widget.callback(),
        child: Container(
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
              color: widget.categoryName==widget.selectedVal ?Colors.blue:Colors.white,
              border: Border.all(color: Colors.blue,width: 1.0),
              borderRadius: BorderRadius.circular(10.0)
          ),
          child: Center(child: Text(widget.categoryName,style: TextStyle(color: widget.categoryName==widget.selectedVal ?Colors.white:Colors.blue),),),
        ),
      ),);
  }
}

class VideoTile extends StatelessWidget{
  final VideoModel videoModel;
  VideoTile(this.videoModel);
  @override
  Widget build(BuildContext context) {
    return  InkWell(
      onTap: (){
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    LandingPage(id: videoModel.id,)));

      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              videoModel.thumbnail==null ?
              Container(
                width: MediaQuery.of(context).size.width,
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.2,
                  width: MediaQuery.of(context).size.width,
                  child:Image.asset("assets/images/home_girl.jpg",fit: BoxFit.cover,),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey,
                          offset: Offset(5.0, 5.0),
                          blurRadius: 10.0)
                    ],
                  ),
                ),
              ):Container(
                width: MediaQuery.of(context).size.width,
                //padding:const EdgeInsets.all(10.0),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.2,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey,
                            offset: Offset(5.0, 5.0),
                            blurRadius: 10.0)
                      ],
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(videoModel.thumbnail)
                      )
                  ),
                ),
              ),
              Container(
                padding:const EdgeInsets.symmetric(horizontal:50.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      videoModel.title,
                      style: TextStyle(
                          color: Colors.black,fontFamily:"Montserrat", fontWeight: FontWeight.bold,fontSize: 20.0),
                    ),
                    Expanded(child: SizedBox()),
                    PopupMenuButton(
                      itemBuilder: (BuildContext context) {
                        return {'1', '2'}.map((String choice) {
                          return PopupMenuItem<String>(
                            value: choice,
                            child: Text(choice),
                          );
                        }).toList();
                      },
                    )
                  ],
                ),
              ),

              Container(
                padding:const EdgeInsets.symmetric(horizontal:50.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                        padding: const EdgeInsets.only(right: 5.0),
                        child:  CircleAvatar(
                          backgroundImage: AssetImage(
                              "assets/images/author_image.jpg"),
                        )
                    ),
                    Text(videoModel.authorName!=null ?videoModel.authorName:"Author Name",style: TextStyle(color: Colors.black,fontSize: 12.0),),
                    Expanded(child: SizedBox()),
                    Text("242 Views",style: TextStyle(color: Colors.grey,fontSize: 12.0),),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class UserProfileTile extends StatelessWidget{
  final UserProfileModel userProfileModel;
  const UserProfileTile(this.userProfileModel);
  @override
  Widget build(BuildContext context) {
    return ListTile(

      leading: CircleAvatar(
        backgroundImage: AssetImage(
            "assets/images/author_image.jpg"
        ),
      ),
      title: Text(userProfileModel.name,style: TextStyle(fontFamily: "Montserrat",
          letterSpacing: 3.0,
          fontSize: 16.0,
          color: Colors.black),),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          PersonFollowWidget(userProfileModel: userProfileModel,)/*
          Container(
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.blue,width: 1.0),
                borderRadius: BorderRadius.circular(10.0)
            ),child: Center(child: Text("Follow",style: TextStyle(color: Colors.blue),)))*/
        ],
      ),
    );
  }
}
