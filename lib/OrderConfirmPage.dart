import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'MainPage.dart';

class OrderConfirmPage extends StatefulWidget {
  final String orderId;

  const OrderConfirmPage({Key key, this.orderId}) : super(key: key);

  @override
  _OrderConfirmPageState createState() => _OrderConfirmPageState(this.orderId);
}

final FirebaseAuth auth = FirebaseAuth.instance;

class _OrderConfirmPageState extends State<OrderConfirmPage>
    with TickerProviderStateMixin {
  final String orderId;

  _OrderConfirmPageState(this.orderId);

  String userName = "";
  String userId = "";
  String email = "";
  String phoneNumber = "";
  String orderDate;
  int orderTotalPrice = 0;
  String orderSellerName = "";

  bool isLoaded = false;
  AnimationController _controller;
  Animation<Offset> _offsetFloat;
  final duration = Duration(milliseconds: 600);

  Future fetchDetails() async {
    String uid = await auth.currentUser().then((user) => user.uid);
    setState(() {
      userId = uid;
    });
    print("USERID: " + userId);
    print("OrderID: " + orderId);
    DocumentSnapshot orderInfo = await Firestore.instance
        .collection('users')
        .document(userId)
        .collection('orders')
        .document(orderId)
        .get();

    orderSellerName = orderInfo['order_seller_name'];
    Timestamp t = orderInfo['order_date'];
    DateTime d =
        new DateTime.fromMillisecondsSinceEpoch(t.millisecondsSinceEpoch);
    orderDate = formatDate(d, [dd, ' ', MM, ' ', yyyy]);
    orderTotalPrice = orderInfo['order_total_price'];

    setState(() {
      isLoaded = true;
    });
    _controller.forward();
  }

  @override
  void initState() {
    super.initState();
    fetchDetails();
    _controller = AnimationController(
      vsync: this,
      duration: duration,
    );

    _offsetFloat = Tween<Offset>(begin: Offset(-1.0, 0.0), end: Offset.zero)
        .animate(_controller);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      body: isLoaded
          ? SlideTransition(
              position: _offsetFloat,
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView(
                        children: <Widget>[
                          Material(
                            borderRadius: BorderRadius.circular(16),
                            elevation: 8,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: Theme.of(context).primaryColor,
                              ),
                              width: double.infinity,
                              height: size.height * 0.35,
                              child: Column(
                                children: <Widget>[
                                  SizedBox(
                                    height: size.height * 0.05,
                                  ),
                                  Text(
                                    'Order Placed!'.toUpperCase(),
                                    style: TextStyle(
                                      letterSpacing: 1.4,
                                      fontSize: 26.0,
                                      color: Theme.of(context).accentColor,
                                    ),
                                  ),
                                  SizedBox(
                                    height: size.height * 0.05,
                                  ),
                                  Text(
                                    'Thank you for using'.toUpperCase(),
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      color: Colors.white54,
                                    ),
                                  ),
                                  Text(
                                    'BACHAT BAZAAR'.toUpperCase(),
                                    style: TextStyle(
                                      letterSpacing: 1.4,
                                      fontSize: 22.0,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(
                                    height: size.height * 0.05,
                                  ),
                                  Text(
                                    'Here are your order details:',
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.white54,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Material(
                            borderRadius: BorderRadius.circular(16),
                            elevation: 8,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              width: double.infinity,
                              height: size.height * 0.25,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      'Order Information'.toUpperCase(),
                                      style: TextStyle(
                                        letterSpacing: 1.4,
                                        fontSize: 20.0,
                                      ),
                                    ),
                                    SizedBox(height: size.height * 0.02),
                                    Row(
                                      children: <Widget>[
                                        Text(
                                          'Order ID: '.toUpperCase(),
                                          style: TextStyle(
                                            fontSize: 16.0,
                                          ),
                                        ),
                                        Text(
                                          orderId,
                                          style: TextStyle(
                                              fontSize: 16.0, fontFamily: "Subtitle"),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Text(
                                          'Order Date: '.toUpperCase(),
                                          style: TextStyle(
                                            fontSize: 16.0,
                                          ),
                                        ),
                                        Text(
                                          orderDate,
                                          style: TextStyle(
                                              fontSize: 16.0, fontFamily: "Subtitle"),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Text(
                                          'Order Seller: '.toUpperCase(),
                                          style: TextStyle(
                                            fontSize: 16.0,
                                          ),
                                        ),
                                        Text(
                                          orderSellerName,
                                          style: TextStyle(
                                              fontSize: 16.0, fontFamily: "Subtitle"),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Text(
                                          'Order Total Price: '.toUpperCase(),
                                          style: TextStyle(
                                            fontSize: 16.0,
                                          ),
                                        ),
                                        Text(
                                          "Rs. " + orderTotalPrice.toString(),
                                          style: TextStyle(
                                              fontSize: 16.0, fontFamily: "Subtitle"),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),


                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: MaterialButton(
                      onPressed: () async {
                        Navigator.pushReplacement(
                          context,
                          new MaterialPageRoute(builder: (context) => new MainPage()),
                        );
                      },
                      color: Theme.of(context).primaryColor,
                      child: new Text("SHOP MORE".toUpperCase(),
                          style: new TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
