import 'dart:convert';
import 'dart:math';

import 'package:bachatbazaar/MainPage.dart';
import 'package:bachatbazaar/model/Product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:http/http.dart' as http;
import 'package:paytm/paytm.dart';

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

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await Paytm.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  void initState() {
    userDetails();
    initPlatformState();

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
      body: Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 8, 8, 0),
        child: new Column(
          children: <Widget>[
            pinCodeField,
            addressLine1Field,
            addressLine2Field,
            cityField,
            stateField,
            mobileField,
            Expanded(
              child: Container(),
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
                    payWithPaytm(context);
                    /*
                                        final String rand1 = "${new Random().nextInt(100000)}";
                                        final String rand2 = "${new Random().nextInt(100000)}";
                                        final String rand3 = "${new Random().nextInt(100000)}";
                                        final String rand4 = "${new Random().nextInt(100000)}";
                                        final String orderId = rand1 + rand2 + rand3 + rand4;
                    
                                        DocumentSnapshot seller = await Firestore.instance
                                            .collection('users')
                                            .document(userId)
                                            .collection('cart')
                                            .document('0')
                                            .get();
                    
                                        Product product = Product.fromJson(seller['product_data']);
                                        String sellerName = product.productSellerName;
                                        String sellerId = product.productSellerId;
                    
                                          List<Map<dynamic,dynamic>> products = new List();
                                          List<int> product_quantity = new List();
                                          List<int> product_total_price = new List();
                    
                                        for (var i = 0; i < cart_items; i++) {
                                          DocumentSnapshot document = await Firestore.instance
                                              .collection('users')
                                              .document(userId)
                                              .collection('cart')
                                              .document(i.toString())
                                              .get();
                                         
                                          products.add(document['product_data']);
                                          product_quantity.add(document['product_quantity']);
                                          product_total_price.add(document['product_total_price']);
                                        }
                                        for (var i = 0; i < cart_items; i++) {
                                          await Firestore.instance
                                              .collection('users')
                                              .document(userId)
                                              .collection('cart')
                                              .document(i.toString())
                                              .delete();
                                        }
                    
                                        await Firestore.instance
                                            .collection('users')
                                            .document(userId)
                                            .updateData({
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
                                          'order_user_id':userId,
                                          'order_seller_id':sellerId,
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
                                          'order_products_quantity':product_quantity,
                                          'order_products_total_price':product_total_price,
                                        });
                    
                                          Firestore.instance
                                            .collection('sellers')
                                            .document(sellerId)
                                            .collection('orders')
                                            .document(orderId)
                                            .setData({
                                          'order_id': orderId,
                                          'order_user_id':userId,
                                          'order_seller_id':sellerId,
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
                                          'order_products_quantity':product_quantity,
                                          'order_products_total_price':product_total_price,
                                        });
                    
                                        String url = "https://api.textlocal.in/send/?";
                                        String apiKey =
                                            "apikey=g5LDhBKYxFE-pQt8DZSR9TzJtt8JLTjHPVSkHEzvkt";
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
                                        Navigator.pushReplacement(
                                          context,
                                          new MaterialPageRoute(
                                              builder: (context) => new MainPage()),
                                        );
                                        */
                  }
                },
                color: Theme.of(context).accentColor,
                child: new Text("Pay Using Paytm ",
                    style:
                        new TextStyle(color: Theme.of(context).primaryColor)),
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
                    final String rand1 = "${new Random().nextInt(100000)}";
                    final String rand2 = "${new Random().nextInt(100000)}";
                    final String rand3 = "${new Random().nextInt(100000)}";
                    final String rand4 = "${new Random().nextInt(100000)}";
                    final String orderId = rand1 + rand2 + rand3 + rand4;

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
                    List<int> product_quantity = new List();
                    List<int> product_total_price = new List();
                    List<String> delivery_updates = new List();
                    String product_image = "";
                    List<int> stocks = new List();

                    for (var i = 0; i < cart_items; i++) {
                      DocumentSnapshot document = await Firestore.instance
                          .collection('users')
                          .document(userId)
                          .collection('cart')
                          .document(i.toString())
                          .get();

                      products.add(document['product_data']);
                      product_quantity.add(document['product_quantity']);
                      product_total_price.add(document['product_total_price']);
                      product_image = document['product_data']['product_image'];
                      stocks.add((document['product_data']['product_stock']));
                      stocks[i] -= document['product_quantity'];

                      int products_count = 0;

                      await Firestore.instance
                          .collection('products')
                          .getDocuments()
                          .then((QuerySnapshot q) async {
                        products_count = q.documents.length;
                        print(products_count);

                        for (var j = 0; j < products_count; j++) {
                          DocumentSnapshot d = q.documents[j];

                          if ((product_image.compareTo(d['product_image'])) ==
                              0) {
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

                    await Firestore.instance
                        .collection('users')
                        .document(userId)
                        .updateData({
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
                      'order_delivery_updates': delivery_updates,
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
                      'order_products_quantity': product_quantity,
                      'order_products_total_price': product_total_price,
                    });

                    Firestore.instance
                        .collection('sellers')
                        .document(sellerId)
                        .collection('orders')
                        .document(orderId)
                        .setData({
                      'order_id': orderId,
                      'order_date': DateTime.now(),
                      'order_delivery_updates': delivery_updates,
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
                      'order_products_quantity': product_quantity,
                      'order_products_total_price': product_total_price,
                    });

                    String url = "https://api.textlocal.in/send/?";
                    String apiKey =
                        "apikey=g5LDhBKYxFE-pQt8DZSR9TzJtt8JLTjHPVSkHEzvkt";
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
                    Navigator.pushReplacement(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => new MainPage()),
                    );
                  }
                },
                color: Colors.red,
                child: new Text("Buy Now " + "₹" + cart_total_price.toString(),
                    style: new TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future payWithPaytm(BuildContext context) async {
    const kAndroidUserAgent =
        "Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.94 Mobile Safari/537.36";
    Map<String, String> body = {
      "amount": cart_total_price.toString(), //amount to be paid
      "purpose": "Buying from Bachat Bazaar",
      "buyer_name": userName,
      "email": email,
      "phone": phoneNumber,
      "allow_repeated_payments": "true",
      "send_email": "false",
      "send_sms": "false",
      "redirect_url": "http://www.example.com/redirect/",
    };

//First we have to create a Payment_Request.
//then we'll take the response of our request.
    var resp = await http.post(
        Uri.encodeFull("https://www.instamojo.com/api/1.1/payment-requests/"),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded",
          "X-Api-Key": apiKey,
          "X-Auth-Token": authToken,
        },
        body: body);
    print(resp.body);
    if (json.decode(resp.body)['success'] == true) {
//If request is successful take the longurl.
      print(resp.body);
      String selectedUrl =
          json.decode(resp.body)["payment_request"]['longurl'].toString() +
              "?embed=form";

      /*  Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) => new PaymentPage(url: selectedUrl)),
      ); */

      /*    final flutterWebviewPlugin = new FlutterWebviewPlugin();

      flutterWebviewPlugin.onUrlChanged.listen((String url) {
        if (mounted) {
          if (url.contains('http://www.example.com/redirect')) {
            Uri uri = Uri.parse(url);
//Take the payment_id parameter of the url.
            String paymentRequestId = uri.queryParameters['payment_id'];
//calling this method to check payment status
            _checkPaymentStatus(paymentRequestId);
          }
        }
      }); 

      flutterWebviewPlugin.launch(selectedUrl,
          rect: new Rect.fromLTRB(
              5.0,
              MediaQuery.of(context).size.height / 7,
              MediaQuery.of(context).size.width - 5.0,
              7 * MediaQuery.of(context).size.height / 7),
          userAgent: kAndroidUserAgent);
    
    */
      _launchURL(context, selectedUrl);
    } else {
      print(json.decode(resp.body)['message'].toString());
    }
  }

  void _launchURL(BuildContext context, String url) async {
    try {
      await launch(
        url,
        option: new CustomTabsOption(
          toolbarColor: Theme.of(context).primaryColor,
          enableDefaultShare: true,
          showPageTitle: true,
          enableUrlBarHiding: true,
          animation: new CustomTabsAnimation.slideIn(),
          extraCustomTabs: <String>[
            // ref. https://play.google.com/store/apps/details?id=org.mozilla.firefox
            'org.mozilla.firefox',
            // ref. https://play.google.com/store/apps/details?id=com.microsoft.emmx
            'com.microsoft.emmx',
          ],
        ),
      );
    } catch (e) {
      // An exception is thrown if browser app is not installed on Android device.
      debugPrint(e.toString());
    }
  }

  _checkPaymentStatus(String id) async {
    var response = await http.get(
        Uri.encodeFull("https://www.instamojo.com/api/1.1/payments/$id/"),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded",
          "X-Api-Key": apiKey,
          "X-Auth-Token": authToken,
        });
    var realResponse = json.decode(response.body);
    print(realResponse);
    if (realResponse['success'] == true) {
      if (realResponse["payment"]['status'] == 'Credit') {
        print("PAYMENT COMPLETED");
//payment is successful.
      } else {
//payment failed or pending.
        print("PAYMENT PENDING");
      }
    } else {
      print("PAYMENT STATUS FAILED");
    }
  }
}
