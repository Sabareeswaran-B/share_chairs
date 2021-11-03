import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:share_chairs/common/constant.dart';

class ShareChairs extends StatefulWidget {
  const ShareChairs({Key? key}) : super(key: key);

  @override
  _ShareChairsState createState() => _ShareChairsState();
}

class _ShareChairsState extends State<ShareChairs> {
  TextEditingController nos = TextEditingController();
  TextEditingController room = TextEditingController();
  TextEditingController roomto = TextEditingController();
  TextEditingController color = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();


  int _selectedRoom = 0;
  int _selectedRoomto = 1;
  int _selectedColor = 0;
  List<String> rooms = [];
  List<String> roomsto = [];
  List<String> colors = ['White', 'Sandal', 'Brown', 'Black', 'Other'];

  bool shareClicked = false;

  @override
  void initState() {
    getData();
    super.initState();
  }

  Future getData() async {
    var res = await FirebaseFirestore.instance.collection(DETAILS).get();
    var doc = res.docs;
    rooms.addAll(doc.map((val) => val.data()['room']));
    rooms.removeWhere((element) => element == "broken");
    rooms.add("Other");
    roomsto = rooms;
  }

  Future shareChairs() async {
    if (roomsto[_selectedRoomto] != rooms[_selectedRoom]) {
      await deleteChairs();
    } else {
      Fluttertoast.showToast(
        msg: "From and to shoudn't be the same",
        backgroundColor: Colors.red,
      );
    }
  }

  Future addChairs() async {
    var res = await FirebaseFirestore.instance
        .collection(DETAILS)
        .where("room",
            isEqualTo: roomsto[_selectedRoomto] == "Other"
                ? roomto.text
                : roomsto[_selectedRoomto])
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
          "inService": roomsto[_selectedRoomto] == "Inventory"
              ? stats.docs[0]['inService'] - int.parse(nos.text)
              : stats.docs[0]['inService'],
          "Inventory": roomsto[_selectedRoomto] == "Inventory"
              ? stats.docs[0]['Inventory'] + int.parse(nos.text)
              : stats.docs[0]['Inventory'],
        }, SetOptions(merge: true));
        setState(() {
          color.clear();
          room.clear();
          roomto.clear();
          nos.clear();
          _selectedRoom = 0;
          _selectedRoomto = 0;
          _selectedColor = 0;
          shareClicked = false;
        });
        Fluttertoast.showToast(
          msg: "Successfully Shared",
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
          "room": roomsto[_selectedRoomto] == "Other"
              ? roomto.text
              : roomsto[_selectedRoomto],
          "chairs": {colors[_selectedColor]: int.parse(nos.text)}
        });
        await FirebaseFirestore.instance
            .collection(STATS)
            .doc(stats.docs[0].id)
            .set({
          "inService": roomsto[_selectedRoomto] == "Inventory"
              ? stats.docs[0]['inService'] - int.parse(nos.text)
              : stats.docs[0]['inService'],
          "Inventory": roomsto[_selectedRoomto] == "Inventory"
              ? stats.docs[0]['Inventory'] + int.parse(nos.text)
              : stats.docs[0]['Inventory'],
        }, SetOptions(merge: true));
        setState(() {
          color.clear();
          room.clear();
          roomto.clear();
          nos.clear();
          _selectedRoom = 0;
          _selectedRoomto = 0;
          _selectedColor = 0;
        });
        Fluttertoast.showToast(
          msg: "Successfully Shared",
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

  Future deleteChairs() async {
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
      if (chairs.containsKey(colors[_selectedColor])) {
        if (chairs[colors[_selectedColor]] >= int.parse(nos.text)) {
          var val = chairs.containsKey(colors[_selectedColor])
              ? chairs[colors[_selectedColor]] - int.parse(nos.text)
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
              "inService": rooms[_selectedRoom] == "Inventory"
                  ? stats.docs[0]['inService'] + int.parse(nos.text)
                  : stats.docs[0]['inService'],
              "Inventory": rooms[_selectedRoom] == "Inventory"
                  ? stats.docs[0]['Inventory'] - int.parse(nos.text)
                  : stats.docs[0]['Inventory'],
            }, SetOptions(merge: true));
            addChairs();
          } on FirebaseException catch (e) {
            print("firebase error $e");
            Fluttertoast.showToast(
              msg: "Somthing went wrong!",
              backgroundColor: Colors.red,
            );
          }
        } else {
          Fluttertoast.showToast(
            msg: "Exceeded the available chairs",
            backgroundColor: Colors.red,
          );
        }
      } else {
        Fluttertoast.showToast(
          msg: "${colors[_selectedColor]} is not in ${rooms[_selectedRoom]}",
          backgroundColor: Colors.red,
        );
      }
    } else {
      Fluttertoast.showToast(
        msg: "Somthing went wrong!",
        backgroundColor: Colors.red,
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: solidWhite,
        leading: IconButton(
          onPressed: () {
            _scaffoldKey.currentState!.openDrawer();
          },
          icon: Icon(
            Icons.menu,
            color: primaryColor,
          ),
        ),
        centerTitle: true,
        title: Text(
          "Share Chairs",
          style: TextStyle(
            color: primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      drawer: Drawer(),
      body: SingleChildScrollView(
          child: Container(
        padding: EdgeInsets.all(20),
        child: rooms.isEmpty && roomsto.isEmpty
            ? SizedBox()
            : Form(
                child: Column(
                  children: [
                    colorTF(),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 15),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "From:",
                        style: TextStyle(color: primaryColor),
                      ),
                    ),
                    roomTF(),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 15),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "To:",
                        style: TextStyle(color: primaryColor),
                      ),
                    ),
                    roomtoTF(),
                    nosTF(),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      width: 300,
                      height: 50.0,
                      decoration: BoxDecoration(
                          color: shareClicked ? Colors.grey[400] : primaryColor,
                          borderRadius: BorderRadius.circular(15)),
                      child: TextButton(
                        onPressed: shareClicked
                            ? null
                            : () {
                                setState(() {
                                  shareClicked = true;
                                });
                                shareChairs();
                              },
                        child: shareClicked
                            ? Center(
                                child: SpinKitWave(
                                  color: primaryColor,
                                  size: 50,
                                ),
                              )
                            : Text(
                                'Share chairs',
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
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
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
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(color: primaryColor, width: 1.5),
              ),
              child: DropdownButtonFormField(
                // onSaved: (value) => profession = value,
                isExpanded: true,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: Color(0xffedeff5)),
                  ),
                  focusColor: primaryColor,
                  contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 0.0, 15.0),
                  prefixIcon: Icon(
                    Icons.star,
                    color: primaryColor,
                    size: 10,
                  ),
                  hintText: "From Room name",
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
                  if (value == null) return "Room name is Required to move";
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
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide(color: primaryColor, width: 1.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide(color: primaryColor, width: 1.5),
                ),
              ),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: RequiredValidator(errorText: "Room name is Required"),
            ),
    );
  }

  Widget roomtoTF() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: roomsto[_selectedRoomto] != "Other"
          ? Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(color: primaryColor, width: 1.5),
              ),
              child: DropdownButtonFormField(
                // onSaved: (value) => profession = value,
                isExpanded: true,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: Color(0xffedeff5)),
                  ),
                  focusColor: primaryColor,
                  contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 0.0, 15.0),
                  prefixIcon: Icon(
                    Icons.star,
                    color: primaryColor,
                    size: 10,
                  ),
                  hintText: "To Room name",
                  hintStyle: TextStyle(color: primaryColor),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        BorderSide(width: 1.5, style: BorderStyle.solid),
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                ),

                iconEnabledColor: primaryColor,
                value: roomsto[_selectedRoomto],
                items: roomsto.map(
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
                    _selectedRoomto = roomsto.indexOf(value!);
                  });
                },

                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value == null) return "To Room name is Required";
                  return null;
                },
                //validator: RequiredValidator(errorText: "Profession is Required"),
              ),
            )
          : TextFormField(
              autofocus: true,
              // onSaved: (value) => rooms = value!,
              controller: roomto,
              cursorColor: primaryColor,
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                labelText: "Enter the Room name move to",
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
                      _selectedRoomto = 0;
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
              validator:
                  RequiredValidator(errorText: "Room name is Required to move"),
            ),
    );
  }

  Widget colorTF() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: colors[_selectedColor] != "Other"
          ? Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(color: primaryColor, width: 1.5),
              ),
              child: DropdownButtonFormField(
                // onSaved: (value) => profession = value,
                isExpanded: true,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: Color(0xffedeff5)),
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
