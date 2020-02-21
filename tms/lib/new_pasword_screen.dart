import 'package:flutter/material.dart';
import 'package:tms/login_screen.dart';

class NewPasswordScreen extends StatefulWidget {
  @override
  _NewPasswordScreen createState() => _NewPasswordScreen();
}

class _NewPasswordScreen extends State<NewPasswordScreen> {
  final formKey = GlobalKey<FormState>();

  String password = "";
  String error = "";
  String confirmpassword = "";
  bool isPressed = false;

  TextStyle style = TextStyle(fontSize: 15.0);
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
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
            hintText: "New Password",
            labelText: "New Password",
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

    final changeButon = Material(
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
                }
              }
            : null,
        child: !isPressed
            ? Text("Change",
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
                        height: 225.0,
                        child: Image.asset(
                          "images/lg-01.PNG",
                          fit: BoxFit.contain,
                        ),
                      ),
                      werror,
                      SizedBox(height: 10.0),
                      passwordField,
                      SizedBox(height: 10.0),
                      confirmpasswordField,
                      SizedBox(height: 15.0),
                      changeButon,
                    ],
                  ),
                ),
              )),
        ),
      ),
    );
  }
}

String validateName(String value) {
  if (value.length <= 0)
    return "Please enter name!";
  else
    return null;
}
