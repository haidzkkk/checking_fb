
import 'package:get/get.dart';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

class Utils{

  static List<Color> getListColorRandom(){
    final List<Color> colors = [
      Colors.red,
      Colors.blue,
      Colors.amber,
      Colors.purpleAccent,
      Colors.pinkAccent,
    ];
    List<Color> colorsRandom = [];

    var indexColor1 = Random().nextInt(colors.length);
    var indexColor2 = -1;
    do{
      indexColor2 = Random().nextInt(colors.length);
    }while(indexColor2 == indexColor1);

    colorsRandom.add(colors[indexColor1]);
    colorsRandom.add(colors[indexColor2]);

    return colorsRandom;
  }

  static startScreen(Widget screen){
    Get.to(
      screen,
      transition: Transition.rightToLeft,
      // duration: const Duration(milliseconds: 500),
      // curve: Curves.slowMiddle,
    );
  }
}