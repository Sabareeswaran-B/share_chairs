import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:share_chairs/common/constant.dart';

class ChairsMain extends StatefulWidget {
  const ChairsMain({Key? key}) : super(key: key);

  @override
  _ChairsMainState createState() => _ChairsMainState();
}

class _ChairsMainState extends State<ChairsMain> {
  Widget details() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      padding: EdgeInsets.all(15),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.brown.shade100,
        boxShadow: [
          BoxShadow(
            color: Colors.brown.shade200,
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
              "VM Hall",
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
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "White:",
                style: TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.normal,
                  fontSize: 16,
                ),
              ),
              Spacer(),
              Text(
                "25",
                style: TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.normal,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Sandal:",
                style: TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.normal,
                  fontSize: 16,
                ),
              ),
              Spacer(),
              Text(
                "45",
                style: TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.normal,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Black:",
                style: TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.normal,
                  fontSize: 16,
                ),
              ),
              Spacer(),
              Text(
                "10",
                style: TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.normal,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: primaryColor,
        leading: null,
        centerTitle: true,
        title: Text(
          "Statistics",
          style: TextStyle(
            color: solidWhite,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // SizedBox(
            //   height: 10,
            // ),
            Container(
              padding: EdgeInsets.only(bottom: 25),
              decoration: BoxDecoration(
                color: primaryColor,
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
                                "0",
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
                                "0",
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
                                "0",
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
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: 3,
              itemBuilder: (context, index) {
                return details();
              },
            ),
            SizedBox(
              height: 80,
            ),
          ],
        ),
      ),
    );
  }
}
