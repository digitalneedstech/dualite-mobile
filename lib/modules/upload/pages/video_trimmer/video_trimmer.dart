import 'dart:io';

import 'package:dualites/modules/upload/getx/gallery_controller.dart';
import 'package:dualites/modules/upload/pages/video_trimmer/trim_slider/trim_slider.dart';
import 'package:dualites/modules/upload/pages/videos_post/videos_post.dart';
import 'package:dualites/shared/controller/category/category_list_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:helpers/helpers.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'package:video_editor/utils/controller.dart';
import 'package:video_editor/video_editor.dart';
class VideoTrimmer extends StatefulWidget{
  VideoTrimmerState createState()=>VideoTrimmerState();
}
class VideoTrimmerState extends State<VideoTrimmer>{
  File imageFile;
  final GalleryController galleryController=Get.find();
  bool isFirstVideoExporting=false;
  bool isSecondVideoExporting=false;
  bool canBeLoaded=false;

  bool canBeNavigated=false;
  bool isExporting=false;
  void initState(){
    super.initState();
    initializeControllerAndFile();
  }

  initializeControllerAndFile()async{
    File file=await galleryController.selectedAssets[0].file;
    File file2=await galleryController.selectedAssets[1].file;
    setState(() {

    });
    galleryController.controller1 = VideoEditorController.file(file);
    galleryController.controller2=VideoEditorController.file(file2);
    await galleryController.controller1.initialize();
    await galleryController.controller2.initialize();
    galleryController.videoLength1.value=galleryController.controller1.videoDuration.inSeconds;
    galleryController.videoLength2.value=galleryController.controller2.videoDuration.inSeconds;
    setState(() {

    });

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: galleryController.scaffoldKey,
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text("Resize Videos"),
          actions: [Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: galleryController.isNextButtonEnabled.value ? () {
                        _exportVideo(
                            galleryController.controller1, galleryController.controller2,)
                            .then((value) {
                          if (value) {
                            Navigator.push(
                                context, MaterialPageRoute(
                                builder: (context) => VideosPost()));
                          }
                          else {
                            galleryController.scaffoldKey.currentState
                                .showSnackBar(SnackBar(
                              content: Text("There was some error"),
                              backgroundColor: Colors.red,));
                          }
                        });
                      } : null,
                      child: Text(isExporting ? "Loading" : "Next"),
                    ),
                  )
                ],
              )
          ],
        ),
        body: galleryController.controller1==null && galleryController.controller2==null ?Center(child: Text("Loading"),):SingleChildScrollView(
          child: Container(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  canBeLoaded ?Container():Column(
                    children:
                      _trimSlider(galleryController.controller1,
                          0, (int duration){
                            galleryController.videoLength1.value=duration;
                              if(galleryController.controller1.video.value.duration.inSeconds==
                                  galleryController.controller2.video.value.duration.inSeconds){
                                galleryController.isNextButtonEnabled.value=true;
                              }
                              else
                                galleryController.isNextButtonEnabled.value=false;

                          }),

                  ), Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text("Duration: " + galleryController.videoLength1.toString())
                      ],
                  ),
                  canBeLoaded ?Container():Column(
                    children:
                    _trimSlider(galleryController.controller2,
                        0, (int duration){
                          galleryController.videoLength2.value=duration;
                          if(galleryController.controller1.video.value.duration.inSeconds==
                              galleryController.controller2.video.value.duration.inSeconds){
                            galleryController.isNextButtonEnabled.value=true;
                          }
                          else
                            galleryController.isNextButtonEnabled.value=false;

                        }),

                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text("Duration: "+galleryController.videoLength2.toString())
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
  }

  Future<bool> _exportVideo(VideoEditorController controller1,VideoEditorController controller2) async {
    try {
      File file1 = await controller1.exportVideo(
          name: "video_1",
      );
      File file2 = await controller1.exportVideo(
          name: "video_1"
      );
      galleryController.resizedFiles[0] = file1;
      galleryController.resizedFiles[1] = file2;
    }catch(e){
      return false;
    }
    return true;
  }

  String formatter(Duration duration) => [
    duration.inMinutes.remainder(60).toString().padLeft(2, '0'),
    duration.inSeconds.remainder(60).toString().padLeft(2, '0')
  ].join(":");
  List<Widget> _trimSlider(VideoEditorController controller,int index,Function callback) {
    return [
      AnimatedBuilder(
        animation: controller.video,
        builder: (_, __) {
          final duration = controller.video.value.duration.inSeconds;
          final pos = controller.trimPosition * duration;
          final start = controller.minTrim * duration;
          final end = controller.maxTrim * duration;
          if(index==0)
            galleryController.controller1=controller;
          else
            galleryController.controller2=controller;
          callback(duration);
          return Padding(
            padding: Margin.horizontal(MediaQuery.of(context).size.height / 4),
            child: Row(children: [
              TextDesigned(formatter(Duration(seconds: pos.toInt())),color: Colors.black,),
              Expanded(child: SizedBox()),
              OpacityTransition(
                visible: controller.isTrimming,
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
          controller: controller,
          height: MediaQuery.of(context).size.height*0.1,
        ),
      )
    ];
  }
}
class CategorySelection extends StatefulWidget{
  List<TagModel> tags;
  final Function callback;
  CategorySelection({this.tags,this.callback});
  CategorySelectionState createState()=>CategorySelectionState();
}
class CategorySelectionState extends State<CategorySelection>{
  final CategoryListController categoryListController=Get.find();

  @override
  Widget build(BuildContext context) {
    return MultiSelectFormField(
      autovalidate: false,
      chipBackGroundColor: Colors.red,
      chipLabelStyle: TextStyle(fontWeight: FontWeight.bold),
      dialogTextStyle: TextStyle(fontWeight: FontWeight.bold),
      checkBoxActiveColor: Colors.red,
      checkBoxCheckColor: Colors.green,
      dialogShapeBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.0))),
      title: Text(
        "Please Select Categories",
        style: TextStyle(fontSize: 16),
      ),
      dataSource: categoryListController.categoryList.map((e){
        return TagModel(display: e.tag,value: e.tag).toJson();
      }).toList(),
      textField: 'display',
      fillColor: Colors.blue,
      valueField: 'value',
      okButtonLabel: 'OK',
      cancelButtonLabel: 'CANCEL',
      hintWidget: Text('Please choose one or more'),
      initialValue: widget.tags,
      onSaved: (value) {
        if (value == null) return;
        setState(() {
          widget.tags = value;
          widget.callback(widget.tags);
        });
      },
    );
  }
}

class TagModel{
  String display,value;
  TagModel({this.value,this.display});
  toJson(){
    return {
      "display":display,
      "value":value
    };
  }
}