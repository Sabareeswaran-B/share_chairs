import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:share_chairs/common/storage_manager.dart';
import 'package:share_chairs/repository/user_repository.dart';
import 'package:share_chairs/ui/features/bottomnavbar.dart';
import 'package:share_chairs/common/constant.dart';
import 'package:share_chairs/ui/features/signin/signin_form.dart';

class MenuBar extends StatefulWidget {
  const MenuBar({Key? key}) : super(key: key);

  @override
  _MenuBarState createState() => _MenuBarState();
}

class _MenuBarState extends State<MenuBar> {
  var imageUrl = "";
  var userName = "";
  var email = "";

  Future getUser() async {
    StorageManager.readData('userName').then((value) {
      setState(() {
        userName = value ?? "";
      });
    });
    StorageManager.readData('email').then((value) {
      setState(() {
        email = value ?? "";
      });
    });
    StorageManager.readData('imageUrl').then((value) {
      setState(() {
        imageUrl = value ?? "";
      });
    });
    return {
      "imageUrl": imageUrl,
      "userName": userName,
      "email": email,
    };
  }

  @override
  void initState() {
    super.initState();
    userData = getUser();
  }

  late Future userData;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        children: [
          SizedBox(
            height: 25,
          ),
          FutureBuilder(
              future: userData,
              builder: (builder, snapshot) {
                if (!snapshot.hasData)
                  return Center(child: CupertinoActivityIndicator());
                return GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                        context,
                        CupertinoPageRoute(
                            builder: (context) => BottomNavBar(index: 3)));
                  },
                  child: Container(
                    child: Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(right: 10, left: 10),
                          child: Stack(
                            alignment: AlignmentDirectional.bottomEnd,
                            children: [
                              Container(
                                height: 70,
                                width: 70,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: Colors.grey[400],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: imageUrl == ""
                                      ? Icon(FontAwesomeIcons.userAlt,
                                          color: primaryColor, size: 40)
                                      : CachedNetworkImage(
                                          alignment: Alignment.center,
                                          errorWidget: (context, url, error) =>
                                              Icon(Icons.error),
                                          placeholder: (context, url) =>
                                              new Center(
                                                  child: SpinKitCircle(
                                            color: primaryColor,
                                            size: 50,
                                          )),
                                          imageUrl: imageUrl,
                                          fit: BoxFit.cover,
                                        ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                width: MediaQuery.of(context).size.width / 2.4,
                                child: Text(
                                  userName,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: primaryColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                )),
                            Container(
                                width: MediaQuery.of(context).size.width / 2.5,
                                child: Text(
                                  email,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: solidGrey,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                )),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              }),
          SizedBox(
            height: 25,
          ),
          GestureDetector(
            onTap: () {
              
            },
            child: Container(
              margin: EdgeInsets.only(left: 20, top: 5),
              child: Row(
                children: [
                  Container(
                      height: 45,
                      width: 45,
                      padding: EdgeInsets.all(11),
                      child: Container(
                          child: Icon(
                        FontAwesomeIcons.solidPlusSquare,
                        color: primaryColor,
                      ))),
                  SizedBox(width: 10),
                  Container(
                      child: Text(
                    "Add Rental Chairs",
                    style: TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  )),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              UserRepository().signOut().whenComplete(
                    () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SignIn(),
                      ),
                    ),
                  );
            },
            child: Container(
              margin: EdgeInsets.only(left: 20, top: 5),
              child: Row(
                children: [
                  Container(
                      height: 45,
                      width: 45,
                      padding: EdgeInsets.all(11),
                      child: Container(
                          child: Icon(
                        FontAwesomeIcons.signOutAlt,
                        color: primaryColor,
                      ))),
                  SizedBox(width: 10),
                  Container(
                      child: Text(
                    "Sign Out",
                    style: TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
