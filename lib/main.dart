import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'Screens/login.dart';
import 'Screens/auth.dart';
import 'pages/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool UserExists = false;
    void userCheck() async{
        if(await Auth().currentUser() != null)
          UserExists = true;
    }
    userCheck();
    if(UserExists == false) {
      return MaterialApp(home: LoginPage());
    }else{
      return MaterialApp(home: Home());
    }
  }
}