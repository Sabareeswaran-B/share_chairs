import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:share_chairs/common/constant.dart';
import 'package:share_chairs/ui/features/chairs/add_chair.dart';
import 'package:share_chairs/ui/features/chairs/chairs_main.dart';
import 'package:share_chairs/ui/features/chairs/delete_chair.dart';
import 'package:share_chairs/ui/features/chairs/share_chairs.dart';
import 'package:share_chairs/ui/features/profile/profile_main.dart';

class BottomNavBar extends StatefulWidget {
  final int? index;
  const BottomNavBar({Key? key, this.index}) : super(key: key);

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 2;
  late DateTime backButtonPressTime;
  final RefreshController _refreshController = RefreshController();

  @override
  void initState() {
    super.initState();
    if (widget.index != null) {
      setState(() {
        _selectedIndex = widget.index ?? 2;
      });
    }
  }

  Future<bool> onbackpressed() async {
    // exit(0);
    final now = DateTime.now();
    // ignore: unnecessary_null_comparison
    final backButtonHasNotBeenPressed = backButtonPressTime == null ||
        now.difference(backButtonPressTime).inMilliseconds > 2500;

    if (backButtonHasNotBeenPressed) {
      setState(() {
        backButtonPressTime = now;
      });
      Fluttertoast.showToast(msg: "Press again to close.");
      return false;
    }
    // print("back button");
    exit(0);
  }

  void _onItemTapped(int index) async {
    setState(() {
      _selectedIndex = index;
      FocusScope.of(context).requestFocus(FocusNode());
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onbackpressed,
      child: SmartRefresher(
        controller: _refreshController,
        onRefresh: () {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (builder) => BottomNavBar()),
              (route) => false);
          _refreshController.refreshCompleted();
        },
        enablePullDown: _selectedIndex != 2,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: backgroundColor,
          body: Stack(
            alignment: Alignment.center,
            children: [
              IndexedStack(
                index: _selectedIndex,
                children: [
                  Delete(),
                  AddChairs(),
                  ChairsMain(),
                  ShareChairs(),
                  ProfileMain(),
                ],
              ),
              Positioned(
                bottom: 5,
                child: Card(
                  elevation: 5,
                  color: solidWhite,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Container(
                    height: 70,
                    width: MediaQuery.of(context).size.width - 20,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                            onTap: () {
                              setState(() {
                                _onItemTapped(0);
                              });
                            },
                            child: Container(
                              width: 60,
                              height: 60,
                              decoration: new BoxDecoration(
                                color: _selectedIndex == 0
                                    ? primaryColor
                                    : solidWhite,
                                boxShadow: _selectedIndex == 0
                                    ? [
                                        BoxShadow(
                                          color: Colors.grey.shade300,
                                          spreadRadius: 2,
                                          blurRadius: 2,
                                        )
                                      ]
                                    : [],
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                              ),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(top: 5),
                                    child: Icon(
                                      Icons.delete_rounded,
                                      size: _selectedIndex == 0 ? 30 : 25,
                                      color: _selectedIndex == 0
                                          ? solidWhite
                                          : solidGrey,
                                    ),
                                  ),
                                  Container(
                                      margin: EdgeInsets.only(top: 5),
                                      child: Text("Delete",
                                          style: TextStyle(
                                              fontFamily: 'Avenir',
                                              color: _selectedIndex == 0
                                                  ? solidWhite
                                                  : solidGrey,
                                              fontSize: 13,
                                              fontWeight: _selectedIndex == 0
                                                  ? FontWeight.bold
                                                  : FontWeight.normal),
                                          textAlign: TextAlign.center)),
                                ],
                              ),
                            )),
                        GestureDetector(
                            onTap: () {
                              setState(() {
                                _onItemTapped(1);
                              });
                            },
                            child: Container(
                              width: 60,
                              height: 60,
                              decoration: new BoxDecoration(
                                color: _selectedIndex == 1
                                    ? primaryColor
                                    : solidWhite,
                                boxShadow: _selectedIndex == 1
                                    ? [
                                        BoxShadow(
                                          color: Colors.grey.shade300,
                                          spreadRadius: 2,
                                          blurRadius: 2,
                                        )
                                      ]
                                    : [],
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                              ),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(top: 5),
                                    child: Icon(
                                      Icons.add_box_rounded,
                                      size: _selectedIndex == 1 ? 30 : 25,
                                      color: _selectedIndex == 1
                                          ? solidWhite
                                          : solidGrey,
                                    ),
                                  ),
                                  Container(
                                      margin: EdgeInsets.only(top: 5),
                                      child: Text("Add",
                                          style: TextStyle(
                                              fontFamily: 'Avenir',
                                              color: _selectedIndex == 1
                                                  ? solidWhite
                                                  : solidGrey,
                                              fontSize: 12,
                                              fontWeight: _selectedIndex == 1
                                                  ? FontWeight.bold
                                                  : FontWeight.normal),
                                          textAlign: TextAlign.center)),
                                ],
                              ),
                            )),
                        GestureDetector(
                            onTap: () {
                              setState(() {
                                _onItemTapped(2);
                              });
                            },
                            child: Container(
                              width: 60,
                              height: 60,
                              decoration: new BoxDecoration(
                                color: _selectedIndex == 2
                                    ? primaryColor
                                    : solidWhite,
                                boxShadow: _selectedIndex == 2
                                    ? [
                                        BoxShadow(
                                          color: Colors.grey.shade300,
                                          spreadRadius: 2,
                                          blurRadius: 2,
                                        )
                                      ]
                                    : [],
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                              ),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(top: 5),
                                    child: Icon(
                                      Icons.home_filled,
                                      size: _selectedIndex == 2 ? 30 : 25,
                                      color: _selectedIndex == 2
                                          ? solidWhite
                                          : solidGrey,
                                    ),
                                  ),
                                  Container(
                                      margin: EdgeInsets.only(top: 5),
                                      child: Text("Home",
                                          style: TextStyle(
                                              fontFamily: 'Avenir',
                                              color: _selectedIndex == 2
                                                  ? solidWhite
                                                  : solidGrey,
                                              fontSize: 13,
                                              fontWeight: _selectedIndex == 2
                                                  ? FontWeight.bold
                                                  : FontWeight.normal),
                                          textAlign: TextAlign.center)),
                                ],
                              ),
                            )),
                        GestureDetector(
                            onTap: () {
                              setState(() {
                                _onItemTapped(3);
                              });
                            },
                            child: Container(
                              width: 60,
                              height: 60,
                              decoration: new BoxDecoration(
                                color: _selectedIndex == 3
                                    ? primaryColor
                                    : solidWhite,
                                boxShadow: _selectedIndex == 3
                                    ? [
                                        BoxShadow(
                                          color: Colors.grey.shade300,
                                          spreadRadius: 2,
                                          blurRadius: 2,
                                        )
                                      ]
                                    : [],
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                              ),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(top: 5),
                                    child: Icon(
                                      Icons.ios_share_rounded,
                                      size: _selectedIndex == 3 ? 30 : 25,
                                      color: _selectedIndex == 3
                                          ? solidWhite
                                          : solidGrey,
                                    ),
                                  ),
                                  Container(
                                      margin: EdgeInsets.only(top: 5),
                                      child: Text("Share",
                                          style: TextStyle(
                                              fontFamily: 'Avenir',
                                              color: _selectedIndex == 3
                                                  ? solidWhite
                                                  : solidGrey,
                                              fontSize: 13,
                                              fontWeight: _selectedIndex == 3
                                                  ? FontWeight.bold
                                                  : FontWeight.normal),
                                          textAlign: TextAlign.center)),
                                ],
                              ),
                            )),
                        GestureDetector(
                            onTap: () {
                              setState(() {
                                _onItemTapped(4);
                              });
                            },
                            child: Container(
                              width: 60,
                              height: 60,
                              decoration: new BoxDecoration(
                                color: _selectedIndex == 4
                                    ? primaryColor
                                    : solidWhite,
                                boxShadow: _selectedIndex == 4
                                    ? [
                                        BoxShadow(
                                          color: Colors.grey.shade300,
                                          spreadRadius: 2,
                                          blurRadius: 2,
                                        )
                                      ]
                                    : [],
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                              ),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(top: 5),
                                    child: Icon(
                                      Icons.person,
                                      size: _selectedIndex == 4 ? 30 : 25,
                                      color: _selectedIndex == 4
                                          ? solidWhite
                                          : solidGrey,
                                    ),
                                  ),
                                  Container(
                                      margin: EdgeInsets.only(top: 5),
                                      child: Text("Profile",
                                          style: TextStyle(
                                              fontFamily: 'Avenir',
                                              color: _selectedIndex == 4
                                                  ? solidWhite
                                                  : solidGrey,
                                              fontSize: 13,
                                              fontWeight: _selectedIndex == 4
                                                  ? FontWeight.bold
                                                  : FontWeight.normal),
                                          textAlign: TextAlign.center)),
                                ],
                              ),
                            )),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
