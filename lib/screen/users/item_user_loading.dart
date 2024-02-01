
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ItemLoading extends StatelessWidget{
  const ItemLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.withOpacity(0.5),
      highlightColor: Colors.grey.withOpacity(0.2),
      child: Container(
        margin: EdgeInsets.all(10),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 100,
                height: 100,
                color: Colors.grey.withOpacity(0.5),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 200,
                    height: 10,
                    color: Colors.grey.withOpacity(0.5),
                    margin: EdgeInsets.all(10),
                  ),
                  Container(
                    width: 100,
                    height: 10,
                    color: Colors.grey.withOpacity(0.5),
                    margin: EdgeInsets.all(10),
                  ),
                ],
              )
            ]
        ),
      ),
    );
  }

}