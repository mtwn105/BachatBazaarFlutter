import 'package:bachatbazaar/LoginPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
    'cart_items':0,
    'cart_total_price':0,
    'wishlist_items' : 0
  });

  return user;
}

class _SignUpPageState extends State<SignUpPage> with TickerProviderStateMixin {
  static String tag = 'signup-page';

  Animation<double> logoAnimation;
  Animation<double> signInAnimation;
  AnimationController logoController;
  AnimationController signInController;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();

  @override
  void initState() {
    logoController = new AnimationController(
        duration: const Duration(milliseconds: 1500), vsync: this);
    signInController = new AnimationController(
        duration: const Duration(milliseconds: 3500), vsync: this);
    final CurvedAnimation logoCurve =
        new CurvedAnimation(parent: logoController, curve: Curves.easeIn);
    final CurvedAnimation signInCurve =
        new CurvedAnimation(parent: signInController, curve: Curves.bounceIn);
    logoAnimation = new Tween(begin: 0.0, end: 70.0).animate(logoCurve)
      ..addListener(() {
        setState(() {});
      });
    signInAnimation = new Tween(begin: 0.0, end: 1.0).animate(signInCurve)
      ..addListener(() {
        setState(() {});
      });
    logoController.forward();
    signInController.forward();
    // TODO: implement initState
    super.initState();
    setUserDetails();
  }

  void setUserDetails() async {
    String name = "";
    String email = "";
    String uid = "";
    String phone = "";
    name = await auth.currentUser().then((user) => user.displayName);
    email = await auth.currentUser().then((user) => user.email);
    uid = await auth.currentUser().then((user) => user.uid);
    phone = await auth.currentUser().then((user) => user.phoneNumber);
  }

  dispose() {
    signInController.dispose();
    logoController.dispose();
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle style =
        TextStyle(color: Theme.of(context).primaryColor, fontSize: 14);

    final logo = Hero(
      tag: 'hero',
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: logoAnimation.value,
        child: Image.asset(
          'assets/cart2.png',
        ),
      ),
    );

    final emailField = new Opacity(
        opacity: signInAnimation.value,
        child: Padding(
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
            )));

    final passwordField = new Opacity(
        opacity: signInAnimation.value,
        child: Padding(
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
            )));

    final phoneField = new Opacity(
        opacity: signInAnimation.value,
        child: Padding(
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
            )));

    final nameField = new Opacity(
        opacity: signInAnimation.value,
        child: Padding(
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
            )));

    /* final signInButton = new Opacity(
      opacity: signInAnimation.value,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30.0),
          child: MaterialButton(
            minWidth: 200.0,
            height: 42.0,
            onPressed: () {
              handleSignIn(emailController.text, passwordController.text)
                  .then((FirebaseUser user) {
                Navigator.pushReplacement(
                  context,
                  new MaterialPageRoute(builder: (context) => new MainPage()),
                );
              }).catchError((e) => print(e));
            },
            color: Theme.of(context).accentColor,
            child: Text('Log In',
                style: TextStyle(color: Theme.of(context).primaryColor)),
          ),
        ),
      ),
    );
*/
    final signUpButton = new Opacity(
      opacity: signInAnimation.value,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30.0),
          child: MaterialButton(
            minWidth: 200.0,
            height: 42.0,
            onPressed: () async {
              handleSignUp(emailController.text, passwordController.text,
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
              }).catchError((e) => print(e));
            },
            color: Theme.of(context).accentColor,
            child: Text('Create Account',
                style: TextStyle(color: Theme.of(context).primaryColor)),
          ),
        ),
      ),
    );

    return Scaffold(
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
    );
  }
}
