import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tms/login_screen.dart';
import 'package:tms/web.dart';

class SignUpScreen extends StatefulWidget {
  // SignUpScreen({Key key, this.title}) : super(key: key);
  // final String title;

  @override
  _SignUpScreen createState() => _SignUpScreen();
}

class _SignUpScreen extends State<SignUpScreen> {
  final formKey = GlobalKey<FormState>();

  String id = "";
  String password = "";
  String firstname = "";
  String lastname = "";
  String error = "";
  String confirmpassword = "";
  bool isPressed = false;
  String dob;
  bool _obscureText = true;
  TextStyle style = TextStyle(fontSize: 15.0);
  TextEditingController _dobController = TextEditingController();
  Future _selectDate() async {
    DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2018),
      lastDate: DateTime(2030),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.dark(),
          child: child,
        );
      },
    );
    if (picked != null)
      setState(() {
        dob = picked.toString();
        _dobController.text = dob.split(' ')[0];
      });
  }

  Future<void> makeRequest(String id, String password, String confirmpassword,
      String firstname, String lastname) async {
    WebFunctions w1 = WebFunctions();

    String response = await w1.registerStd(
        id, password, confirmpassword, firstname, lastname);
    if (response != null) {
      setState(() {
        isPressed = false;
        error = response
            .toString()
            .replaceAll(RegExp(r'({)*(})*(status)*(")*(:)*'), '');
      });
      if (error != 'Already SignUp!') {
        Timer.periodic(Duration(seconds: 1), (Timer t) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final firstName = TextFormField(
        obscureText: false,
        style: style,
        validator: validateName,
        keyboardType: TextInputType.text,
        enableInteractiveSelection: false,
        enabled: !isPressed ? true : false,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.people),
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "First Name",
          labelText: "First Name",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
        ),
        onSaved: (String value) {
          firstname = value;
        });
    final lastName = TextFormField(
        obscureText: false,
        style: style,
        validator: validateName,
        keyboardType: TextInputType.text,
        enableInteractiveSelection: false,
        enabled: !isPressed ? true : false,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.people),
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Last Name",
          labelText: "Last Name",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
        ),
        onSaved: (String value) {
          lastname = value;
        });

    final emailField = TextFormField(
        obscureText: false,
        style: style,
        validator: validateEmail,
        keyboardType: TextInputType.text,
        textCapitalization: TextCapitalization.characters,
        enableInteractiveSelection: false,
        enabled: !isPressed ? true : false,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.people),
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "NU ID",
          labelText: "NU ID",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
        ),
        onSaved: (String value) {
          id = value;
        });
    final passwordField = TextFormField(
        enableInteractiveSelection: false,
        obscureText: _obscureText,
        style: style,
        enabled: !isPressed ? true : false,
        validator: validatePassword,
        decoration: InputDecoration(
            prefixIcon: Icon(Icons.lock),
            suffixIcon: IconButton(
              icon: Icon(Icons.remove_red_eye),
              onPressed: () {
                setState(() {
                  this._obscureText = !this._obscureText;
                });
              },
            ),
            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            hintText: "Password",
            labelText: "Password",
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
        onSaved: (String value) {
          password = value;
        });
    final confirmpasswordField = TextFormField(
        enableInteractiveSelection: false,
        obscureText: _obscureText,
        style: style,
        enabled: !isPressed ? true : false,
        validator: validatePassword,
        decoration: InputDecoration(
            prefixIcon: Icon(Icons.lock),
            suffixIcon: IconButton(
              icon: Icon(Icons.remove_red_eye),
              onPressed: () {
                setState(() {
                  this._obscureText = !this._obscureText;
                });
              },
            ),
            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            hintText: "Confirm Password",
            labelText: "Confirm Password",
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
        onSaved: (String value) {
          confirmpassword = value;
        });

    final loading = CircularProgressIndicator(
      valueColor:
          new AlwaysStoppedAnimation<Color>(Color.fromRGBO(96, 114, 150, 1)),
      backgroundColor: Colors.white,
    );

    final registerButon = Material(
      elevation: !isPressed ? 5.0 : 0.0,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(30.0))),
      color: !isPressed ? Colors.cyan : Colors.white,
      child: MaterialButton(
        padding: EdgeInsets.only(left: 60.0, right: 60.0),
        onPressed: !isPressed
            ? () {
                //if field is valid then save those field input
                if (formKey.currentState.validate()) {
                  formKey.currentState.save();
                  print("Finally $id and $password");
                  setState(() {
                    if (!isPressed) {
                      isPressed = true;
                      if (password != confirmpassword) {
                        setState(() {
                          error = 'Password do not match';
                        });
                        isPressed = false;
                      }
                    }
                  });
                  makeRequest(
                      id, password, confirmpassword, firstname, lastname);
                }
              }
            : null,
        child: !isPressed
            ? Text("Register",
                textAlign: TextAlign.center,
                style: style.copyWith(
                    color: Colors.white, fontWeight: FontWeight.bold))
            : loading,
      ),
    );
    final werror = Text(
      error,
      style: TextStyle(
        color: Colors.red,
        fontWeight: FontWeight.bold,
        fontSize: 15.0,
      ),
    );
    final dobField = TextFormField(
      controller: _dobController,
      enableInteractiveSelection: false,
      readOnly: true,
      style: style,
      enabled: !isPressed ? true : false,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.calendar_view_day),
          suffixIcon: IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: () {
              _selectDate();
              print(dob);
            },
          ),
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "DOB",
          labelText: "DOB",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
    );
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Container(
              height: MediaQuery.of(context).size.height,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      SizedBox(
                        height: 210.0,
                        child: Image.asset(
                          "images/lg-01.PNG",
                          fit: BoxFit.contain,
                        ),
                      ),
                      werror,
                      SizedBox(height: 8.0),
                      firstName,
                      SizedBox(height: 8.0),
                      lastName,
                      SizedBox(height: 8.0),
                      emailField,
                      SizedBox(height: 8.0),
                      passwordField,
                      SizedBox(height: 8.0),
                      confirmpasswordField,
                      SizedBox(height: 8.0),
                      dobField,
                      SizedBox(height: 15.0),
                      registerButon,
                    ],
                  ),
                ),
              )),
        ),
      ),
    );
  }
}

String validateEmail(String value) {
  Pattern pattern = r'^([0-9]{2})(K)([0-9]{4})$';
  RegExp regex = new RegExp(pattern);
  if (!regex.hasMatch(value))
    return "Enter valid ID (17K3654)";
  else
    return null;
}

String validateName(String value) {
  if (value.length <= 0)
    return "Please enter name!";
  else
    return null;
}
