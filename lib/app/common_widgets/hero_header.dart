//import 'dart:math';
//
//import 'package:flutter/material.dart';
//import 'package:flutter/rendering.dart';
//
//import 'container_linear_gradient.dart';
//
//class HeroHeader implements SliverPersistentHeaderDelegate {
//  HeroHeader({
////    this.layoutGroup,
////    this.onLayoutToggle,
//    this.minExtent,
//    this.maxExtent,
//    this.child,
//  });
////  final LayoutGroup layoutGroup;
////  final VoidCallback onLayoutToggle;
//  double maxExtent;
//  double minExtent;
//  Widget child;
//
//  @override
//  Widget build(
//      BuildContext context, double shrinkOffset, bool overlapsContent) {
//    return Stack(
//      fit: StackFit.expand,
//      children: [
//        Image.asset(
//          'assets/images/beach.jpg',
//          fit: BoxFit.cover,
//        ),
//        ContainerLinearGradient(),
//        Positioned(
//          left: 4.0,
//          top: 4.0,
//          child: SafeArea(
//            child: IconButton(
//              icon: Icon(
//                Icons.arrow_back_ios,
//                color: Colors.white,
//                size: 30,
//              ),
//              onPressed: () {
//                Navigator.of(context).pop();
//              },
//            ),
//          ),
//        ),
//        Positioned(
//          left: 16.0,
//          right: 16.0,
//          bottom: 16.0,
//          child: child,
//        ),
//      ],
//    );
//  }
//
//  double titleOpacity(double shrinkOffset) {
//    // simple formula: fade out text as soon as shrinkOffset > 0
//    return 1.0 - max(0.0, shrinkOffset) / maxExtent;
//    // more complex formula: starts fading out text when shrinkOffset > minExtent
//    //return 1.0 - max(0.0, (shrinkOffset - minExtent)) / (maxExtent - minExtent);
//  }
//
//  @override
//  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
//    return true;
//  }
//
//  @override
//  FloatingHeaderSnapConfiguration get snapConfiguration => null;
//
//  @override
//  OverScrollHeaderStretchConfiguration get stretchConfiguration =>
//      OverScrollHeaderStretchConfiguration();
//}
