import 'package:bachatbazaar/SellerDashboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';

class SellerLoginPage extends StatefulWidget {
  @override
  _SellerLoginPageState createState() => _SellerLoginPageState();
}
final FirebaseAuth auth = FirebaseAuth.instance;

Future<FirebaseUser> handleSignIn(String email, String password) async {
  FirebaseUser user =
      await auth.signInWithEmailAndPassword(email: email, password: password);
  return user;
}


class _SellerLoginPageState extends State<SellerLoginPage>with TickerProviderStateMixin  {
  
  Animation<double> logoAnimation;
  Animation<double> signInAnimation;
  AnimationController logoController;
  AnimationController signInController;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle style = TextStyle(color: Theme.of(context).primaryColor,fontSize: 14);

     final  logo = new Container(
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
            onPressed: () {
              handleSignIn(emailController.text, passwordController.text)
                  .then((FirebaseUser user) {
                Navigator.pushReplacement(
                  context,
                  new MaterialPageRoute(builder: (context) => new SellerDashboard()),
                );
              }).catchError((e) => print(e));
            },
            color: Theme.of(context).accentColor,
            child: Text('Seller Log In',
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
              passwordField,
              signInButton,
            ],
          ),
        ),
      ),
    );
  }

}