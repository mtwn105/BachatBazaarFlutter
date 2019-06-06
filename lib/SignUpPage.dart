import 'dart:math';

import 'package:bachatbazaar/LoginPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:http/http.dart' as http;

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

final FirebaseAuth auth = FirebaseAuth.instance;

Future<FirebaseUser> handleSignUp(
    String email, String password, String name, String phone) async {
  FirebaseUser user = await auth.createUserWithEmailAndPassword(
      email: email, password: password);

  Firestore.instance.collection('users').document(user.uid).setData({
    'name': name,
    'uid': user.uid,
    'email': user.email,
    'phone': phone,
    'cart_items': 0,
    'cart_total_price': 0,
    'wishlist_items': 0
  });

  return user;
}

class _SignUpPageState extends State<SignUpPage> with TickerProviderStateMixin {
  static String tag = 'signup-page';
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

  Animation<double> logoAnimation;
  AnimationController logoController;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final otpController = TextEditingController();

  @override
  void initState() {
    logoController = new AnimationController(
        duration: const Duration(milliseconds: 1500), vsync: this);
    final CurvedAnimation logoCurve =
        new CurvedAnimation(parent: logoController, curve: Curves.easeIn);
    logoAnimation = new Tween(begin: 0.0, end: 1.0).animate(logoCurve);
    logoController.forward();
    super.initState();
  }

  dispose() {
    logoController.dispose();
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    phoneController.dispose();
    otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle style =
        TextStyle(color: Theme.of(context).primaryColor, fontSize: 14);

    final logo = new Container(
      height: 260,
      child: FlareActor(
        "assets/BachatBazaarLogoAnimation.flr",
        fit: BoxFit.fill,
        animation: "LogoIntro",
      ),
    );

    final emailField = Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        child: TextField(
          keyboardType: TextInputType.emailAddress,
          obscureText: false,
          controller: emailController,
          style: style,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              hintText: "Email",
              filled: true,
              fillColor: Colors.white,
              focusedBorder: new OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32.0),
                  borderSide: BorderSide(
                      width: 3, color: Theme.of(context).accentColor)),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32.0))),
        ));

    final passwordField = Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        child: TextField(
          obscureText: true,
          controller: passwordController,
          style: style,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              hintText: "Choose Password",
              filled: true,
              fillColor: Colors.white,
              focusedBorder: new OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32.0),
                  borderSide: BorderSide(
                      width: 3, color: Theme.of(context).accentColor)),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32.0))),
        ));

    final phoneField = Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        child: TextField(
          keyboardType: TextInputType.phone,
          obscureText: false,
          controller: phoneController,
          style: style,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              hintText: "Enter Phone Number",
              filled: true,
              fillColor: Colors.white,
              focusedBorder: new OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32.0),
                  borderSide: BorderSide(
                      width: 3, color: Theme.of(context).accentColor)),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32.0))),
        ));

    final nameField = Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        child: TextField(
          keyboardType: TextInputType.text,
          obscureText: false,
          controller: nameController,
          style: style,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              hintText: "Enter Your Name",
              filled: true,
              fillColor: Colors.white,
              focusedBorder: new OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32.0),
                  borderSide: BorderSide(
                      width: 3, color: Theme.of(context).accentColor)),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32.0))),
        ));

    final signUpButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          minWidth: 200.0,
          height: 42.0,
          onPressed: () async {
//Send OTP
            String otp = "";
            sendOtp(phoneController.text).then((value) => otp = value);
//Check OTP
            showDialog(
                builder: (context) => AlertDialog(
                      title: Text("Enter OTP"),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            "OTP has been sent to your mobile.",
                            style: TextStyle(fontFamily: 'Subtitle'),
                          ),
                          TextField(
                            controller: otpController,
                          )
                        ],
                      ),
                      actions: <Widget>[
                        FlatButton(
                          child: Text("SUBMIT"),
                          onPressed: () {
                            if (otp == otpController.text) {
                              handleSignUp(
                                      emailController.text,
                                      passwordController.text,
                                      nameController.text,
                                      phoneController.text)
                                  .then((FirebaseUser user) async {
                                // Toast.show("Toast plugin app", duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);

                                String url = "https://api.textlocal.in/send/?";
                                String apiKey =
                                    "apikey=g5LDhBKYxFE-pQt8DZSR9TzJtt8JLTjHPVSkHEzvkt";
                                String message = "&message= " +
                                    "Hello, " +
                                    nameController.text +
                                    "\nWelcome to Bachat Bazaar.\nNow Enjoy Homemade goods at cheap prices";
                                String numbers =
                                    "&numbers=" + "91" + phoneController.text;
                                String data = apiKey + numbers + message;

                                var response =
                                    await http.post(Uri.encodeFull(url + data));
                                print(response.body.toString());
                                Navigator.pushReplacement(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (context) => new LoginPage()),
                                );
                              }).catchError((e) => print(e));
                            } else {
                              Navigator.pop(context);
                              _scaffoldKey.currentState.showSnackBar(
                                  SnackBar(content: Text("Invalid OTP")));
                              ;
                            }
                          },
                        ),
                        FlatButton(
                          child: Text("CLOSE"),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        )
                      ],
                    ),
                context: context);
            /*    handleSignUp(emailController.text, passwordController.text,
                    nameController.text, phoneController.text)
                .then((FirebaseUser user) async {
              // Toast.show("Toast plugin app", duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);

              String url = "https://api.textlocal.in/send/?";
              String apiKey =
                  "apikey=g5LDhBKYxFE-pQt8DZSR9TzJtt8JLTjHPVSkHEzvkt";
              String message = "&message= " +
                  "Hello, " +
                  nameController.text +
                  "\nWelcome to Bachat Bazaar.\nNow Enjoy Homemade goods at cheap prices";
              String numbers = "&numbers=" + "91" + phoneController.text;
              String data = apiKey + numbers + message;

              var response = await http.post(Uri.encodeFull(url + data));
              print(response.body.toString());
              Navigator.pushReplacement(
                context,
                new MaterialPageRoute(builder: (context) => new LoginPage()),
              );
            }).catchError((e) => print(e)); */
          },
          color: Theme.of(context).accentColor,
          child: Text('Create Account',
              style: TextStyle(color: Theme.of(context).primaryColor)),
        ),
      ),
    );

    return AnimatedBuilder(
      animation: logoController,
      builder: (BuildContext context, Widget child) => Scaffold(
            key: _scaffoldKey,
            backgroundColor: Colors.teal,
            body: new Container(
              decoration: new BoxDecoration(
                  gradient: new LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      stops: [
                    0.5,
                    0.9
                  ],
                      colors: [
                    Theme.of(context).primaryColor,
                    Theme.of(context).primaryColorDark,
                  ])),
              child: Center(
                child: ListView(
                  shrinkWrap: true,
                  padding: EdgeInsets.only(left: 24.0, right: 24.0),
                  children: <Widget>[
                    logo,
                    SizedBox(
                      height: 60.0,
                    ),
                    emailField,
                    nameField,
                    phoneField,
                    passwordField,
                    signUpButton
                  ],
                ),
              ),
            ),
          ),
    );
  }

  Future<String> sendOtp(String number) async {
    final String otp = "${new Random().nextInt(100000)}";

    String url = "https://api.textlocal.in/send/?";
    String apiKey = "apikey=g5LDhBKYxFE-pQt8DZSR9TzJtt8JLTjHPVSkHEzvkt";
    String message = "&message= " + "OTP For Registration is: $otp";
    String numbers = "&numbers=" + "91" + number;
    String data = apiKey + numbers + message;

    var response = await http.post(Uri.encodeFull(url + data));
    print(response.body);
    return otp;
  }
}
