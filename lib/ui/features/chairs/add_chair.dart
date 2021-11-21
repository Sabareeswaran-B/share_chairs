import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:share_chairs/common/constant.dart';
import 'package:share_chairs/repository/user_repository.dart';

class AddChairs extends StatefulWidget {
  const AddChairs({Key? key}) : super(key: key);

  @override
  _AddChairsState createState() => _AddChairsState();
}

class _AddChairsState extends State<AddChairs> {
  TextEditingController nos = TextEditingController();
  TextEditingController room = TextEditingController();
  TextEditingController color = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int _selectedRoom = 0;
  int _selectedColor = 0;
  List<String> rooms = [];
  List<String> colors = ['White', 'Sandal', 'Brown', 'Black'];

  bool addClicked = false;

  @override
  void initState() {
    getData();
    super.initState();
  }

  Future getData() async {
    var res = await FirebaseFirestore.instance.collection(DETAILS).get();
    var doc = res.docs;
    rooms.addAll(doc.map((val) => val.data()['room']));
    rooms.removeWhere((element) => element == "Broken");
    rooms.add("Other");
  }

  addChairs() async {
    var res = await FirebaseFirestore.instance
        .collection(DETAILS)
        .where("room",
            isEqualTo: rooms[_selectedRoom] == "Other"
                ? room.text
                : rooms[_selectedRoom])
        .get();
    var stats = await FirebaseFirestore.instance
        .collection(STATS)
        .where("collegeName", isEqualTo: "RVSCAS")
        .get();
    var doc = res.docs;
    if (doc.isNotEmpty) {
      Map chairs = doc[0].data()['chairs'];
      var val = chairs.containsKey(colors[_selectedColor])
          ? int.parse(nos.text) + chairs[colors[_selectedColor]]
          : int.parse(nos.text);
      try {
        await FirebaseFirestore.instance
            .collection(DETAILS)
            .doc(doc[0].id)
            .set({
          "chairs": {colors[_selectedColor]: val}
        }, SetOptions(merge: true));
        await FirebaseFirestore.instance
            .collection(STATS)
            .doc(stats.docs[0].id)
            .set({
          "gross": stats.docs[0]['gross'] + int.parse(nos.text),
          "inService": rooms[_selectedRoom] == "Inventory"
              ? stats.docs[0]['inService']
              : stats.docs[0]['inService'] + int.parse(nos.text),
          "Inventory": rooms[_selectedRoom] == "Inventory"
              ? stats.docs[0]['Inventory'] + int.parse(nos.text)
              : stats.docs[0]['Inventory'],
        }, SetOptions(merge: true));
        await UserRepository().addtoFeed(
          "new",
          rooms[_selectedRoom] == "Other" ? room.text : rooms[_selectedRoom],
          colors[_selectedColor],
          "added",
          int.parse(nos.text),
        );
        setState(() {
          color.clear();
          room.clear();
          nos.clear();
          _selectedRoom = 0;
          _selectedColor = 0;
          addClicked = false;
        });
        Fluttertoast.showToast(
          msg: "Successfully Added",
          backgroundColor: Colors.green,
        );
      } on FirebaseException catch (e) {
        print("firebase error $e");
        Fluttertoast.showToast(
          msg: "Somthing went wrong!",
          backgroundColor: Colors.red,
        );
      }
    } else {
      try {
        await FirebaseFirestore.instance.collection(DETAILS).add({
          "room": rooms[_selectedRoom] == "Other"
              ? room.text
              : rooms[_selectedRoom],
          "chairs": {colors[_selectedColor]: int.parse(nos.text)}
        });
        await FirebaseFirestore.instance
            .collection(STATS)
            .doc(stats.docs[0].id)
            .set({
          "gross": stats.docs[0]['gross'] + int.parse(nos.text),
          "inService": rooms[_selectedRoom] == "Inventory"
              ? stats.docs[0]['inService']
              : stats.docs[0]['inService'] + int.parse(nos.text),
          "Inventory": rooms[_selectedRoom] == "Inventory"
              ? stats.docs[0]['Inventory'] + int.parse(nos.text)
              : stats.docs[0]['Inventory'],
        }, SetOptions(merge: true));
        setState(() {
          color.clear();
          room.clear();
          nos.clear();
          _selectedRoom = 0;
          _selectedColor = 0;
        });
        Fluttertoast.showToast(
          msg: "Successfully Added",
          backgroundColor: Colors.green,
        );
      } on FirebaseException catch (e) {
        print("firebase error $e");
        Fluttertoast.showToast(
          msg: "Somthing went wrong!",
          backgroundColor: Colors.red,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: solidWhite,
        leading: null,
        centerTitle: true,
        title: Text(
          "Add Chairs",
          style: TextStyle(
            color: primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      // drawer: Drawer(),
      body: SingleChildScrollView(
          child: Container(
        padding: EdgeInsets.all(20),
        child: rooms.isEmpty
            ? SizedBox()
            : Form(
                child: Column(
                  children: [
                    colorTF(),
                    roomTF(),
                    nosTF(),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      width: 300,
                      height: 50.0,
                      decoration: BoxDecoration(
                          color: addClicked ? Colors.grey[400] : primaryColor,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade300,
                              spreadRadius: 2,
                              blurRadius: 2,
                              offset: Offset(3, 3),
                            )
                          ]),
                      child: TextButton(
                        onPressed: addClicked
                            ? null
                            : () async {
                                setState(() {
                                  addClicked = true;
                                });
                                addChairs();
                              },
                        child: addClicked
                            ? Center(
                                child: SpinKitWave(
                                  color: primaryColor,
                                  size: 50,
                                ),
                              )
                            : Text(
                                'Add new chairs',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.center,
                              ),
                      ),
                    ),
                  ],
                ),
              ),
      )),
    );
  }

  Widget nosTF() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
          textInputAction: TextInputAction.done,
          keyboardType: TextInputType.number,
          controller: nos,
          decoration: InputDecoration(
            labelText: "Number of chairs",
            labelStyle: TextStyle(color: primaryColor),
            prefixIcon: Icon(
              Icons.star,
              color: primaryColor,
              size: 10,
            ),
            hintStyle: TextStyle(color: primaryColor),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12.0)),
              borderSide: BorderSide(color: primaryColor, width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12.0)),
              borderSide: BorderSide(color: primaryColor, width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12.0)),
              borderSide: BorderSide(color: primaryColor, width: 1.5),
            ),
          ),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: MultiValidator([
            RequiredValidator(errorText: "Number of chairs is Required"),
            // PatternValidator(r"(?:[^a-z][a-z])",
            //     errorText: 'Username must be in lower case without white space')
          ])),
    );
  }

  Widget roomTF() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: rooms[_selectedRoom] != "Other"
          ? Container(
              // decoration: BoxDecoration(
              //   borderRadius: BorderRadius.circular(10.0),
              //   border: Border.all(color: primaryColor, width: 1.5),
              // ),
              child: DropdownButtonFormField(
                // onSaved: (value) => profession = value,
                isExpanded: true,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12.0)),
                    borderSide: BorderSide(color: primaryColor, width: 1.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: primaryColor, width: 1.5),
                  ),
                  focusColor: primaryColor,
                  contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 0.0, 15.0),
                  prefixIcon: Icon(
                    Icons.star,
                    color: primaryColor,
                    size: 10,
                  ),
                  hintText: "Room name",
                  hintStyle: TextStyle(color: primaryColor),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        BorderSide(width: 1.5, style: BorderStyle.solid),
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                ),

                iconEnabledColor: primaryColor,
                value: rooms[_selectedRoom],
                items: rooms.map(
                  (String value) {
                    return new DropdownMenuItem<String>(
                      value: value,
                      child: new Text(
                        value,
                        style: TextStyle(color: primaryColor),
                      ),
                    );
                  },
                ).toList(),

                onChanged: (String? value) {
                  this.setState(() {
                    _selectedRoom = rooms.indexOf(value!);
                  });
                },

                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value == null) return "Room name is Required";
                  return null;
                },
                //validator: RequiredValidator(errorText: "Profession is Required"),
              ),
            )
          : TextFormField(
              autofocus: true,
              // onSaved: (value) => rooms = value!,
              controller: room,
              cursorColor: primaryColor,
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                labelText: "Enter the Room name",
                labelStyle: TextStyle(color: primaryColor),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12.0)),
                  borderSide: BorderSide(color: primaryColor, width: 1),
                ),
                // hintText: 'Enter the Profession',
                prefixIcon: Icon(
                  Icons.star,
                  color: primaryColor,
                  size: 10,
                ),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _selectedRoom = 0;
                    });
                  },
                  icon: Icon(
                    Icons.clear_rounded,
                    color: primaryColor,
                  ),
                ),
                hintStyle: TextStyle(color: Colors.grey),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12.0)),
                  borderSide: BorderSide(color: primaryColor, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12.0)),
                  borderSide: BorderSide(color: primaryColor, width: 1),
                ),
              ),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: RequiredValidator(errorText: "Room name is Required"),
            ),
    );
  }

  Widget colorTF() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: colors[_selectedColor] != "Other"
          ? Container(
              // decoration: BoxDecoration(
              //   borderRadius: BorderRadius.circular(10.0),
              //   border: Border.all(color: primaryColor, width: 1.5),
              // ),
              child: DropdownButtonFormField(
                // onSaved: (value) => profession = value,
                isExpanded: true,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12.0)),
                    borderSide: BorderSide(color: primaryColor, width: 1.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: primaryColor, width: 1.5),
                  ),
                  focusColor: primaryColor,
                  contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 0.0, 15.0),
                  prefixIcon: Icon(
                    Icons.star,
                    color: primaryColor,
                    size: 10,
                  ),
                  hintText: "Color",
                  hintStyle: TextStyle(color: primaryColor),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        BorderSide(width: 1.5, style: BorderStyle.solid),
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                ),

                iconEnabledColor: primaryColor,
                value: colors[_selectedColor],
                items: colors.map(
                  (String value) {
                    return new DropdownMenuItem<String>(
                      value: value,
                      child: new Text(
                        value,
                        style: TextStyle(color: primaryColor),
                      ),
                    );
                  },
                ).toList(),

                onChanged: (String? value) {
                  this.setState(() {
                    _selectedColor = colors.indexOf(value!);
                  });
                },

                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value == null) return "Color is Required";
                  return null;
                },
                //validator: RequiredValidator(errorText: "Profession is Required"),
              ),
            )
          : TextFormField(
              autofocus: true,
              // onSaved: (value) => rooms = value!,
              controller: color,
              cursorColor: primaryColor,
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                labelText: "Enter the Color",
                labelStyle: TextStyle(color: primaryColor),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide(
                    color: Color(0xffedeff5),
                  ),
                ),
                // hintText: 'Enter the Profession',
                prefixIcon: Icon(
                  Icons.star,
                  color: primaryColor,
                  size: 10,
                ),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _selectedColor = 0;
                    });
                  },
                  icon: Icon(
                    Icons.clear_rounded,
                    color: primaryColor,
                  ),
                ),
                hintStyle: TextStyle(color: Colors.grey),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide(color: primaryColor, width: 1.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide(color: primaryColor, width: 1.5),
                ),
              ),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: RequiredValidator(errorText: "Color is Required"),
            ),
    );
  }
}
