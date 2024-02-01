
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:timesheet/controller/post_controller.dart';
import 'package:timesheet/data/model/body/post/content_request.dart';
import 'package:timesheet/helper/date_converter.dart';
import 'package:timesheet/utils/utils.dart';

import '../../../view/custom_snackbar.dart';

class CreatePostTextScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return CreatePostTextScreenState();
  }

}

class CreatePostTextScreenState extends State<CreatePostTextScreen> {

  final TextEditingController textController = TextEditingController();
  double width = 0.0;
  List<Color> listColor = Utils.getListColorRandom();

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: const BackButton(
            color: Colors.black,
          ),
          actions: [
            InkWell(
              onTap: (){
                _createPost();
              },
              child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Center(
                      child: Text("share".tr, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),)
                  )
              ),
            ),
          ],
          title: const Text("Up post", style: TextStyle(color: Colors.black),),
        ),
        body: Container(
          child: Center(
            child: layoutContent(),
          ),
        )
    );
  }



  Widget layoutContent(){

    return Container(
      width: width - 20,
      height: width - 50,
      margin: const EdgeInsets.all(10),
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40.0),
        boxShadow: [
          BoxShadow(
            color: listColor[0].withOpacity(0.2),
            spreadRadius: 200,
            blurRadius: 200,
            offset: const Offset(0, 0),
          ),
          BoxShadow(
            color: listColor[1].withOpacity(0.2),
            spreadRadius: 200,
            blurRadius: 200,
            offset: const Offset(0, 0),
          ),
        ],
        gradient: LinearGradient(
            colors: [listColor[0], listColor[1]],
            begin: Alignment.bottomLeft,
            end: Alignment.topRight
        ),
      ),
      child: Center(
        child: TextFormField(
          controller: textController,
          textAlign: TextAlign.center,
          decoration: const InputDecoration(
              border: InputBorder.none,
          ),
          maxLines: null,
          style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold, ),
        ),
      ),
    );
  }

  void _createPost() {
    if(textController.text.isNotEmpty){
      Get.find<PostController>().createPost(
          ContentRequest(
              content: textController.text,
              date: DateTime.now().formatToISOString(),
              likes: [],
              comments: [],
              media: [])
      ).then((value) {
        if(value == 200){
          showCustomSnackBar("Thành công", isError: false);
          Navigator.pop(context);
        }else{
          showCustomSnackBar("Thất bại");
        }
      })
      .catchError((error){
        print(error);
        showCustomSnackBar("Lỗi");
      });
    }
  }
}
