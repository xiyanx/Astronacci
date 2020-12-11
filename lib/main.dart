import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:astronacci/ui/home/A_home.dart';
import 'package:astronacci/ui/home/B_home.dart';
import 'package:astronacci/ui/home/C_home.dart';
import 'package:astronacci/ui/home.dart';
import 'package:astronacci/ui/login.dart';
import 'package:astronacci/utils/auth_helper.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Astronacci App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if(snapshot.hasData && snapshot.data != null) {
          UserHelper.saveUser(snapshot.data);
          return StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance.collection("users").doc(snapshot.data.uid).snapshots() ,
            builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot){
              if(snapshot.hasData && snapshot.data != null) {
                final userDoc = snapshot.data;
                final user = userDoc.data();
                if(user['role'] == 'A') {
                  return AHomePage();
                }
                if(user['role'] == 'B') {
                  return BHomePage();
                }
                if(user['role'] == 'C') {
                  return CHomePage();
                }else{
                  return HomePage();
                }
              }else{
                return Material(
                  child: Center(child: CircularProgressIndicator(),),
                );
              }
            },
          );
        }
        return LoginPage();
      }
    );
  }
}
