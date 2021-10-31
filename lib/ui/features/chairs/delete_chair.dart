import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:share_chairs/common/constant.dart';

class Delete extends StatefulWidget {
  const Delete({Key? key}) : super(key: key);

  @override
  _DeleteState createState() => _DeleteState();
}

class _DeleteState extends State<Delete> {
  TextEditingController nos = TextEditingController();
  TextEditingController room = TextEditingController();
  TextEditingController color = TextEditingController();

  int _selectedRoom = 0;
  int _selectedColor = 0;
  List<String> rooms = [
    'Inventory',
    'VM Hall',
    'Kalam Hall',
    'Principal Office',
    'Other'
  ];
  List<String> colors = ['White', 'Sandal', 'Brown', 'Black', 'Other'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: solidWhite,
        leading: null,
        centerTitle: true,
        title: Text(
          "Delete Chairs",
          style: TextStyle(
            color: primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
          child: Container(
        padding: EdgeInsets.all(20),
        child: Form(
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
                color: primaryColor,
                borderRadius: BorderRadius.circular(15)
              ),
              child: TextButton(
                onPressed: () {
                  
                },
                child: Text(
                  'Delete chairs',
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
