import 'package:flutter/material.dart';
import 'package:share_chairs/ui/features/signin/verify.dart';

class DialogHelper {
  static exit(context) =>
      showDialog(context: context, builder: (context) => PasswordVerify());
  static verify(context) => showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => EmailVerify());
  static failed(context) => showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => UserNotFound());
}