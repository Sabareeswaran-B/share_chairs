import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:share_chairs/common/constant.dart';
import 'package:share_chairs/ui/features/news_feed/feed_details.dart';

class NewsFeed extends StatefulWidget {
  const NewsFeed({Key? key}) : super(key: key);

  @override
  _NewsFeedState createState() => _NewsFeedState();
}

class _NewsFeedState extends State<NewsFeed> {
  RefreshController _refreshController = RefreshController();
  ScrollController _scrollController = ScrollController();
  late Future<List<Map<String, dynamic>>> feed;
  List<Map<String, dynamic>> _newsFeed = [];
  @override
  void initState() {
    super.initState();
    feed = getNewsFeed();
  }

  Future<List<Map<String, dynamic>>> getNewsFeed() async {
    var result = await FirebaseFirestore.instance.collection(NEWSFEED).get();
    var docs = result.docs;
    var newsFeed = docs.map((e) => e.data()).toList();
    setState(() {
      _newsFeed = newsFeed;
      _newsFeed.sort((a, b) {
        return DateTime.parse(b['createdAt'])
            .compareTo(DateTime.parse(a['createdAt']));
      });
    });
    return newsFeed;
  }

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
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: feed,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: SpinKitCircle(
                color: primaryColor,
                size: 75,
              ),
            );
          }
          if (snapshot.hasData) {
            var newsFeed = snapshot.data ?? [];
            print(newsFeed);
            return CupertinoScrollbar(
              controller: _scrollController,
              isAlwaysShown: true,
              child: SmartRefresher(
                controller: _refreshController,
                enablePullDown: true,
                onRefresh: () async {
                  await getNewsFeed();
                  _refreshController.refreshCompleted();
                },
                child: ListView.builder(
                  controller: _scrollController,
                  padding: EdgeInsets.symmetric(vertical: 20),
                  itemCount: _newsFeed.length,
                  itemBuilder: (context, index) {
                    return _buildFeed(_newsFeed[index]);
                  },
                ),
              ),
            );
          }
          return Container();
        },
      ),
    );
  }

  Widget _buildFeed(Map<String, dynamic> feed) {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
      padding: EdgeInsets.only(top: 5, bottom: 5),
      decoration: new BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(15)),
        boxShadow: [
          new BoxShadow(
              color: Colors.grey.shade300, blurRadius: 2, spreadRadius: 2),
        ],
      ),
      child: ListTile(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (builder) => FeedDetails(
                feed: feed,
              ),
            ),
          );
        },
        isThreeLine: true,
        leading: Container(
          alignment: Alignment.center,
          height: 55,
          width: 55,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: feed['action'] == "added"
                ? Colors.green
                : feed['action'] == "deleted"
                    ? Colors.red
                    : feed['action'] == "shared"
                        ? Colors.orange
                        : Colors.grey,
          ),
          child: Text(
            (feed['nos'] + 000000).toString(),
            overflow: TextOverflow.fade,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: solidWhite,
            ),
          ),
        ),
        title: Text(
          "${feed['to']}:  ${feed['action']}",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Color:  ${feed['color']}",
            ),
            Text(
              DateFormat("MMM dd, yyyy")
                  .format(DateTime.parse(feed['createdAt']))
                  .toString(),
            ),
          ],
        ),
        trailing: Container(
          height: 55,
          width: 55,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: feed['action'] == "added"
                ? Colors.green
                : feed['action'] == "deleted"
                    ? Colors.red
                    : feed['action'] == "shared"
                        ? Colors.orange
                        : Colors.grey,
          ),
          child: Icon(
            feed['action'] == "added"
                ? FontAwesomeIcons.plusCircle
                : feed['action'] == "deleted"
                    ? FontAwesomeIcons.minusCircle
                    : feed['action'] == "shared"
                        ? FontAwesomeIcons.share
                        : FontAwesomeIcons.heartBroken,
            color: solidWhite,
          ),
        ),
      ),
    );
  }
}
