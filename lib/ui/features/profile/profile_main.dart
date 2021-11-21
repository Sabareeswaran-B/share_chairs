import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:share_chairs/common/constant.dart';
import 'package:share_chairs/ui/features/profile/edit_profile.dart';

class ProfileMain extends StatefulWidget {
  const ProfileMain({Key? key}) : super(key: key);

  @override
  _ProfileMainState createState() => _ProfileMainState();
}

class _ProfileMainState extends State<ProfileMain> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    userData = getUser();
    super.initState();
  }

  late Future<Map<String, dynamic>> userData;

  Future<Map<String, dynamic>> getUser() async {
    final user = FirebaseAuth.instance.currentUser;
    var res = await FirebaseFirestore.instance
        .collection(USERS)
        .where("id", isEqualTo: user!.uid)
        .get();
    var doc = res.docs[0];
    print(doc.data());
    return doc.data();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: solidWhite,
        leading: null,
        centerTitle: true,
        title: Text(
          "Profile",
          style: TextStyle(
            color: primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      // drawer: Drawer(),
      body: Container(
        height: MediaQuery.of(context).size.height * 0.72,
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 25),
        decoration: BoxDecoration(
            color: solidWhite,
            borderRadius: BorderRadius.circular(35),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade300,
                spreadRadius: 5,
                blurRadius: 5,
              )
            ]),
        child: FutureBuilder<Map<String, dynamic>>(
            future: userData,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Icon(
                    FontAwesomeIcons.exclamationCircle,
                    color: primaryColor,
                    size: 60,
                  ),
                );
              }
              if (snapshot.hasData) {
                var user = snapshot.data!;
                return SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 25),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                        child: Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: primaryColor.withOpacity(0.1),
                              ),
                              child: user['imageUrl'] == null
                                  ? Icon(
                                      FontAwesomeIcons.userAlt,
                                      size: 55,
                                      color: primaryColor,
                                    )
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child: CachedNetworkImage(
                                        imageUrl: user['imageUrl'],
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                            ),
                            Container(
                              height: 35,
                              width: 35,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: primaryColor,
                              ),
                              child: IconButton(
                                onPressed: () async {
                                  var result = await Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (builder) => ProfileEdit()));
                                  if (result != null) {
                                    userData = getUser();
                                  }
                                },
                                icon: Icon(
                                  FontAwesomeIcons.pen,
                                  size: 18,
                                  color: solidWhite,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      Divider(
                          height: 15,
                          thickness: 0.7,
                          color: Colors.grey.shade400),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        horizontalTitleGap: 50,
                        title: Text(
                          "Name",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                        ),
                        subtitle: Text(
                          "${user['firstName']} ${user['lastName']}",
                          overflow: TextOverflow.ellipsis,
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
                            FontAwesomeIcons.user,
                            color: Colors.white,
                            size: 25,
                          ),
                        ),
                      ),
                      Divider(
                          height: 15,
                          thickness: 0.7,
                          color: Colors.grey.shade400),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        horizontalTitleGap: 50,
                        title: Text(
                          "Username",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                        ),
                        subtitle: Text(
                          "@${user['userName']}",
                          overflow: TextOverflow.ellipsis,
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
                            FontAwesomeIcons.user,
                            color: Colors.white,
                            size: 25,
                          ),
                        ),
                      ),
                      Divider(
                          height: 15,
                          thickness: 0.7,
                          color: Colors.grey.shade400),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        horizontalTitleGap: 50,
                        title: Text(
                          "Email",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                        ),
                        subtitle: Text(
                          user['email'],
                          overflow: TextOverflow.ellipsis,
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
                            FontAwesomeIcons.envelope,
                            color: Colors.white,
                            size: 25,
                          ),
                        ),
                      ),
                      Divider(
                          height: 15,
                          thickness: 0.7,
                          color: Colors.grey.shade400),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        horizontalTitleGap: 50,
                        title: Text(
                          "DOB",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                        ),
                        subtitle: Text(
                          DateFormat("MMM dd, yyyy")
                              .format(DateTime.parse(user['dob']))
                              .toString(),
                          overflow: TextOverflow.ellipsis,
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
                          height: 15,
                          thickness: 0.7,
                          color: Colors.grey.shade400),
                      // Center(
                      //   child: Container(
                      //     child: Text(
                      //       "Sabareeswaran B",
                      //       textAlign: TextAlign.center,
                      //       overflow: TextOverflow.ellipsis,
                      //       style: TextStyle(
                      //           color: solidBlack,
                      //           fontWeight: FontWeight.bold,
                      //           fontSize: 18),
                      //     ),
                      //   ),
                      // ),
                      // SizedBox(height: 5),
                      // Center(
                      //   child: Container(
                      //     child: Text(
                      //       "@sabarees",
                      //       textAlign: TextAlign.center,
                      //       overflow: TextOverflow.ellipsis,
                      //       style: TextStyle(
                      //           color: solidGrey,
                      //           fontWeight: FontWeight.normal,
                      //           fontSize: 14),
                      //     ),
                      //   ),
                      // ),
                      // SizedBox(height: 10),
                      // Center(
                      //   child: Container(
                      //     child: Text(
                      //       "sabareeswaran2510@gmail.com",
                      //       textAlign: TextAlign.center,
                      //       overflow: TextOverflow.ellipsis,
                      //       style: TextStyle(
                      //           color: solidBlack,
                      //           fontWeight: FontWeight.bold,
                      //           fontSize: 14),
                      //     ),
                      //   ),
                      // ),
                      // SizedBox(height: 10),
                      // Center(
                      //   child: Container(
                      //     child: Text(
                      //       "October 25, 1999",
                      //       textAlign: TextAlign.center,
                      //       overflow: TextOverflow.ellipsis,
                      //       style: TextStyle(
                      //           color: solidBlack,
                      //           fontWeight: FontWeight.bold,
                      //           fontSize: 14),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                );
              }

              return Center(
                  child: SpinKitCircle(
                color: primaryColor,
                size: 15,
              ));
            }),
      ),
    );
  }
}
