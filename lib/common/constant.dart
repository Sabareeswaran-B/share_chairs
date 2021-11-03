import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

GlobalKey<NavigatorState> navState = GlobalKey<NavigatorState>();

Color backgroundColor = Colors.grey[100]!;
Color solidBlack = Colors.black;
Color solidBlue = Colors.blue;
Color solidWhite = Colors.white;
Color solidGrey = Colors.grey;
Color primaryColor = Color(0xff800000);

//Firebase
const String USERS = 'users';
const String STATS = 'stats';
const String DETAILS = 'details';
const String NEWSFEED = 'newsFeed';
const ID = 'id';
const ROOM = 'room';

//Cache constants
const String USER = "User";
