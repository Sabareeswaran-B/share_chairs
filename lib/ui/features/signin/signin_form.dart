import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:share_chairs/common/constant.dart';
import 'package:share_chairs/ui/features/bottomnavbar.dart';
import 'package:share_chairs/ui/features/signin/bloc/signin_bloc.dart';
import 'package:share_chairs/ui/features/signin/forgot_pw.dart';
import 'package:share_chairs/ui/features/signup/signup_form.dart';

class SignIn extends StatelessWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SigninBloc(),
      child: Overlay(
        initialEntries: [
          OverlayEntry(
            builder: (context) => SignInForm(),
          ),
        ],
      ),
    );
  }
}

class SignInForm extends StatefulWidget {
  const SignInForm({Key? key}) : super(key: key);

  @override
  _SignInFormState createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String email, password;

  bool _obscureTextPassword = true;
  @override
  Widget build(BuildContext context) {
    return BlocListener<SigninBloc, SigninState>(
      listener: (context, state) {
        if (state is SigninLoading) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Logging in..."),
            ),
          );
        } else if (state is SigninSuccess) {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (builder) => BottomNavBar(),
              ),
              (route) => false);
        } else if (state is SigninFailure) {
          // Object error = state.props[0];
          Fluttertoast.showToast(
              msg: "Signin Failed",
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
            "Sign In",
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(60.0),
                    child: Column(
                      children: [],
                    ),
                  ),
                  formContent(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget formContent() {
    void login() {
      BlocProvider.of<SigninBloc>(context).add(
        SigninButtonPressed(
          email: email,
          password: password,
        ),
      );
    }

    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            emailTextField(),
            SizedBox(
              height: 10,
            ),
            passwordTextField(),
            SizedBox(
              height: 30,
            ),
            Container(
              width: 250,
              height: 50.0,
              decoration: BoxDecoration(
                  color: primaryColor, borderRadius: BorderRadius.circular(15)),
              child: TextButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    login();
                  }
                },
                child: Text(
                  'Sign In',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  new MaterialPageRoute(
                    builder: (context) => ForgotPassword(),
                  ),
                );
                // Navigator.pushNamed(context, "/forgotpassword");
              },
              child: Text(
                "Forgot password?",
                style: TextStyle(
                    color: Colors.blue,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            TextButton(
              onPressed: () {
                // Navigator.pushNamed(context, "/signup");
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => SignUp()));
              },
              child: new RichText(
                text: new TextSpan(
                  // text: 'Don’t have an account?',
                  // style: TextStyle(
                  //   color: Theme.of(context).textTheme.bodyText1.color,
                  //   fontSize: 16,
                  // ),
                  children: <TextSpan>[
                    new TextSpan(
                      text: ' Create new account',
                      style: new TextStyle(
                          color: Colors.blue,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget passwordTextField() {
    return TextFormField(
      onSaved: (value) => password = value!,
      cursorColor: primaryColor,
      textInputAction: TextInputAction.done,
      obscureText: _obscureTextPassword,
      decoration: InputDecoration(
        suffixIcon: IconButton(
          icon: Icon(
            _obscureTextPassword ? Icons.visibility_off : Icons.visibility,
            color: _obscureTextPassword ? solidGrey : primaryColor,
          ),
          onPressed: () {
            setState(() => _obscureTextPassword = !_obscureTextPassword);
          },
        ),
        hintText: 'Password',
        prefixIcon: Icon(
          Icons.lock,
          color: primaryColor,
        ),
        hintStyle: TextStyle(color: primaryColor),
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
        RequiredValidator(errorText: 'password is required'),
        // MinLengthValidator(8,
        //     errorText: 'password must be at least 8 digits long'),
      ]),
    );
  }

  Widget emailTextField() {
    return TextFormField(
      onSaved: (value) => email = value!,
      cursorColor: primaryColor,
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          borderSide: BorderSide(
            color: primaryColor,
          ),
        ),
        hintText: 'Email',
        prefixIcon: Icon(
          Icons.email,
          color: primaryColor,
        ),
        hintStyle: TextStyle(color: primaryColor),
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
    );
  }
}
