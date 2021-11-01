import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/main_menu.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _secureText = true;
  TextEditingController _passwordController = TextEditingController();
  String _passwordError;
  var _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    bool validated = false;
    return Scaffold(
      backgroundColor: Colors.grey[500],
      appBar: AppBar(
        title: Text("HALI"),
        centerTitle: true,
        backgroundColor: Colors.grey[800],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        validator: (String value) {
                          if (value.length < 10)
                            return "Enter at least 10 char";
                          else
                            return null;
                        },
                        decoration: InputDecoration(
                            hintText: "Your e-mail",
                            labelText: "Login",
                            labelStyle:
                            TextStyle(fontSize: 24, color: Colors.black),
                            filled: true,
                            fillColor: Colors.white70,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      TextFormField(
                        validator: (String value) {
                          if (value.length < 3)
                            return "Enter at least 3 char";
                          else
                            return null;
                        },
                        decoration: InputDecoration(
                            hintText: "Password",
                            labelText: "Password",
                            labelStyle:
                            TextStyle(fontSize: 24, color: Colors.black),
                            filled: true,
                            fillColor: Colors.white70,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                        ),
                        obscureText: true,
                      ),
                    ],
                  )),
              SizedBox(
                height: 16,
              ),
              ElevatedButton(onPressed: () {
                print("Password : " + _passwordController.text);
                setState(() {
                  print("Form Validation : " +
                      _formKey.currentState.validate().toString());
                  if (_passwordController.text.length < 8)
                    _passwordError = "Enter at least 8 char";
                  else {
                        _passwordError = null;
                        validated = true;
                      }
                    });
                if(validated = true){
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Menu())
                  );
                }
              },
                child: Text('Submit'),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.grey[900]),
                )
              )
            ],
          ),
        ),
      ),
    );
  }
}