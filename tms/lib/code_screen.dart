import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:tms/new_pasword_screen.dart';

class PinCodeVerificationScreen extends StatefulWidget {
  final String email;

  PinCodeVerificationScreen(this.email);

  @override
  _PinCodeVerificationScreenState createState() =>
      _PinCodeVerificationScreenState();
}

class _PinCodeVerificationScreenState extends State<PinCodeVerificationScreen> {
  var onTapRecognizer;

  bool error = false;
  String code = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: ListView(
            children: <Widget>[
              SizedBox(height: 30),
              Image.asset(
                'images/lg-01.PNG',
                height: MediaQuery.of(context).size.height / 3.5,
                fit: BoxFit.fitHeight,
              ),
              SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Email Verification',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8),
                child: RichText(
                  text: TextSpan(
                      text: "Enter the code sent to ",
                      children: [
                        TextSpan(
                            text: widget.email,
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 15)),
                      ],
                      style: TextStyle(color: Colors.black54, fontSize: 15)),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8.0, horizontal: 30),
                  child: PinCodeTextField(
                    activeColor: Colors.cyanAccent,
                    selectedColor: Colors.cyanAccent,
                    inactiveColor: Colors.cyan,
                    length: 4,
                    obsecureText: false,
                    animationType: AnimationType.fade,
                    shape: PinCodeFieldShape.underline,
                    animationDuration: Duration(milliseconds: 300),
                    borderRadius: BorderRadius.circular(5),
                    fieldHeight: 50,
                    fieldWidth: 40,
                    onChanged: (value) {
                      setState(() {
                        code = value;
                      });
                    },
                  )),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Text(
                  error ? "Enter the code" : "",
                  style: TextStyle(color: Colors.red, fontSize: 15),
                ),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                padding: EdgeInsets.only(right: 0.0),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                      text: "Didn't receive the code? ",
                      style: TextStyle(color: Colors.black54, fontSize: 15),
                      children: [
                        TextSpan(
                            text: " RESEND",
                            style: TextStyle(
                                color: Colors.cyan,
                                fontWeight: FontWeight.bold,
                                fontSize: 16))
                      ]),
                ),
              ),
              Container(
                margin: EdgeInsets.all(30.0),
                child: Material(
                  elevation: 5.0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30.0))),
                  color: Colors.cyan,
                  child: MaterialButton(
                      padding: EdgeInsets.only(left: 60.0, right: 60.0),
                      onPressed: () {
                        if (code.length <= 3) {
                          setState(() {
                            error = true;
                          });
                        } else {
                          setState(() {
                            error = false;
                          });
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => NewPasswordScreen()));
                        }
                      },
                      child: Text("Verify",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 15.0,
                              color: Colors.white,
                              fontWeight: FontWeight.bold))),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
