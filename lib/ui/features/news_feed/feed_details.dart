import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:share_chairs/common/constant.dart';

class FeedDetails extends StatefulWidget {
  final feed;
  const FeedDetails({Key? key, this.feed}) : super(key: key);

  @override
  _FeedDetailsState createState() => _FeedDetailsState();
}

class _FeedDetailsState extends State<FeedDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: solidWhite,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.chevron_left,
            color: Colors.black,
            size: 35,
          ),
        ),
        centerTitle: true,
        title: Text(
          "News Feed",
          style: TextStyle(
            color: primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        child: Column(children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            decoration: BoxDecoration(
              color: solidWhite,
              borderRadius: BorderRadius.all(Radius.circular(15)),
              boxShadow: [
                new BoxShadow(
                    color: Colors.grey.shade300,
                    blurRadius: 2,
                    spreadRadius: 2),
              ],
            ),
            child: Column(
              children: [
                Text(
                  "Details: ",
                  style: TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                Divider(height: 10, thickness: 0.7, color: Colors.black),
                SizedBox(height: 10),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  horizontalTitleGap: 50,
                  title: Text(
                    "Done by",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Text(
                    widget.feed['createdBy'],
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                  ),
                  trailing: Container(
                    height: 45,
                    width: 45,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: primaryColor,
                    ),
                    child: Icon(
                      FontAwesomeIcons.userCircle,
                      color: Colors.white,
                      size: 25,
                    ),
                  ),
                ),
                Divider(
                    height: 15, thickness: 0.7, color: Colors.grey.shade400),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  horizontalTitleGap: 50,
                  title: Text(
                    "Date",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Text(
                    DateFormat("MMM dd, yyyy")
                        .format(DateTime.parse(widget.feed['createdAt']))
                        .toString(),
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                  ),
                  trailing: Container(
                    height: 45,
                    width: 45,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: primaryColor,
                    ),
                    child: Icon(
                      FontAwesomeIcons.calendarDay,
                      color: Colors.white,
                      size: 25,
                    ),
                  ),
                ),
                Divider(
                    height: 15, thickness: 0.7, color: Colors.grey.shade400),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  horizontalTitleGap: 50,
                  title: Text(
                    "Time",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Text(
                    DateFormat('HH:mm')
                        .format(DateTime.parse(widget.feed['createdAt']))
                        .toString(),
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                  ),
                  trailing: Container(
                    height: 45,
                    width: 45,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: primaryColor,
                    ),
                    child: Icon(
                      FontAwesomeIcons.clock,
                      color: Colors.white,
                      size: 25,
                    ),
                  ),
                ),
                Divider(
                    height: 15, thickness: 0.7, color: Colors.grey.shade400),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  horizontalTitleGap: 50,
                  title: Text(
                    "Action",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Text(
                    widget.feed['action'],
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                  ),
                  trailing: Container(
                    height: 45,
                    width: 45,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: widget.feed['action'] == "added"
                          ? Colors.green
                          : widget.feed['action'] == "deleted"
                              ? Colors.red
                              : widget.feed['action'] == "shared"
                                  ? Colors.orange
                                  : Colors.grey,
                    ),
                    child: Icon(
                      widget.feed['action'] == "added"
                          ? FontAwesomeIcons.plusCircle
                          : widget.feed['action'] == "deleted"
                              ? FontAwesomeIcons.minusCircle
                              : widget.feed['action'] == "shared"
                                  ? FontAwesomeIcons.share
                                  : FontAwesomeIcons.heartBroken,
                      color: Colors.white,
                      size: 25,
                    ),
                  ),
                ),
                Divider(
                    height: 15, thickness: 0.7, color: Colors.grey.shade400),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  horizontalTitleGap: 50,
                  title: Text(
                    "Number of chairs",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Text(
                    widget.feed['nos'].toString(),
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                  ),
                  trailing: Container(
                    height: 45,
                    width: 45,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: primaryColor,
                    ),
                    child: Icon(
                      FontAwesomeIcons.levelUpAlt,
                      color: Colors.white,
                      size: 25,
                    ),
                  ),
                ),
                Divider(
                    height: 15, thickness: 0.7, color: Colors.grey.shade400),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  horizontalTitleGap: 50,
                  title: Text(
                    "Color",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Text(
                    widget.feed['color'],
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                  ),
                  trailing: Container(
                    height: 45,
                    width: 45,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: primaryColor,
                    ),
                    child: Icon(
                      FontAwesomeIcons.paintBrush,
                      color: Colors.white,
                      size: 25,
                    ),
                  ),
                ),
                Divider(
                    height: 15, thickness: 0.7, color: Colors.grey.shade400),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  horizontalTitleGap: 50,
                  title: Text(
                    "From",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Text(
                    widget.feed['from'],
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                  ),
                  trailing: Container(
                    height: 45,
                    width: 45,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: primaryColor,
                    ),
                    child: Icon(
                      FontAwesomeIcons.building,
                      color: Colors.white,
                      size: 25,
                    ),
                  ),
                ),
                Divider(
                    height: 15, thickness: 0.7, color: Colors.grey.shade400),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  horizontalTitleGap: 50,
                  title: Text(
                    "To",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Text(
                    widget.feed['to'],
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                  ),
                  trailing: Container(
                    height: 45,
                    width: 45,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: primaryColor,
                    ),
                    child: Icon(
                      FontAwesomeIcons.building,
                      color: Colors.white,
                      size: 25,
                    ),
                  ),
                ),
                Divider(
                    height: 15, thickness: 0.7, color: Colors.grey.shade400),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
