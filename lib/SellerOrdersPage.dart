import 'package:bachatbazaar/OrdersListTile.dart';
import 'package:bachatbazaar/SellersOrdersListTile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SellerOrdersPage extends StatefulWidget {
  @override
  _SellerOrdersPageState createState() => _SellerOrdersPageState();
}

final FirebaseAuth auth = FirebaseAuth.instance;

class _SellerOrdersPageState extends State<SellerOrdersPage> {
  List order_status_list = ["Confirmed", "Processing", "Delivered"];

  List<DropdownMenuItem<String>> _dropDownMenuItems;
  String currentCategory;

  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = new List();
    for (String category in order_status_list) {
      items.add(
          new DropdownMenuItem(value: category, child: new Text(category)));
    }
    return items;
  }

  String userName = "";
  String userId = "";
  String email = "";
  String phoneNumber = "";
  int cart_items = 0;
  int cart_total_price = 0;

  Future userDetails() async {
    String uid = await auth.currentUser().then((user) => user.uid);
    DocumentSnapshot userInfo =
        await Firestore.instance.collection('sellers').document(uid).get();
    setState(() {
      userName = userInfo['seller_name'];
      userId = uid;
      print(userName);
    });
  }

  @override
  void initState() {
    userDetails();
    _dropDownMenuItems = getDropDownMenuItems();
    currentCategory = _dropDownMenuItems[0].value;

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
              .collection('sellers')
              .document(userId)
              .collection('orders')
              .orderBy('order_date',descending: true)
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
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
                      return buildSellersOrdersListTile(context, document);
                    }).toList(),
                  );
                }
            }
          },
        ),
      ),
    );
  }

  Widget buildSellersOrdersListTile(
      BuildContext context, DocumentSnapshot document) {
    DateTime order_date = document['order_date'];
    String formatted = formatDate(order_date, [dd, ' ', MM, ' ', yyyy]);

    String order_status = document['order_status'];
    Color color;

    switch (order_status) {
      case "Confirmed":
        color = Colors.blueAccent;
        break;
      case "Processing":
        color = Colors.green;
        break;
      case "Delivered":
        color = Colors.purple;
        break;
      default:
        break;
    }

    return GestureDetector(
      onTap: () async {
        String uid = await auth.currentUser().then((user) => user.uid);
        await Firestore.instance
            .collection('sellers')
            .document(uid)
            .collection('orders')
            .document(document['order_id'])
            .updateData({'order_status': 'Processing'});
        await Firestore.instance
            .collection('users')
            .document(document['order_user_id'])
            .collection('orders')
            .document(document['order_id'])
            .updateData({'order_status': 'Processing'});
      },
      child: Container(
        height: 140,
        child: Card(
          shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(16.0),
          ),
          child: new Container(
            child: new Row(
              // mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Row(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 8.0,
                                  ),
                                  child: new Text(
                                    "ORDER ID: ",
                                    style: new TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.0),
                                  ),
                                ),
                                new Text(
                                  document['order_id'].toString(),
                                  style: new TextStyle(fontSize: 16.0,fontFamily: "Subtitle"),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Row(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 8.0,
                                  ),
                                  child: new Text(
                                    "Order Date: ",
                                    style: new TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.0),
                                  ),
                                ),
                                new Text(
                                  formatted,
                                  style: new TextStyle(fontSize: 16.0,fontFamily: "Subtitle"),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Row(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 8.0,
                                  ),
                                  child: new Text(
                                    "Items: ",
                                    style: new TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.0),
                                  ),
                                ),
                                new Text(
                                  document['order_items'].toString(),
                                  style: new TextStyle(fontSize: 16.0,fontFamily: "Subtitle"),
                                ),
                              ],
                            ),
                          ),
                          new Expanded(
                            child: Container(),
                          ),
                       /*   Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: new Text("Product Category",
                                        style: new TextStyle(fontSize: 16)),
                                  ),
                                  Expanded(child: new Container()),
                                  new DropdownButton(
                                    value: currentCategory,
                                    items: _dropDownMenuItems,
                                    onChanged: changedDropDownItem,
                                  ),
                                ],
                              ),

                              */
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              ClipRRect(
                                borderRadius: BorderRadius.circular(16.0),
                                child: Container(
                                  color: color,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: new Text(
                                      order_status.toUpperCase(),
                                      softWrap: true,
                                      style: new TextStyle(
                                          fontSize: 12.0,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700),
                                      maxLines: 2,
                                    ),
                                  ),
                                ),
                              ),
                              
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(8.0, 0, 8, 0),
                                child: new Text(
                                  "₹" +
                                      document['order_total_price'].toString(),
                                  style: new TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 26.0),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void changedDropDownItem(String selectedCity) {
    setState(() {
      currentCategory = selectedCity;
    });
  }
}
