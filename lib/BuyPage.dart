import 'dart:convert';
import 'dart:math';
import 'package:flutter_upi/flutter_upi.dart';
import 'package:bachatbazaar/MainPage.dart';
import 'package:bachatbazaar/model/Product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:paytm/paytm.dart';

import 'OrderConfirmPage.dart';

class BuyPage extends StatefulWidget {
  final int cart_total_price;
  final int cart_items;

  const BuyPage({Key key, this.cart_items, this.cart_total_price})
      : super(key: key);

  @override
  _BuyPageState createState() =>
      _BuyPageState(this.cart_items, this.cart_total_price);
}

final FirebaseAuth auth = FirebaseAuth.instance;

class _BuyPageState extends State<BuyPage> {
  String apiKey = "f9b414243768565fdcdd840c0abd754a";
  String authToken = "4b13f1ebb304640f40c5ef063bb616ef";
  final int cart_total_price;
  final int cart_items;

  _BuyPageState(this.cart_items, this.cart_total_price);

  final pinCodeController = TextEditingController();
  final addressLine1Controller = TextEditingController();
  final addressLine2Controller = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final mobileController = TextEditingController();

  String userName = "";
  String userId = "";
  String email = "";
  String phoneNumber = "";
  String _platformVersion = 'Unknown';

  Future userDetails() async {
    String uid = await auth.currentUser().then((user) => user.uid);
    DocumentSnapshot userInfo =
        await Firestore.instance.collection('users').document(uid).get();
    setState(() {
      userName = userInfo['name'];
      userId = uid;
      email = userInfo['email'];
      phoneNumber = userInfo['phone'];
    });
  }

  @override
  void initState() {
    userDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle style =
        TextStyle(color: Theme.of(context).primaryColor, fontSize: 14);
    final pinCodeField = Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        child: TextField(
          keyboardType: TextInputType.number,
          obscureText: false,
          maxLength: 6,
          controller: pinCodeController,
          style: style,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              hintText: "Enter Pin Code",
              filled: true,
              fillColor: Colors.white,
              focusedBorder: new OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32.0),
                  borderSide: BorderSide(
                      width: 3, color: Theme.of(context).accentColor)),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32.0))),
        ));

    final addressLine1Field = Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        child: TextField(
          keyboardType: TextInputType.text,
          obscureText: false,
          controller: addressLine1Controller,
          style: style,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              hintText: "Enter Address Line 1",
              filled: true,
              fillColor: Colors.white,
              focusedBorder: new OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32.0),
                  borderSide: BorderSide(
                      width: 3, color: Theme.of(context).accentColor)),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32.0))),
        ));

    final addressLine2Field = Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        child: TextField(
          keyboardType: TextInputType.text,
          obscureText: false,
          controller: addressLine2Controller,
          style: style,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              hintText: "Enter Address Line 2",
              filled: true,
              fillColor: Colors.white,
              focusedBorder: new OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32.0),
                  borderSide: BorderSide(
                      width: 3, color: Theme.of(context).accentColor)),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32.0))),
        ));

    final cityField = Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        child: TextField(
          keyboardType: TextInputType.text,
          obscureText: false,
          controller: cityController,
          style: style,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              hintText: "Enter City",
              filled: true,
              fillColor: Colors.white,
              focusedBorder: new OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32.0),
                  borderSide: BorderSide(
                      width: 3, color: Theme.of(context).accentColor)),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32.0))),
        ));

    final stateField = Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        child: TextField(
          keyboardType: TextInputType.text,
          obscureText: false,
          controller: stateController,
          style: style,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              hintText: "Enter State",
              filled: true,
              fillColor: Colors.white,
              focusedBorder: new OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32.0),
                  borderSide: BorderSide(
                      width: 3, color: Theme.of(context).accentColor)),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32.0))),
        ));

    final mobileField = Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        child: TextField(
          keyboardType: TextInputType.phone,
          obscureText: false,
          controller: mobileController,
          style: style,
          maxLength: 10,
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

    return Scaffold(
      appBar: AppBar(
        title: new Text("Enter Details"),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: new ListView(
                children: <Widget>[
                  pinCodeField,
                  addressLine1Field,
                  addressLine2Field,
                  cityField,
                  stateField,
                  mobileField,
                ],
              ),
            ),
          ),
          SizedBox(
            width: double.infinity,
            height: 60,
            child: new MaterialButton(
              onPressed: () async {
                if (pinCodeController.text.isEmpty ||
                    addressLine1Controller.text.isEmpty ||
                    addressLine2Controller.text.isEmpty ||
                    cityController.text.isEmpty ||
                    stateController.text.isEmpty ||
                    mobileController.text.isEmpty) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: new Text("Enter All Details"),
                        content: new Text("Don't leave any field empty"),
                        actions: <Widget>[
                          new FlatButton(
                            child: new Text("Close"),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  initiatePayment().then((status) {
                    if (status == "SUCCESS") {
                      placeOrder();
                    } else {
                      print("PAYMENT FAILED");
                    }
                  });
                }
              },
              color: Theme.of(context).accentColor,
              child: new Text("Pay with Google Pay".toUpperCase(),
                  style: new TextStyle(color: Theme.of(context).primaryColor)),
            ),
          ),
          SizedBox(
            width: double.infinity,
            height: 60,
            child: new MaterialButton(
              onPressed: () async {
                if (pinCodeController.text.isEmpty ||
                    addressLine1Controller.text.isEmpty ||
                    addressLine2Controller.text.isEmpty ||
                    cityController.text.isEmpty ||
                    stateController.text.isEmpty ||
                    mobileController.text.isEmpty) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: new Text("Enter All Details"),
                        content: new Text("Don't leave any field empty"),
                        actions: <Widget>[
                          new FlatButton(
                            child: new Text("Close"),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  placeOrder();
                }
              },
              color: Colors.red,
              child: new Text("Dummy Pay".toUpperCase(),
                  style: new TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  String orderId = "";

  Future<String> initiatePayment() async {
    final String rand1 = "${new Random().nextInt(100000)}";
    final String rand2 = "${new Random().nextInt(100000)}";
    final String rand3 = "${new Random().nextInt(100000)}";
    final String rand4 = "${new Random().nextInt(100000)}";
    orderId = rand1 + rand2 + rand3 + rand4;

    String response = await FlutterUpi.initiateTransaction(
      app: FlutterUpiApps.GooglePay,
      pa: "9665651918@paytm",
      pn: "Bachat Bazaar",
      tr: orderId,
      tn: "Ordering from Bachat Bazaar",
      am: cart_total_price.toString(),
      cu: "INR",
      url: "https://www.google.com",
    );

    FlutterUpiResponse flutterUpiResponse = FlutterUpiResponse(response);
    print(flutterUpiResponse.txnId); // prints transaction id
    print(flutterUpiResponse.txnRef); //prints transaction ref
    print(flutterUpiResponse.Status); //prints transaction status
    print(flutterUpiResponse.ApprovalRefNo); //prints approval reference number
    print(flutterUpiResponse.responseCode);

    String status = flutterUpiResponse.Status;

    return status;
  }

  placeOrder() async {
    //TEMP
    final String rand1 = "${new Random().nextInt(100000)}";
    final String rand2 = "${new Random().nextInt(100000)}";
    final String rand3 = "${new Random().nextInt(100000)}";
    final String rand4 = "${new Random().nextInt(100000)}";
    orderId = rand1 + rand2 + rand3 + rand4;

    DocumentSnapshot seller = await Firestore.instance
        .collection('users')
        .document(userId)
        .collection('cart')
        .document('0')
        .get();

    Product product = Product.fromJson(seller['product_data']);
    String sellerName = product.productSellerName;
    String sellerId = product.productSellerId;

    List<Map<dynamic, dynamic>> products = new List();
    List<int> productQuantity = new List();
    List<int> productTotalPrice = new List();
    List<String> deliveryUpdates = new List();
    String productImage = "";
    List<int> stocks = new List();

    for (var i = 0; i < cart_items; i++) {
      DocumentSnapshot document = await Firestore.instance
          .collection('users')
          .document(userId)
          .collection('cart')
          .document(i.toString())
          .get();

      products.add(document['product_data']);
      productQuantity.add(document['product_quantity']);
      productTotalPrice.add(document['product_total_price']);
      productImage = document['product_data']['product_image'];
      stocks.add((document['product_data']['product_stock']));
      stocks[i] -= document['product_quantity'];

      int productsCount = 0;

      await Firestore.instance
          .collection('products')
          .getDocuments()
          .then((QuerySnapshot q) async {
        productsCount = q.documents.length;
        print(productsCount);

        for (var j = 0; j < productsCount; j++) {
          DocumentSnapshot d = q.documents[j];

          if ((productImage.compareTo(d['product_image'])) == 0) {
            print("FOUND");
            await Firestore.instance
                .collection('products')
                .document(d.documentID)
                .updateData({'product_stock': stocks[i]});
          }
        }
      });
    }
    for (var i = 0; i < cart_items; i++) {
      await Firestore.instance
          .collection('users')
          .document(userId)
          .collection('cart')
          .document(i.toString())
          .delete();
    }

    await Firestore.instance.collection('users').document(userId).updateData({
      'cart_items': 0,
      'cart_total_price': 0,
    });

    Firestore.instance
        .collection('users')
        .document(userId)
        .collection('orders')
        .document(orderId)
        .setData({
      'order_id': orderId,
      'order_date': DateTime.now(),
      'order_delivery_updates': deliveryUpdates,
      'order_user_id': userId,
      'order_seller_id': sellerId,
      'order_products': products,
      'order_user_name': userName,
      'order_seller_name': sellerName,
      'order_items': cart_items,
      'order_total_price': cart_total_price,
      'order_address_line1': addressLine1Controller.text,
      'order_address_line2': addressLine2Controller.text,
      'order_pincode': pinCodeController.text,
      'order_status': "Confirmed",
      'order_city': cityController.text,
      'order_state': stateController.text,
      'order_products_quantity': productQuantity,
      'order_products_total_price': productTotalPrice,
    });

    Firestore.instance
        .collection('sellers')
        .document(sellerId)
        .collection('orders')
        .document(orderId)
        .setData({
      'order_id': orderId,
      'order_date': DateTime.now(),
      'order_delivery_updates': deliveryUpdates,
      'order_user_id': userId,
      'order_seller_id': sellerId,
      'order_products': products,
      'order_user_name': userName,
      'order_seller_name': sellerName,
      'order_items': cart_items,
      'order_total_price': cart_total_price,
      'order_address_line1': addressLine1Controller.text,
      'order_address_line2': addressLine2Controller.text,
      'order_pincode': pinCodeController.text,
      'order_status': "Confirmed",
      'order_city': cityController.text,
      'order_state': stateController.text,
      'order_products_quantity': productQuantity,
      'order_products_total_price': productTotalPrice,
    });

    String url = "https://api.textlocal.in/send/?";
    String apiKey = "apikey=g5LDhBKYxFE-pQt8DZSR9TzJtt8JLTjHPVSkHEzvkt";
    String message = "&message= " +
        "Congratulations, " +
        userName +
        "\nYour Order for Rs." +
        cart_total_price.toString() +
        " has been placed successfully.\nOrder ID is " +
        orderId;
    String numbers = "&numbers=" + "91" + mobileController.text;
    String data = apiKey + numbers + message;

    var response = await http.post(Uri.encodeFull(url + data));

    print(response.body.toString());

    print("ORDER ID: "+orderId);
    Navigator.pushReplacement(
      context,
      new MaterialPageRoute(
          builder: (context) => new OrderConfirmPage(
                orderId: orderId,
              )),
    );
  }
}
