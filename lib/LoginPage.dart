import 'package:bachatbazaar/MainPage.dart';
import 'package:bachatbazaar/SellerLoginPage.dart';
import 'package:bachatbazaar/SellerDashboard.dart';
import 'package:bachatbazaar/SignUpPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/services.dart';
import 'package:progress_hud/progress_hud.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

final FirebaseAuth auth = FirebaseAuth.instance;

Future<FirebaseUser> handleSignIn(String email, String password) async {
  FirebaseUser user =
      await auth.signInWithEmailAndPassword(email: email, password: password);
  return user;
}

enum FormMode { LOGIN, SIGNUP }

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  ProgressHUD _progressHUD;

  bool _loading = false;
  static String tag = 'login-page';

  Animation<double> logoAnimation;
  Animation<double> signInAnimation;
  AnimationController logoController;
  AnimationController signInController;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void initState() {
    _progressHUD = new ProgressHUD(
        backgroundColor: Colors.black12,
        color: Colors.white,
        containerColor: Colors.blue,
        borderRadius: 5.0,
        
        loading: false);

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

    super.initState();
  }

  dispose() {
    signInController.dispose();
    logoController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle style =
        TextStyle(color: Theme.of(context).primaryColor, fontSize: 14);

    /*   final logo = Hero(
      tag: 'hero',
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: logoAnimation.value,
        child: Image.asset(
          'assets/cart2.png',
        ),
      ),
    );
*/

    final logo = new Container(
      height: 260,
      child: FlareActor(
        "assets/BachatBazaarLogoAnimation.flr",
        fit: BoxFit.fill,
        animation: "LogoIntro",
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
                  hintText: "Password",
                  filled: true,
                  fillColor: Colors.white,
                  focusedBorder: new OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32.0),
                      borderSide: BorderSide(
                          width: 3, color: Theme.of(context).accentColor)),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32.0))),
            )));

    final signInButton = new Opacity(
      opacity: signInAnimation.value,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30.0),
          child: MaterialButton(
            minWidth: 200.0,
            height: 42.0,
            onPressed: () async {
              setState(() {
                _progressHUD.state.show();
              });

              await handleSignIn(emailController.text, passwordController.text)
                  .then((FirebaseUser user) {
                setState(() {
                 _progressHUD.state.dismiss();
                });
                Navigator.pushReplacement(
                  context,
                  new MaterialPageRoute(builder: (context) => new MainPage()),
                );
              }).catchError((e) {
               setState(() {
                 _progressHUD.state.dismiss();
                });
                PlatformException p = e;

                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: new Text("Error"),
                        content: new Text(
                          p.message,
                          style: new TextStyle(fontFamily: "Subtitle"),
                        ),
                        actions: <Widget>[
                          new FlatButton(
                            child: new Text("Close"),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    });
              });
            },
            color: Theme.of(context).accentColor,
            child: Text('Log In',
                style: TextStyle(color: Theme.of(context).primaryColor)),
          ),
        ),
      ),
    );

    final sellerLoginButton = new Opacity(
      opacity: signInAnimation.value,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30.0),
          child: MaterialButton(
            minWidth: 200.0,
            height: 42.0,
            onPressed: () {
              Navigator.push(
                context,
                new MaterialPageRoute(
                    builder: (context) => new SellerLoginPage()),
              );
            },
            color: Theme.of(context).primaryColor,
            child: Text('Seller Login',
                style: TextStyle(color: Theme.of(context).accentColor)),
          ),
        ),
      ),
    );

    final signUpButton = new Opacity(
      opacity: signInAnimation.value,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30.0),
          child: MaterialButton(
            minWidth: 200.0,
            height: 42.0,
            onPressed: () {
              Navigator.push(
                context,
                new MaterialPageRoute(builder: (context) => new SignUpPage()),
              );
            },
            color: Theme.of(context).primaryColor,
            child: Text('Create Account',
                style: TextStyle(color: Theme.of(context).accentColor)),
          ),
        ),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.teal,
      body: Stack(
        children: <Widget>[
          new Container(
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
                  passwordField,
                  signInButton,
                  sellerLoginButton,
                  signUpButton,
                ],
              ),
            ),
          ),
          _progressHUD
        ],
      ),
    );
  }
}
