import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:share_chairs/common/constant.dart';
import 'package:share_chairs/ui/features/signin/signin_form.dart';
import 'package:share_chairs/ui/features/signup/bloc/signup_bloc.dart';

class SignUp extends StatelessWidget {
  const SignUp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignupBloc(),
      child: Overlay(
        initialEntries: [
          OverlayEntry(
            builder: (context) => SignUpForm(),
          ),
        ],
      ),
    );
  }
}

class SignUpForm extends StatefulWidget {
  const SignUpForm({Key? key}) : super(key: key);

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController username = TextEditingController();
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController dob = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmpassword = TextEditingController();
  bool _obscurePassword = true, _obscureConfirmPassword = true;
  bool focus = false;
  DateTime selectedDate = DateTime.now();
  final ImagePicker _picker = ImagePicker();
  late File imageFile;
  @override
  Widget build(BuildContext context) {
    return BlocListener<SignupBloc, SignupState>(
        listener: (context, state) {
          if (state is SignupLoading) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Signing up..."),
              ),
            );
          } else if (state is SignupSuccess) {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (builder) => SignIn()),
                (route) => false);
          } else if (state is SignupFailure) {
            Fluttertoast.showToast(
                msg: "Signup Failed",
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: primaryColor,
                textColor: Colors.white,
                fontSize: 17.0);
          }
        },
        child: Scaffold(
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
              "Sign Up",
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
        ));
  }

  selectImage() {
    showModalBottomSheet(
        isScrollControlled: true,
        context: this.context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.3,
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  "Upload Your Profile Picture",
                  style: TextStyle(fontSize: 20),
                ),
                //
                Container(
                  height: MediaQuery.of(context).size.height * 0.1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          getImage(ImageSource.camera);
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Icon(
                              Icons.camera,
                              size: 35,
                            ),
                            Text(
                              "Camera",
                              style: TextStyle(fontSize: 16),
                            )
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          getImage(ImageSource.gallery);
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Icon(
                              Icons.photo_sharp,
                              size: 35,
                            ),
                            Text(
                              "Gallery",
                              style: TextStyle(fontSize: 16),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                //
              ],
            ),
          );
        });
  }

  // _pickImage(source) async {
  //   final pickedFile = await _picker.pickImage(source: source);
  //   if (pickedFile != null) {
  //     if (!mounted) return;
  //     setState(() {
  //       imageFile = File(pickedFile.path);
  //     });
  //   }
  // }

  getImage(ImageSource source) async {
    XFile? image = await _picker.pickImage(source: source);
    if (image != null) {
      File cropped = await ImageCropper.cropImage(
          sourcePath: image.path,
          aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
          compressQuality: 100,
          maxWidth: 700,
          maxHeight: 700,
          compressFormat: ImageCompressFormat.jpg,
          androidUiSettings: AndroidUiSettings(
            toolbarColor: primaryColor,
            toolbarTitle: "Set an image",
            toolbarWidgetColor: Colors.white,
            //statusBarColor: primaryColor.withOpacity(0.3),
            backgroundColor: Colors.black,
          )) as File;
      this.setState(() {
        imageFile = cropped;
      });
    }
  }

  Widget formContent() {
    void signup() async {
      BlocProvider.of<SignupBloc>(context).add(
        SignupButtonPressed(
          firstName: firstName.text,
          lastName: lastName.text,
          dateofbirth: dob.text,
          userName: username.text,
          email: email.text,
          password: password.text,
        ),
      );
    }

    return Form(
        key: _formKey,
        child: Column(
          children: [
            // GestureDetector(
            //   onTap: () {
            //     selectImage();
            //   },
            //   child: Container(
            //     height: 100,
            //     width: 100,
            //     margin: EdgeInsets.all(20),
            //     child: ClipRRect(
            //         borderRadius: BorderRadius.circular(100),
            //         // ignore: unnecessary_null_comparison
            //         child: imageFile != null
            //             ? Image.file(
            //                 imageFile,
            //                 fit: BoxFit.cover,
            //               )
            //             : CircleAvatar(
            //                 child: Icon(
            //                   Icons.person,
            //                   color: primaryColor,
            //                 ),
            //                 backgroundColor: primaryColor[100],
            //               )),
            //   ),
            // ),
            // Text("Profile Picture", style: TextStyle(fontSize: 16)),
            // SizedBox(
            //   height: 5,
            // ),
            // Text("( Optional )",
            //     style: TextStyle(fontSize: 14, color: Colors.grey)),
            // SizedBox(
            //   height: 30,
            // ),
            usernameTF(),
            firstNameTF(),
            lastNameTF(),
            dateofbirth(),
            emailTF(),
            passwordTF(),
            confirmPasswordTF(),
            SizedBox(
              height: 30,
            ),
            Container(
              width: 250,
              height: 50.0,
              decoration: BoxDecoration(
                color: primaryColor,
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
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    if (password.text == confirmpassword.text) {
                      signup();
                    } else {}
                  }
                },
                child: Text(
                  'Sign Up',
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
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: RichText(
                text: TextSpan(
                  text: 'Already have an account?',
                  style: TextStyle(
                    color: primaryColor,
                    fontSize: 16,
                  ),
                  children: <TextSpan>[
                    new TextSpan(
                      text: ' Login here',
                      style: TextStyle(
                        color: solidBlue,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ));
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

  Widget passwordTF() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: password,
        // onSaved: (value) => password = value,
        cursorColor: primaryColor,
        textInputAction: TextInputAction.done,
        obscureText: _obscurePassword,
        decoration: InputDecoration(
          labelText: "Password",
          labelStyle: TextStyle(color: primaryColor),
          suffixIcon: IconButton(
            icon: Icon(
              _obscurePassword ? Icons.visibility_off : Icons.visibility,
              color: _obscurePassword ? Colors.grey : primaryColor,
            ),
            onPressed: () {
              if (!mounted) return;
              setState(() => _obscurePassword = !_obscurePassword);
            },
          ),
          hintText: 'Password',
          prefixIcon: Icon(
            Icons.star,
            color: primaryColor,
            size: 10,
          ),
          hintStyle: TextStyle(color: Colors.grey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(
              color: primaryColor,
            ),
          ),
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
          RequiredValidator(errorText: 'Password is required'),
          MinLengthValidator(8,
              errorText: 'Password must be at least 8 digits long'),
          PatternValidator(r'(?=.*?[#?!@$%^&*-])',
              errorText: 'Passwords must have at least one special character')
        ]),
      ),
    );
  }

  Widget confirmPasswordTF() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: confirmpassword,
        // onSaved: (value) => confirmpassword = value,
        cursorColor: primaryColor,
        textInputAction: TextInputAction.done,
        obscureText: _obscureConfirmPassword,
        decoration: InputDecoration(
          labelText: "Confirm Password",
          labelStyle: TextStyle(color: primaryColor),
          suffixIcon: IconButton(
            icon: Icon(
              _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
              color: _obscureConfirmPassword ? Colors.grey : primaryColor,
            ),
            onPressed: () {
              if (!mounted) return;
              setState(
                  () => _obscureConfirmPassword = !_obscureConfirmPassword);
            },
          ),
          hintText: 'Confirm Password',
          prefixIcon: Icon(
            Icons.star,
            color: primaryColor,
            size: 10,
          ),
          hintStyle: TextStyle(color: Colors.grey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(
              color: primaryColor,
            ),
          ),
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
        validator: (val) =>
            MatchValidator(errorText: 'Please ensure passwords match')
                .validateMatch(val!, password.text),
      ),
    );
  }

}
