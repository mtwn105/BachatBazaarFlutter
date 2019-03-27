import 'package:bachatbazaar/LoginPage.dart';
import 'package:bachatbazaar/MainPage.dart';
import 'package:bachatbazaar/SellerDashboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

Color hexToColor(String code) {
  return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
}

final FirebaseAuth auth = FirebaseAuth.instance;

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() {
    return new MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  //CHECKING USER LOGGED IN
  bool loading = true;
  bool loggedin = false;
  bool sellerLoggedIn = false;

  String getId(FirebaseUser user) {
    if (user != null) {
      return user.uid;
    } else {
      return null;
    }
  }

  Future loggedIn() async {
    String uid = await auth.currentUser().then(getId);

    if (uid == null) {
      setState(() {
        loggedin = false;
      });
      print("NO LOGIN");
    } else {
      DocumentSnapshot userInfo =
          await Firestore.instance.collection('sellers').document(uid).get();
      setState(() {
        loggedin = true;
      });
      if (userInfo.data == null) {
      } else {
        setState(() {
          sellerLoggedIn = true;
        });
      }
    }
    setState(() {
      loading = false;
    });

    print("LoggedIn:" +
        loggedin.toString() +
        " Seller:" +
        sellerLoggedIn.toString());
  }

  @override
  void initState() {
    loggedIn();

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bachat Bazaar',
      theme: ThemeData(
          fontFamily: "Title",
          primaryColor: hexToColor("#110E2E"),
          primaryColorDark: hexToColor("#000025"),
          accentColor: hexToColor("#36ebc7")),
      home: loading
          ? Container(
              color: hexToColor("#111f4c"),
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  new Container(
                    height: 200,
                    child: Image.asset(
                      "assets/cart2.png",
                      fit: BoxFit.fill,
                    ),
                  ),
                  new Container(
                    height: 40,
                    width: 120,
                    child: FlareActor(
                      "assets/MyLoading.flr",
                      fit: BoxFit.fill,
                      animation: "LoadingAnimation",
                    ),
                  )
                ],
              ),
            )
          : loggedin == true
              ? sellerLoggedIn ? SellerDashboard() : MainPage()
              : LoginPage(),
    );
  }
}
