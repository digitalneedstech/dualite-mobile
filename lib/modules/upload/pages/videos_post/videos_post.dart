import 'dart:io';

import 'package:dualites/modules/upload/getx/gallery_controller.dart';
import 'package:dualites/modules/upload/getx/gallery_state.dart';
import 'package:dualites/shared/controller/category/category_list_controller.dart';
import 'package:dualites/shared/widgets/da_raised_button_widget/da_raised_button_widget.dart';
import 'package:dualites/shared/widgets/image_widget/image_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'package:video_editor/video_editor.dart';
class VideosPost extends StatefulWidget{
  VideosPostState createState()=>VideosPostState();
}
class VideosPostState extends State<VideosPost>{
  List<String> typeOfVideos=["DUALITE","PILL"];
  String selectedVal="DUALITE";
  List<String> newTags=[];
  File? imageFile;
  String categoriesList="";
  List<TagModel> tags=[];
  String category="";
  TextEditingController _tagController=TextEditingController(text: "");
  VideoEditorController? videoEditorController1;
  VideoEditorController? videoEditorController2;
  final GalleryController galleryController=Get.find();
  bool isFirstVideoExporting=false;
  bool isSecondVideoExporting=false;
  bool canBeLoaded=false;

  void initState(){
    super.initState();
    initializeControllerAndFile();
  }

  initializeControllerAndFile()async{
    File? file=await galleryController.selectedAssets[0].file;
    File? file2=await galleryController.selectedAssets[1].file;
    if(file!=null && file2!=null) {
      videoEditorController1 = VideoEditorController.file(file);
      videoEditorController2 = VideoEditorController.file(file2);
      await videoEditorController1!.initialize();
      await videoEditorController2!.initialize();
      setState(() {
        /*if(videoEditorController1.video.value.duration<=Duration(seconds: 30,minutes: 1,milliseconds: 100000)){
        canBeLoaded=true;
      }*/
      });
    }

  }
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if(galleryController.state is PostVideoSuccessState){
        PostVideoSuccessState state= galleryController.state as PostVideoSuccessState;
        //galleryController.createDeepLink(state.video_id);
        //Get.snackbar("Saving..", "Please wait.", backgroundColor: Colors.green,colorText: Colors.white);
      }
      if(galleryController.state is PostVideoErrorState){

        /*Get.snackbar("Error", (galleryController.state as PostVideoErrorState).message,backgroundColor: Colors.red,
        colorText: Colors.white);*/
      }
      return Scaffold(
        key: galleryController.scaffoldKey,
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text("Upload Videos"),
          actions: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {
                      galleryController.typeController.text=selectedVal;
                        if(imageFile!=null && imageFile!.path.trim()!="")
                          galleryController.postVideoContent(imageFile!,categoriesList,context);
                        else
                          galleryController.scaffoldKey.currentState!.showSnackBar(SnackBar(content: Text("Please Add a thumbnail Image")));


                    },
                    child: Text("Post"),
                  ),
                )
              ],
            )
          ],
        ),
        body: videoEditorController1==null && videoEditorController2==null ?Center(child: Text("Loading"),):SingleChildScrollView(
          child: Container(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Form(
                    key: galleryController.formKey,
                    child: Column(
                      children: [
                        ImageUploadWidget(
                          file:imageFile!,
                          callback: (file) {
                            setState(() {
                              imageFile = file;
                            });
                          },
                        ),
                        TextFormField(
                          controller: galleryController.titleController,
                          decoration: InputDecoration(
                              labelText: "Please Select Title"
                          ),
                          validator: (val) {
                            if (val.toString().trim() == "")
                              return "Please Enter Title";
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: galleryController.descriptionController,
                          decoration: InputDecoration(
                              labelText: "Please Select Description"
                          ),
                          validator: (val) {
                            if (val.toString().trim() == "")
                              return "Please Enter Description";
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(flex:2,child: TextFormField(
                              controller: _tagController,
                              decoration: InputDecoration(
                                  labelText: "Please Select Category"
                              ),

                            )),
                            Expanded(child: RaisedButton(onPressed: (){
                              setState(() {
                                newTags.add(_tagController.text);
                                _tagController.text="";
                              });
                            },child: Center(child: Text("Add"),),textColor: Colors.white,color: Colors.blue,))
                          ],
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          //                   height: MediaQuery.of(context).size.height*0.2,
                          child: Wrap(
                              children:
                              newTags.map((e) {
                                return Padding(
                                    padding:const EdgeInsets.all(5.0),child: Chip(label: Text(e,style: TextStyle(color: Colors.white),),backgroundColor: Colors.blue,));
                              }).toList()

                          ),
                        ),
                        DropdownButton(isExpanded: true,items: typeOfVideos.map((e){
                          return DropdownMenuItem(child: Text(e),value: e,);
                        }).toList(), onChanged: (String? val){
                          setState(() {
                            selectedVal=val!;
                          });
                        },value: selectedVal,),/*
                        CategorySelection(tags: tags,callback: (List<String> categories){
                          setState(() {
                            categoriesList = categories.toString();
                          });

                        },)*/

                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      );
    }
    );
  }
}
class CategorySelection extends StatefulWidget{
  List<TagModel> tags;
  final Function callback;
  CategorySelection({required this.tags,required this.callback});
  CategorySelectionState createState()=>CategorySelectionState();
}
class CategorySelectionState extends State<CategorySelection>{
  final CategoryListController categoryListController=Get.find();

  @override
  Widget build(BuildContext context) {
    return MultiSelectFormField(
      autovalidate: AutovalidateMode.disabled,
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
        return TagModel(display: e!.tag,value: e.tag).toJson();
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
  TagModel({required this.value,required this.display});
  toJson(){
    return {
      "display":display,
      "value":value
    };
  }
}