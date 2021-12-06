import 'package:flutter/material.dart';
import 'auth.dart';
import '../pages/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  final String title = "Login";

  @override
  _LoginPageState createState() => new _LoginPageState();
}

enum FormType {
  login,
  register
}

class _LoginPageState extends State<LoginPage> {
  static final formKey = new GlobalKey<FormState>();

  late String _email;
  late String _password;
  FormType _formType = FormType.login;
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
      padded(child:  TextFormField(
        key:  Key('email'),
        decoration:  InputDecoration(labelText: 'Email'),
        autocorrect: false,
        validator: (val) => val!.isEmpty ? 'Email can\'t be empty.' : null,
        onSaved: (val) => _email = val!,
      )),
      padded(child:  TextFormField(
        key:  Key('password'),
        decoration:  InputDecoration(labelText: 'Password'),
        obscureText: true,
        autocorrect: false,
        validator: (val) => val!.isEmpty ? 'Password can\'t be empty.' : null,
        onSaved: (val) => _password = val!,
      )),
    ];
  }

  List<Widget> submitWidgets() {
        return[
           ElevatedButton(
              key: new Key('login'),
              child: new Text("Login"),
              onPressed: validateAndSubmit
          )
        ];
  }

  Widget hintText() {
    return  Container(
      //height: 80.0,
        padding: const EdgeInsets.all(32.0),
        child:  Text(
            _authHint,
            key:  Key('hint'),
            style:  TextStyle(fontSize: 18.0, color: Colors.grey),
            textAlign: TextAlign.center)
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: new Text(widget.title),
        ),
        backgroundColor: Colors.grey[300],
        body:  SingleChildScrollView(child: Container(
            padding:  EdgeInsets.all(16.0),
            child: Column(
                children: [
                  Card(
                      child:  Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                             Container(
                                padding: const EdgeInsets.all(16.0),
                                child:  Form(
                                    key: formKey,
                                    child:  Column(
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: usernameAndPassword() + submitWidgets(),
                                    )
                                )
                            ),
                          ])
                  ),
                  hintText()
                ]
            )
        ))
    );
  }

  Widget padded({required Widget child}) {
    return  Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: child,
    );
  }
}