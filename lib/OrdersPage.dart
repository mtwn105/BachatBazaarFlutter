import 'package:bachatbazaar/OrdersListTile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class OrdersPage extends StatefulWidget {
  @override
  _OrdersPageState createState() => _OrdersPageState();
}

final FirebaseAuth auth = FirebaseAuth.instance;

class _OrdersPageState extends State<OrdersPage> {

  

  String userName = "";
  String userId = "";
  String email = "";
  String phoneNumber = "";
  int cart_items = 0;
  int cart_total_price = 0;

  Future userDetails() async {
    String uid = await auth.currentUser().then((user) => user.uid);
    DocumentSnapshot userInfo =
        await Firestore.instance.collection('users').document(uid).get();
    setState(() {
      userName = userInfo['name'];
      userId = uid;
      email = userInfo['email'];
      phoneNumber = userInfo['phone'];
      print(userName);
    });
  }

  @override
  void initState() {
    userDetails();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text("Orders"),
        
      ),
      body: Padding(
            padding: const EdgeInsets.all(16),
            child: StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance
                  .collection('users')
                  .document(userId)
                  .collection('orders')
                  .orderBy('order_date',descending: true)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError)
                  return new Text('Error: ${snapshot.error}');
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return new Center(child: new Text("Loading..."));
                  default:
                    if (snapshot.data.documents.length == 0) {
                      return new Center(child: new Text("No orders."));
                    } else {
                      return new ListView(
                        children: snapshot.data.documents
                            .map((DocumentSnapshot document) {
                          return buildOrdersListTile(context, document);
                        }).toList(),
                      );
                    }
                }
              },
            ),
          ),
    );
  }

 
}
