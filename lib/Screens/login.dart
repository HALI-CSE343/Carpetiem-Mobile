import 'package:flutter/material.dart';
import 'auth.dart';
import '../pages/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  final String title = "Login";

  @override
  _LoginPageState createState() => _LoginPageState();
}

enum FormType {
  login,
  register
}

class _LoginPageState extends State<LoginPage> {
  static final formKey = GlobalKey<FormState>();

  late String _email;
  late String _password;
  String _authHint = '';

  bool validateAndSave() {
    final form = formKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void validateAndSubmit() async {
    if (validateAndSave()) {
      try {
        String userId = await Auth().signIn(_email, _password);
        setState(() {
          _authHint = 'Found \n\nUser id: $userId';
        });
        FirebaseFirestore.instance
            .collection('employees')
            .doc(userId)
            .get()
            .then((DocumentSnapshot documentSnapshot) {
          if (documentSnapshot.exists) {
            Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
          }
        });

      }
      catch (e) {
        setState(() {
          _authHint = 'Sign In Error\n\n${e.toString()}';
        });
        print(e);
      }
    } else {
      setState(() {
        _authHint = '';
      });
    }
  }


  List<Widget> usernameAndPassword() {
    return [
      const SizedBox(height: 180),
      Image.asset(
        'assets/images/logo.png',
        scale: 4,
      ),
      const SizedBox(height: 20),
      const Text(
        "CarpeTiem",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold
        ),
      ),

      const SizedBox(height: 30),
      TextFormField(
        key:  const Key('email'),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(8.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18.0),
          ),
          hintText: "Email",
        ),
        autocorrect: false,
        validator: (val) => val!.isEmpty ? 'Email can\'t be empty.' : null,
        onSaved: (val) => _email = val!,
      ),
      const SizedBox(height: 8),
       TextFormField(
        key:  const Key('password'),
         decoration: InputDecoration(
           contentPadding: const EdgeInsets.all(8.0),
           border: OutlineInputBorder(
             borderRadius: BorderRadius.circular(18.0),
           ),
           focusedBorder: OutlineInputBorder(
             borderRadius: BorderRadius.circular(18.0),
           ),
           enabledBorder: OutlineInputBorder(
             borderRadius: BorderRadius.circular(18.0),
           ),
           hintText: "Password",
         ),
        obscureText: true,
        autocorrect: false,
        validator: (val) => val!.isEmpty ? 'Password can\'t be empty.' : null,
        onSaved: (val) => _password = val!,
      ),
      const SizedBox(height: 15),
    ];
  }

  List<Widget> submitWidgets() {
        return[
          const SizedBox(height: 10),
          ElevatedButton(
              key: const Key('login'),
              child: const Text(
                "Login",
                style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              ),
              onPressed: validateAndSubmit,
              style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(const Size(320, 48)),
                  backgroundColor: MaterialStateProperty.all(Colors.black),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                      )
                  )
              )
          )
        ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(child: Container(

            padding: EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                Container(
                    padding: const EdgeInsets.all(8.0),
                    child: Form(
                        key: formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: usernameAndPassword() + submitWidgets(),

                        )
                    )
                ),
              ],
            )
        ))
    );
  }
}
