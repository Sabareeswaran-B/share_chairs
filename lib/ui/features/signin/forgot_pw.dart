import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:share_chairs/common/constant.dart';
import 'package:share_chairs/ui/features/signin/dialog.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController _email = new TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  late User user;

  void _userverify() async {
      // if (user != null) {
    try {
      await _auth.sendPasswordResetEmail(email: _email.text);
      return await DialogHelper.exit(context);
    } catch (e) {
      print("error: $e");
      return await DialogHelper.failed(context);
    }
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          centerTitle: true,
          leading: Container(
              margin: EdgeInsets.only(right: 25),
              child: IconButton(
                icon: Icon(
                  Icons.chevron_left,
                  size: 35,
                  // color: theme.textTheme.headline1.color,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              )),
          title: Text("Forgot Password",
              style: TextStyle(
                fontFamily: 'Avenir',
                // color: theme.textTheme.headline1.color,
                fontSize: 20,
              ),
              textAlign: TextAlign.center)),
      body: Container(
        child: Column(
          children: [
            Container(
              height: 50,
              color: Colors.transparent,
            ),
            Container(
                margin: EdgeInsets.only(top: 75, left: 30, right: 30),
                child: Text(
                    "Enter your email address below and we'll send you an email with instructions on how to change your password",
                    style: TextStyle(
                      fontFamily: 'Avenir',
                      // color: primaryColor,
                      fontSize: 17,
                    ),
                    textAlign: TextAlign.left)),
            Container(
                margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                child: TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  keyboardType: TextInputType.emailAddress,
                  controller: _email,
                  decoration: InputDecoration(
                    hintText: 'Enter your Email',
                    hintStyle: TextStyle(color: primaryColor),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: primaryColor),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: primaryColor),
                    ),
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(color: primaryColor),
                    ),
                  ),
                  cursorColor: primaryColor,
                  validator: (value) =>
                      value!.isEmpty ? '*Please enter email address' : null,
                )),
            Container(
                height: 45,
                width: 200,
                decoration: new BoxDecoration(
                    // gradient: blueGradient,
                    color: primaryColor,
                    borderRadius: BorderRadius.all(Radius.circular(25))),
                margin: EdgeInsets.only(top: 50, bottom: 10),
                child: TextButton(
                  onPressed: () async {
                    // return await DialogHelper.exit(context);
                    _userverify();
                  },
                  child: Text(
                    "SEND",
                    style: TextStyle(
                        fontFamily: 'Avenir',
                        color: Colors.white,
                        fontSize: 20),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
