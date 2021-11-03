import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:share_chairs/common/constant.dart';
import 'package:share_chairs/ui/features/news_feed/newsfeed.dart';

class ChairsMain extends StatefulWidget {
  const ChairsMain({Key? key}) : super(key: key);

  @override
  _ChairsMainState createState() => _ChairsMainState();
}

class _ChairsMainState extends State<ChairsMain> {
  int gross = 0;
  int inventory = 0;
  int inService = 0;
  int broken = 0;
  List detailedList = [];
  final RefreshController _refreshController = RefreshController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    getStats();
    getDetails();
    super.initState();
  }

  Future getStats() async {
    var res = await FirebaseFirestore.instance
        .collection(STATS)
        .where("collegeName", isEqualTo: "RVSCAS")
        .get();
    var doc = res.docs[0];
    setState(() {
      gross = doc.data()['gross'];
      inventory = doc.data()['Inventory'];
      inService = doc.data()['inService'];
      broken = doc.data()['broken'];
    });
  }

  Future getDetails() async {
    var res = await FirebaseFirestore.instance.collection(DETAILS).get();
    var doc = res.docs;
    setState(() {
      detailedList.clear();
      detailedList.addAll(doc.map((val) => val.data()));
    });
    List list = detailedList.map((data) {
      Map chairs = data['chairs'];
      List values = chairs.values.toList();
      values.add(0);
      values.add(0);
      int overAll = 0;
      values.forEach((element) {
        overAll += int.parse(element.toString());
      });
      if (overAll == 0) {
        return null;
      } else {
        return data;
      }
    }).toList();
    list.removeWhere((element) => element == null);
    setState(() {
      detailedList = list;
    });
  }

  Widget details(int index) {
    Map chairs = detailedList[index]['chairs'];
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      padding: EdgeInsets.all(15),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        // color: Colors.white,
        gradient: LinearGradient(
          colors: [Colors.brown.shade50, solidWhite],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            spreadRadius: 2,
            blurRadius: 2,
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: Text(
              detailedList[index]['room'],
              style: TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          Container(
            // margin: EdgeInsets.symmetric(horizontal: 15),
            child: Divider(
              height: 10,
              thickness: 1,
              color: primaryColor,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Column(
            children: List<Widget>.generate(
                chairs.length,
                (index) => Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          chairs.keys.toList()[index],
                          style: TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.normal,
                            fontSize: 16,
                          ),
                        ),
                        Spacer(),
                        Text(
                          chairs.values.toList()[index].toString(),
                          style: TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.normal,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    )),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: primaryColor,
        leading: null,
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (builder) => NewsFeed()));
              },
              icon: Icon(FontAwesomeIcons.solidNewspaper, color: solidWhite,))
        ],
        title: Text(
          "Statistics",
          style: TextStyle(
            color: solidWhite,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      // drawer: Drawer(
      //   child: MenuBar(),
      // ),
      body: SmartRefresher(
        controller: _refreshController,
        enablePullDown: true,
        // header: SpinKitCircle(
        //   color: primaryColor,
        // ),
        onRefresh: () async {
          await getDetails();
          await getStats();
          _refreshController.refreshCompleted();
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              // SizedBox(
              //   height: 10,
              // ),
              Container(
                padding: EdgeInsets.only(bottom: 25),
                decoration: BoxDecoration(
                  // color: primaryColor,
                  gradient: LinearGradient(
                    colors: [primaryColor, Colors.brown.shade600],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(25),
                    bottomRight: Radius.circular(25),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(25),
                    bottomRight: Radius.circular(25),
                  ),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: solidWhite,
                          borderRadius: BorderRadius.circular(15),
                          // boxShadow: [
                          //   BoxShadow(
                          //     color: Colors.grey.shade300,
                          //     spreadRadius: 3,
                          //     blurRadius: 3,
                          //   )
                          // ],
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                        margin: EdgeInsets.all(15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width - 160,
                              child: Text(
                                "Total number of chairs available in college:",
                                style: TextStyle(
                                  color: solidBlack,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Container(
                              height: 60,
                              width: 60,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [primaryColor, Colors.brown.shade600],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.shade300,
                                    spreadRadius: 2,
                                    blurRadius: 2,
                                  )
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  gross.toString(),
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: solidWhite,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: solidWhite,
                          borderRadius: BorderRadius.circular(15),
                          // boxShadow: [
                          //   BoxShadow(
                          //     color: Colors.grey.shade300,
                          //     spreadRadius: 3,
                          //     blurRadius: 3,
                          //   )
                          // ],
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                        margin: EdgeInsets.all(15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              height: 60,
                              width: 60,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [primaryColor, Colors.brown.shade600],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.shade300,
                                    spreadRadius: 2,
                                    blurRadius: 2,
                                  )
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  inventory.toString(),
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: solidWhite,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width - 160,
                              child: Text(
                                ": Total number of chairs in inventory",
                                style: TextStyle(
                                  color: solidBlack,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: solidWhite,
                          borderRadius: BorderRadius.circular(15),
                          // boxShadow: [
                          //   BoxShadow(
                          //     color: Colors.grey.shade300,
                          //     spreadRadius: 3,
                          //     blurRadius: 3,
                          //   )
                          // ],
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                        margin: EdgeInsets.all(15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width - 160,
                              child: Text(
                                "Total number of chairs currently in use:",
                                style: TextStyle(
                                  color: solidBlack,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Container(
                              height: 60,
                              width: 60,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [primaryColor, Colors.brown.shade600],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.shade300,
                                    spreadRadius: 2,
                                    blurRadius: 2,
                                  )
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  inService.toString(),
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: solidWhite,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      broken == 0
                          ? SizedBox()
                          : Container(
                              decoration: BoxDecoration(
                                color: solidWhite,
                                borderRadius: BorderRadius.circular(15),
                                // boxShadow: [
                                //   BoxShadow(
                                //     color: Colors.grey.shade300,
                                //     spreadRadius: 3,
                                //     blurRadius: 3,
                                //   )
                                // ],
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 10),
                              margin: EdgeInsets.all(15),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Container(
                                    height: 60,
                                    width: 60,
                                    decoration: BoxDecoration(
                                      color: primaryColor,
                                      borderRadius: BorderRadius.circular(15),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.shade300,
                                          spreadRadius: 2,
                                          blurRadius: 2,
                                        )
                                      ],
                                    ),
                                    child: Center(
                                      child: Text(
                                        broken.toString(),
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: solidWhite,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width - 160,
                                    child: Text(
                                      ": Total number of chairs in broken",
                                      style: TextStyle(
                                        color: solidBlack,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                child: Center(
                  child: Text(
                    "Detailed Location of the chairs:",
                    style: TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 15),
                child: Divider(
                  height: 10,
                  thickness: 0.5,
                  color: primaryColor,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Column(
                children: List.generate(
                  detailedList.length,
                  (index) => details(index),
                ),
              ),
              // Expanded(
              //   flex: 1,
              //   child: ListView.builder(
              //     shrinkWrap: true,
              //     physics: NeverScrollableScrollPhysics(),
              //     itemCount: detailedList.length,
              //     itemBuilder: (context, index) {
              //       return details(index);
              //     },
              //   ),
              // ),
              SizedBox(
                height: 80,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
