//
// import 'package:dots_indicator/dots_indicator.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:photo_view/photo_view.dart';
// import 'package:photo_view/photo_view_gallery.dart';
// import 'package:timesheet/utils/color_resources.dart';
// import '../../data/model/response/image.dart' as img;
//
// class GalleryPhotoViewWrapper extends StatefulWidget {
//   GalleryPhotoViewWrapper({super.key,
//     this.loadingBuilder,
//     this.backgroundDecoration,
//     this.minScale,
//     this.maxScale,
//     this.initialIndex = 0,
//     required this.galleryItems,
//     this.scrollDirection = Axis.horizontal,
//     this.onTapOption,
//   }) : pageController = PageController(initialPage: initialIndex);
//
//   final LoadingBuilder? loadingBuilder;
//   final BoxDecoration? backgroundDecoration;
//   final dynamic minScale;
//   final dynamic maxScale;
//   final int initialIndex;
//   final PageController pageController;
//   final Axis scrollDirection;
//   final List<img.Image> galleryItems;
//   final Function(img.Image)? onTapOption;
//
//   @override
//   State<StatefulWidget> createState() {
//     return _GalleryPhotoViewWrapperState();
//   }
// }
//
// class _GalleryPhotoViewWrapperState extends State<GalleryPhotoViewWrapper> {
//   late int currentIndex = widget.initialIndex;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: widget.backgroundDecoration?.color ?? Colors.black,
//       body: GestureDetector(
//         onVerticalDragStart: (details) => _startVerticalDrag(details),
//         onVerticalDragUpdate: (details) => _whileVerticalDrag(details),
//         onVerticalDragEnd: (details) => _endVerticalDrag(details),
//
//         child: Container(
//           decoration: widget.backgroundDecoration,
//           constraints: BoxConstraints.expand(
//             height: MediaQuery.of(context).size.height,
//           ),
//           child: Stack(
//             alignment: Alignment.bottomCenter,
//             children: <Widget>[
//               AnimatedPositioned(
//                 duration: animationDuration,
//                 curve: Curves.fastOutSlowIn,
//                 top: 0 + positionYDelta,
//                 bottom: 0 - positionYDelta,
//                 left: 0,
//                 right: 0,
//                 child: PhotoViewGallery.builder(
//                   scrollPhysics: const BouncingScrollPhysics(),
//                   builder: (BuildContext context, int index) {
//                     final img.Image item = widget.galleryItems[index];
//                     return PhotoViewGalleryPageOptions(
//                       imageProvider: NetworkImage(item.file!.url),
//                       initialScale: PhotoViewComputedScale.contained,
//                       minScale: PhotoViewComputedScale.contained * (0.5 + index / 10),
//                       maxScale: PhotoViewComputedScale.covered * 4.1,
//                       heroAttributes: PhotoViewHeroAttributes(tag: item.id!),
//                     );
//                   },
//                   itemCount: widget.galleryItems.length,
//                   loadingBuilder: widget.loadingBuilder,
//                   backgroundDecoration: widget.backgroundDecoration,
//                   pageController: widget.pageController,
//                   onPageChanged: (index){
//                     setState(() {
//                       currentIndex = index;
//                     });
//                   },
//                   scrollDirection: widget.scrollDirection,
//                 ),
//               ),
//               Opacity(
//                 opacity: opacity,
//                 child: DotsIndicator(
//                   dotsCount: widget.galleryItems.length,
//                   position: currentIndex,
//                   decorator: DotsDecorator(
//                     color: Colors.grey,
//                     activeColor: ColorResources.getPrimaryColor(),
//                   ),
//                 ),
//               ),
//
//               if(widget.onTapOption != null)
//                 Positioned(
//                   top: 30,
//                   right: 10,
//                   child: Opacity(
//                       opacity: opacity,
//                       child: GestureDetector(
//                           onTap: (){
//                             widget.onTapOption!(widget.galleryItems[currentIndex]);
//                           },
//                           child: const Icon(Icons.more_vert_rounded, color: Colors.white,)
//                       )
//                   ),
//                 ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//
//   double initialPositionY = 0;
//   double currentPositionY = 0;
//   double positionYDelta = 0;
//   double disposeLimit = 100;
//   double opacity = 1;
//   Duration animationDuration = Duration.zero;
//
//   void _startVerticalDrag(details) {
//     setState(() {
//       initialPositionY = details.globalPosition.dy;
//     });
//   }
//
//   _endVerticalDrag(DragEndDetails details) {
//
//     // start position - end position > position dispose
//     if (positionYDelta > disposeLimit || positionYDelta < -disposeLimit) {
//       Navigator.of(context).pop();
//     } else {
//       setState(() {
//         animationDuration = const Duration(milliseconds: 300);
//         opacity = 1;
//         positionYDelta = 0;
//       });
//
//       Future.delayed(animationDuration).then((_){
//         setState(() {
//           animationDuration = Duration.zero;
//         });
//       });
//     }
//   }
//
//   void _whileVerticalDrag(details) {
//     setState(() {
//       currentPositionY = details.globalPosition.dy;
//       positionYDelta = currentPositionY - initialPositionY;
//       setOpacity();
//     });
//   }
//
//   setOpacity() {
//     double tmp = positionYDelta < 0
//         ? 1 - ((positionYDelta / 1000) * -1)
//         : 1 - (positionYDelta / 1000);
//     print(tmp);
//
//     if (tmp > 1)
//       opacity = 1;
//     else if (tmp < 0)
//       opacity = 0;
//     else
//       opacity = tmp;
//   }
// }
//
