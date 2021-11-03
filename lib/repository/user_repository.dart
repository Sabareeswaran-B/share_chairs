// import 'package:http/http.dart' as http;
// import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:api_cache_manager/models/cache_db_model.dart';
import 'package:api_cache_manager/utils/cache_manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
import 'package:share_chairs/common/constant.dart';
import 'package:share_chairs/common/storage_manager.dart';

class UserRepository {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future signIn({email, password}) async {
    try {
      final User user = (await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      ))
          .user as User;
      // ignore: unnecessary_null_comparison
      if (user != null) {
        final QuerySnapshot result = await FirebaseFirestore.instance
            .collection(USERS)
            .where(ID, isEqualTo: user.uid)
            .get();
        final List<DocumentSnapshot> documents = result.docs;
        var userData = documents[0].data() as Map;
        String source = jsonEncode(userData);

        APICacheDBModel cacheDBModel =
            new APICacheDBModel(key: USER, syncData: source);
        await APICacheManager().addCacheData(cacheDBModel);
        StorageManager.saveData("email", userData['email']);
        StorageManager.saveData("userName", userData['userName']);
        StorageManager.saveData("firstName", userData['firstName']);
        StorageManager.saveData("lastName", userData['lastName']);
        StorageManager.saveData("role", userData['role']);
        // await getCurrentUser();
        // FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
        //      firebaseMessaging.getToken().then((value) {

        // });
        // var fcmToken = await firebaseMessaging.getToken();

        // ignore: unused_local_variable
        // final res = await FirebaseFirestore.instance
        //     .collection(USERS)
        //     .doc(user.uid)
        //     .set({
        //   'notificationTokens': FieldValue.arrayUnion([fcmToken.toString()])
        // }, SetOptions(merge: true)).then((value) => ("success"));
        return {'success': true, 'message': 'success'};
      } else {
        return {'success': false, 'message': "Signin Failed!"};
      }
    } on FirebaseAuthException catch (e) {
      return {'success': false, 'message': e.message};
    }
  }

  Future signUp({
    firstname,
    lastname,
    username,
    dob,
    email,
    password,
  }) async {
    try {
      final User user = (await auth.createUserWithEmailAndPassword(
              email: email, password: password))
          .user as User;

      // ignore: unnecessary_null_comparison
      if (user != null) {
        final QuerySnapshot result = await FirebaseFirestore.instance
            .collection(USERS)
            .where(ID, isEqualTo: user.uid)
            .get();
        final List<DocumentSnapshot> documents = result.docs;
        if (documents.isEmpty) {
          await FirebaseFirestore.instance.collection(USERS).doc(user.uid).set({
            'userName': username.trim(),
            'id': user.uid,
            "status": "Active",
            'language': 'English',
            'role': 'User',
            'firstName': firstname,
            'lastName': lastname,
            'dob': dob,
            'email': email,
          }, SetOptions(merge: true));
        } else {}
        return {'success': true, 'message': "signup successfull"};
      } else {
        return {'success': false, 'message': "signup failed"};
      }
    } on FirebaseAuthException catch (e) {
      return {'success': false, 'message': e.message};
    }
  }

  Future<bool> isSignedIn() async {
    final currentUser = auth.currentUser;
    return currentUser != null;
  }

  Future signOut() async {
    APICacheManager().deleteCache(USER);
    StorageManager.clear();
    await auth.signOut();
  }
}
