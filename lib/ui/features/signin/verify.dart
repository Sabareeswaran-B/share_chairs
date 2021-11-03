import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:share_chairs/common/constant.dart';
import 'package:share_chairs/ui/features/bottomnavbar.dart';
import 'package:share_chairs/ui/features/signin/signin_form.dart';

class PasswordVerify extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: _buildChild(context),
    );
  }

  _buildChild(BuildContext context) => Container(
        height: MediaQuery.of(context).size.height / 1.75,
        decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.all(Radius.circular(30))),
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 25),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Image.asset(
                  'assets/images/lock-overturning.png',
                  height: 150,
                  width: 150,
                ),
              ),
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12))),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Your password has \n been reset',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 20,
                  // color: Theme.of(context).textTheme.headline1.color,
                  fontWeight: FontWeight.normal),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 20, left: 20),
              child: Text(
                "You'll shortly receive an email with a code to setup a new password.",
                style: TextStyle(
                    // color: Theme.of(context).textTheme.headline1.color,
                    fontSize: 17),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 25,
            ),
            Container(
                height: 45,
                width: 200,
                decoration: new BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade300,
                      spreadRadius: 2,
                      blurRadius: 2,
                      offset: Offset(3, 3),
                    ),
                  ],
                ),
                margin: EdgeInsets.only(top: 20, bottom: 10),
                child: TextButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      CupertinoPageRoute(
                        builder: (BuildContext context) => SignIn(),
                      ),
                      (route) => false,
                    );
                  },
                  child: Text(
                    "Done",
                    style: TextStyle(
                        fontFamily: 'Avenir',
                        color: Colors.white,
                        fontSize: 20),
                  ),
                )),
          ],
        ),
      );
}

class EmailVerify extends StatefulWidget {
  @override
  _EmailVerifyState createState() => _EmailVerifyState();
}

class _EmailVerifyState extends State<EmailVerify> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    final user = _auth.currentUser;
    print("user name $user");
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: _buildChild(context),
    );
  }

  _buildChild(BuildContext context) => Container(
        height: MediaQuery.of(context).size.height / 1.75,
        decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.all(Radius.circular(30))),
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 25),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Image.asset(
                  'assets/images/lock-overturning2.png',
                  height: 150,
                  width: 150,
                ),
              ),
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12))),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Your email has been \n verified',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 20,
                  // color: Theme.of(context).textTheme.headline1.color,
                  fontWeight: FontWeight.normal),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 20, left: 20),
              child: Text(
                "You'll shortly receive an email with a confirmation message.",
                style: TextStyle(
                    // color: Theme.of(context).textTheme.headline1.color,
                    fontSize: 17),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 25,
            ),
            Container(
                height: 45,
                width: 200,
                decoration: new BoxDecoration(
                  // gradient: blueGradient,
                  color: primaryColor,
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade300,
                      spreadRadius: 2,
                      blurRadius: 2,
                      offset: Offset(3, 3),
                    ),
                  ],
                ),
                margin: EdgeInsets.only(top: 20, bottom: 10),
                child: TextButton(
                  onPressed: () {
                    // final user = _auth.currentUser;
                    Navigator.pushAndRemoveUntil(
                      context,
                      CupertinoPageRoute(
                          builder: (BuildContext context) => BottomNavBar()),
                      (route) => false,
                    );
                  },
                  child: Text(
                    "Done",
                    style: TextStyle(
                        fontFamily: 'Avenir',
                        color: Colors.white,
                        fontSize: 20),
                  ),
                )),
          ],
        ),
      );
}

class UserNotFound extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: _buildChild(context),
    );
  }

  _buildChild(BuildContext context) => Container(
        height: MediaQuery.of(context).size.height / 1.75,
        decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.all(Radius.circular(30))),
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 25),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Icon(
                  FontAwesomeIcons.exclamationCircle,
                  color: Theme.of(context).accentIconTheme.color,
                  size: 100,
                ),
              ),
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12))),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'No account associated with \n this email address',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 20,
                  // color: Theme.of(context).textTheme.headline1.color,
                  fontWeight: FontWeight.normal),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 20, left: 20),
              child: Text(
                "Retry with the correct email address of your account to change password.",
                style: TextStyle(
                    // color: Theme.of(context).textTheme.headline1.color,
                    fontSize: 17),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 25,
            ),
            Container(
                height: 45,
                width: 200,
                decoration: new BoxDecoration(
                  // gradient: blueGradient,
                  color: primaryColor,
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade300,
                      spreadRadius: 2,
                      blurRadius: 2,
                      offset: Offset(3, 3),
                    ),
                  ],
                ),
                margin: EdgeInsets.only(top: 20, bottom: 10),
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Retry",
                    style: TextStyle(
                        fontFamily: 'Avenir',
                        color: Colors.white,
                        fontSize: 20),
                  ),
                )),
          ],
        ),
      );
}
