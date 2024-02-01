import 'dart:async';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timesheet/controller/notify_controller.dart';
import 'package:timesheet/controller/post_controller.dart';
import 'package:timesheet/controller/timesheet_controller.dart';
import 'package:timesheet/controller/tracking_controller.dart';
import 'package:timesheet/screen/notification/notification_screen.dart';
import 'package:timesheet/screen/post/post_screen.dart';
import 'package:timesheet/screen/time_sheet/time_sheet_screen.dart';
import 'package:timesheet/screen/tracking/tracking_screen.dart';
import 'package:timesheet/screen/users/users_screen.dart';
import '../controller/auth_controller.dart';
import '../controller/user_controller.dart';
import 'menu/menu_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
    dynamic myScreen = [<Widget>[
      TrackingScreen(),
      TimeSheetScreen(),
      PostScreen(),
      UsersScreen(),
      NotificationScreen(),
      MenuScreen(),
      ],
      <Widget>[
      const Tab(icon: Icon(Icons.home_filled),),
      const Tab(icon: Icon(Icons.check),),
      const Tab(icon: Icon(Icons.account_balance_wallet_rounded),),
      const Tab(icon: Icon(Icons.people_alt),),
      const Tab(icon: Icon(Icons.notifications),),
      const Tab(icon: Icon(Icons.menu),),
      ]
    ];
  late final TabController _tabTabController;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var height = 90.0.obs;

  void startHideAppBar(bool isHide) {
    Timer.periodic(const Duration(milliseconds: 1), (Timer t) {
        if ( isHide ? height.value > 50 : height.value < 90) {
          isHide ? height.value-- : height.value++;
        } else {
          t.cancel();
        }
    });
  }

  @override
  void initState() {
    super.initState();
    Get.find<UserController>().getCurrentUser();

    _tabTabController = TabController(length: 6, vsync: this,);
    _tabTabController.addListener(() {
      if (_tabTabController.indexIsChanging || _tabTabController.index != _tabTabController.previousIndex) {
        startHideAppBar(_tabTabController.index != 0);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) => <Widget>[
          Obx(() =>
              SliverAppBar(
                automaticallyImplyLeading: true,
                title: const Text("Checking"),
                pinned: true,
                floating: true,
                forceElevated: innerBoxIsScrolled,
                expandedHeight: height.value,
                bottom: TabBar(
                  onTap: (index) {
                    handleClickTavBar();
                  },
                  controller: _tabTabController,
                  tabs: myScreen[1],
                ),
              )
          )
        ],
        body: TabBarView(
          controller: _tabTabController,
          children: myScreen[0],
        ),
      ),
    );
  }

  void handleClickTavBar() {
    if(!_tabTabController.indexIsChanging){
      switch(_tabTabController.index){
        case 0: {
          Get.find<TrackingController>().getTracking();
          scrollToFirst(Get.find<TrackingController>().scrollController);
          break;
        }
        case 1: Get.find<TimeSheetController>().getTimeSheet(); break;
        case 2: {
          Get.find<PostController>().resetListPost();
          scrollToFirst(Get.find<PostController>().pageController);

          break;
        }
        case 3: {
          Get.find<UserController>().restartListUser();
          scrollToFirst(Get.find<UserController>().scrollController);
          break;
        }
        case 4:{
          Get.find<NotifyController>().getNotify();
          scrollToFirst(Get.find<NotifyController>().scrollController);
          break;
        }
        case 5: Get.find<UserController>().getCurrentUser(); break;
      }
    }
  }

  void scrollToFirst(ScrollController? scrollController){
    if(scrollController == null) return;

    scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 1000),
        curve: Curves.easeInOut);
  }
}
