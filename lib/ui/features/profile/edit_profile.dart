import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:form_field_validator/form_field_validator.dart';
// import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:share_chairs/common/constant.dart';

class ProfileEdit extends StatefulWidget {
  const ProfileEdit({Key? key}) : super(key: key);

  @override
  _ProfileEditState createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController username = TextEditingController();
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController dob = TextEditingController();
  TextEditingController email = TextEditingController();
  DateTime selectedDate = DateTime.now();
  final ImagePicker _picker = ImagePicker();
  var imageFile;
  String imageUrl = "";
  bool clicked = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.chevron_left,
            size: 35,
          ),
        ),
        centerTitle: true,
        title: Text(
          "Profile Edit",
          style: TextStyle(
            color: solidWhite,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Padding(
                //   padding: const EdgeInsets.fromLTRB(80, 30, 80, 30),
                //   child: Image.asset(
                //     "assets/images/screenlogo.png",
                //     height: 50,
                //     width: 50,
                //   ),
                // ),
                formContent(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget formContent() {
    return Form(
        key: _formKey,
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                selectImage();
              },
              child: Container(
                height: 100,
                width: 100,
                margin: EdgeInsets.all(20),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    // ignore: unnecessary_null_comparison
                    child: imageFile != null
                        ? Image.file(
                            imageFile,
                            fit: BoxFit.cover,
                          )
                        : CircleAvatar(
                            child: Icon(FontAwesomeIcons.userAlt,
                                color: primaryColor, size: 35),
                            backgroundColor: primaryColor.withOpacity(0.1),
                          )),
              ),
            ),
            Text("Profile Picture", style: TextStyle(fontSize: 16)),
            SizedBox(
              height: 5,
            ),
            Text("( Optional )",
                style: TextStyle(fontSize: 14, color: Colors.grey)),
            SizedBox(
              height: 30,
            ),
            usernameTF(),
            firstNameTF(),
            lastNameTF(),
            dateofbirth(),
            emailTF(),
            SizedBox(
              height: 30,
            ),
            Container(
              width: 250,
              height: 50.0,
              decoration: BoxDecoration(
                color: clicked ? primaryColor.withOpacity(0.1) : primaryColor,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade300,
                    spreadRadius: 2,
                    blurRadius: 2,
                    offset: Offset(3, 3),
                  ),
                ],
              ),
              child: TextButton(
                onPressed: clicked
                    ? null
                    : () {
                        setState(() {
                          clicked = true;
                        });
                        if (imageFile != null) {
                          uploadPic(context);
                        } else {
                          postUserData();
                        }
                        // if (_formKey.currentState!.validate()) {
                        //   _formKey.currentState!.save();
                        // }
                      },
                child: clicked
                    ? Center(
                        child: SpinKitWave(
                          color: primaryColor,
                          size: 50,
                        ),
                      )
                    : Text(
                        'Save Changes',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ));
  }

  Future postUserData() async {
    try {
      List<Map> postData;
      postData = [
        {'key': 'imageUrl', 'value': imageUrl},
        {'key': 'userName', 'value': username.text},
        {'key': 'firstName', 'value': firstName.text},
        {'key': 'lastName', 'value': lastName.text},
        {'key': 'dateOfBirth', 'value': dob.text},
      ];
      print(postData);
      var user = await updateUser(postData);
      print(user);
      setState(() {
        clicked = false;
      });
      Navigator.pop(context, true);
    } catch (e) {
      print("Cant update $e");
    }
  }

  Future<dynamic> updateUser(List<Map> postData) async {
    try {
      final User user = FirebaseAuth.instance.currentUser!;
      final uid = user.uid;
      List<Map> listData = postData;
      Map mapData;
      mapData = Map.fromIterable(listData,
          key: (e) => e['key'], value: (e) => e['value']);
      mapData.removeWhere((key, value) => value == "" || value == null);
      print("list data $listData");
      print("Json data $mapData");
      await FirebaseFirestore.instance
          .collection(USERS)
          .doc(uid)
          .update(mapData.cast<String, Object?>());
    } catch (e) {
      print("update user catch $e");
    }
  }

  selectImage() {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
          title: const Text(
            "Upload Your Profile Picture",
          ),
          actions: <Widget>[
            CupertinoActionSheetAction(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    FontAwesomeIcons.camera,
                    size: 35,
                    color: solidBlue,
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Text(
                    "Camera",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  )
                ],
              ),
              onPressed: () {
                Navigator.pop(context);
                getImage(ImageSource.camera);
              },
            ),
            CupertinoActionSheetAction(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    FontAwesomeIcons.image,
                    size: 35,
                    color: solidBlue,
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Text(
                    "Gallery",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  )
                ],
              ),
              onPressed: () {
                Navigator.pop(context);
                getImage(ImageSource.gallery);
              },
            )
          ],
          cancelButton: CupertinoActionSheetAction(
            child: const Text('Cancel'),
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context, 'Cancel');
            },
          )),
    );
    // showModalBottomSheet(
    //     isScrollControlled: true,
    //     context: this.context,
    //     builder: (context) {
    //       return Container(
    //         height: MediaQuery.of(context).size.height * 0.3,
    //         padding: EdgeInsets.all(20),
    //         child: Column(
    //           mainAxisAlignment: MainAxisAlignment.spaceAround,
    //           children: [
    //             Text(
    //               "Upload Your Profile Picture",
    //               style: TextStyle(fontSize: 20),
    //             ),
    //             //
    //             Container(
    //               height: MediaQuery.of(context).size.height * 0.1,
    //               child: Row(
    //                 mainAxisAlignment: MainAxisAlignment.spaceAround,
    //                 crossAxisAlignment: CrossAxisAlignment.center,
    //                 children: [
    //                   InkWell(
    //                     onTap: () {
    //                       Navigator.pop(context);
    //                       getImage(ImageSource.camera);
    //                     },
    //                     child: Column(
    //                       mainAxisAlignment: MainAxisAlignment.spaceAround,
    //                       children: [
    //                         Icon(
    //                           Icons.camera,
    //                           size: 35,
    //                         ),
    //                         Text(
    //                           "Camera",
    //                           style: TextStyle(fontSize: 16),
    //                         )
    //                       ],
    //                     ),
    //                   ),
    //                   InkWell(
    //                     onTap: () {
    //                       Navigator.pop(context);
    //                       getImage(ImageSource.gallery);
    //                     },
    //                     child: Column(
    //                       mainAxisAlignment: MainAxisAlignment.spaceAround,
    //                       children: [
    //                         Icon(
    //                           Icons.photo_sharp,
    //                           size: 35,
    //                         ),
    //                         Text(
    //                           "Gallery",
    //                           style: TextStyle(fontSize: 16),
    //                         )
    //                       ],
    //                     ),
    //                   ),
    //                 ],
    //               ),
    //             ),
    //             //
    //           ],
    //         ),
    //       );
    //     });
  }

  Future uploadPic(BuildContext context) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference reference = FirebaseStorage.instance.ref().child(fileName);
    UploadTask uploadTask = reference.putFile(imageFile);
    try {
      TaskSnapshot snapshot = await uploadTask;
      String url = await snapshot.ref.getDownloadURL();
      setState(() {
        imageUrl = url;
        print("Image URL $imageUrl");
      });
      if (imageUrl != "") {
        postUserData();
      }
    } on FirebaseException catch (e) {
      Fluttertoast.showToast(msg: e.message ?? e.toString());
    }
  }

  getImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        print(pickedFile);
        imageFile = File(pickedFile.path);
      });
    }
  }

  Widget firstNameTF() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        cursorColor: primaryColor,
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.emailAddress,
        controller: firstName,
        decoration: InputDecoration(
          labelText: "First Name",
          labelStyle: TextStyle(color: primaryColor),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(
              color: primaryColor,
            ),
          ),
          hintText: 'First Name',
          prefixIcon: Icon(
            Icons.star,
            color: primaryColor,
            size: 10,
          ),
          hintStyle: TextStyle(color: Colors.grey),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(
              color: primaryColor,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(color: primaryColor),
          ),
        ),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: RequiredValidator(errorText: "First Name is Required"),
      ),
    );
  }

  Widget lastNameTF() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        cursorColor: primaryColor,
        controller: lastName,
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.name,
        decoration: InputDecoration(
          labelText: "Last Name",
          labelStyle: TextStyle(color: primaryColor),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(
              color: primaryColor,
            ),
          ),
          hintText: 'Last Name',
          prefixIcon: Icon(
            Icons.star,
            color: primaryColor,
            size: 10,
          ),
          hintStyle: TextStyle(color: Colors.grey),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(
              color: primaryColor,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(color: primaryColor),
          ),
        ),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: RequiredValidator(errorText: "Last Name is Required"),
      ),
    );
  }

  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate, // Refer step 1
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Center(
          child: Theme(
            child: child as Widget,
            data: ThemeData.light().copyWith(
              primaryColor: primaryColor,
              accentColor: primaryColor,
              colorScheme: ColorScheme.light(
                primary: primaryColor,
              ),
              buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
            ),
          ),
        );
      },
    ) as DateTime;
    if (picked != selectedDate)
      setState(() {
        selectedDate = picked;
        dob.text = DateFormat("yyyy-MM-dd").format(selectedDate);
      });
  }

  Widget dateofbirth() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        onTap: () {
          _selectDate(context);
        },
        controller: dob,
        cursorColor: primaryColor,
        textInputAction: TextInputAction.next,
        readOnly: true,
        decoration: InputDecoration(
          labelText: "Date of Birth",
          labelStyle: TextStyle(color: primaryColor),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(
              color: primaryColor,
            ),
          ),
          hintText: 'Date of Birth',
          prefixIcon: Icon(
            Icons.star,
            color: primaryColor,
            size: 10,
          ),
          suffixIcon: Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: Icon(
              Icons.date_range_outlined,
              color: primaryColor,
            ),
          ),
          hintStyle: TextStyle(color: Colors.grey),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(
              color: primaryColor,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(color: primaryColor),
          ),
        ),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: RequiredValidator(errorText: "Date of birth is Required"),
      ),
    );
  }

  Widget usernameTF() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.emailAddress,
          controller: username,
          cursorColor: primaryColor,
          // onSaved: (value) => username = value,
          decoration: InputDecoration(
            labelText: "Username",
            labelStyle: TextStyle(color: primaryColor),
            hintText: 'Username',
            prefixIcon: Icon(
              Icons.star,
              color: primaryColor,
              size: 10,
            ),
            hintStyle: TextStyle(color: Colors.grey),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12.0)),
              borderSide: BorderSide(color: primaryColor, width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12.0)),
              borderSide: BorderSide(color: primaryColor, width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              borderSide: BorderSide(color: primaryColor),
            ),
          ),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: MultiValidator([
            RequiredValidator(errorText: "Username is Required"),
            // PatternValidator(r"(?:[^a-z][a-z])",
            //     errorText: 'Username must be in lower case without white space')
          ])),
    );
  }

  Widget emailTF() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        //onSaved: (value) => email = value,
        controller: email,
        cursorColor: primaryColor,
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          labelText: "E-mail",
          labelStyle: TextStyle(color: primaryColor),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(
              color: primaryColor,
            ),
          ),
          hintText: 'E-mail',
          prefixIcon: Icon(
            Icons.star,
            color: primaryColor,
            size: 10,
          ),
          hintStyle: TextStyle(color: Colors.grey),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(
              color: primaryColor,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(color: primaryColor),
          ),
        ),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: MultiValidator([
          RequiredValidator(errorText: 'Email is required'),
          EmailValidator(errorText: 'Enter a valid email address')
        ]),
      ),
    );
  }
}
