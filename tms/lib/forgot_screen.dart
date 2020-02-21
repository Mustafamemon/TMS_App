import 'package:flutter/material.dart';
import 'package:tms/code_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  // ForgotPasswordScreen({Key key, this.title}) : super(key: key);
  // final String title;

  @override
  _ForgotPasswordScreen createState() => _ForgotPasswordScreen();
}

class _ForgotPasswordScreen extends State<ForgotPasswordScreen> {
  final formKey = GlobalKey<FormState>();

  String id = "";
  String error = "";
  bool isPressed = false;

  TextStyle style = TextStyle(fontSize: 15.0);

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
    final loading = CircularProgressIndicator(
      valueColor:
          new AlwaysStoppedAnimation<Color>(Color.fromRGBO(96, 114, 150, 1)),
      backgroundColor: Colors.white,
    );
    final sendButton = Material(
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
                    }
                  });
                  String email = id[2] + id.replaceAll('K', '') + '@nu.edu.pk';
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    isPressed = false;
                    return PinCodeVerificationScreen(email);
                  }));
                }
              }
            : null,
        child: !isPressed
            ? Text("Send",
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
                      SizedBox(height: 20.0),
                      emailField,
                      SizedBox(height: 20.0),
                      sendButton,
                      SizedBox(height: 15.0),
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
