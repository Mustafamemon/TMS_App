import 'package:flutter/material.dart';
import 'package:tms/web.dart';
import 'package:tms/web_view.dart';
import 'package:tms/signup_screen.dart';
import 'package:tms/forgot_screen.dart';

class LoginScreen extends StatefulWidget {
  // LoginScreen({Key key, this.title}) : super(key: key);
  // final String title;

  @override
  _LoginScreen createState() => _LoginScreen();
}

class _LoginScreen extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();

  String id = "";
  String password = "";
  String error = "";
  bool isPressed = false;
  bool isLogin = false;

  TextStyle style = TextStyle(fontSize: 15.0);
  bool _obscureText = true;
  Future<void> makeRequest(String id, String password) async {
    WebFunctions w1 = WebFunctions();

    String response = await w1.getSessionId(id, password);
    if (response != null) {
      print(response);
      if (response == "Invalid Username of Password.") {
        setState(() {
          isPressed = false;
          error = response.toString();
        });
      } else if (response != "success") {
        setState(() {
          isPressed = false;

          error = response.toString();
        });
      } else {
        setState(() {
          isPressed = false;
          isLogin = true;
          error = response.toString();
        });
      }
    } else {
      setState(() {
        isPressed = false;
        error = 'Check your internet connectivity';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
    final loading = CircularProgressIndicator(
      valueColor:
          new AlwaysStoppedAnimation<Color>(Color.fromRGBO(96, 114, 150, 1)),
      backgroundColor: Colors.white,
    );
    final forgotPassword = Container(
      alignment: Alignment.centerRight,
      child: FlatButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ForgotPasswordScreen()),
          );
        },
        padding: EdgeInsets.only(right: 0.0),
        child: Text('Forgot Password?',
            style: TextStyle(
              decoration: TextDecoration.underline,
              decorationColor: Colors.grey,
              color: Colors.cyan,
              fontWeight: FontWeight.bold,
              fontFamily: 'OpenSans',
            )),
      ),
    );
    final registerNow = Container(
      alignment: Alignment.centerLeft,
      child: FlatButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SignUpScreen()),
          );
        },
        padding: EdgeInsets.only(right: 0.0),
        child: Text('Register Now ?',
            style: TextStyle(
              decoration: TextDecoration.underline,
              decorationColor: Colors.grey,
              fontWeight: FontWeight.bold,
              color: Colors.cyan,
              fontFamily: 'OpenSans',
            )),
      ),
    );

    final loginButon = Material(
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
                    }
                  });
                  makeRequest(id, password);
                }
              }
            : null,
        child: !isPressed
            ? Text("Login",
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

    return !isLogin
        ? Scaffold(
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
                            SizedBox(height: 20.0),
                            emailField,
                            SizedBox(height: 20.0),
                            passwordField,
                            SizedBox(height: 5.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                registerNow,
                                forgotPassword,
                              ],
                            ),
                            SizedBox(height: 5.0),
                            loginButon,
                            SizedBox(height: 15.0),
                          ],
                        ),
                      ),
                    )),
              ),
            ),
          )
        : WebViewScreen();
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

String validatePassword(String value) {
  if (value.length <= 0) {
    return "Please enter password!";
  } else
    return null;
}
