import 'package:bachatbazaar/ProductPage.dart';
import 'package:bachatbazaar/model/Product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';

final FirebaseAuth auth = FirebaseAuth.instance;

Widget buildOrdersListTile(BuildContext context, DocumentSnapshot document) {

  DateTime order_date = document['order_date'];
  String formatted = formatDate(order_date, [dd, ' ',MM,' ',yyyy]);

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

  return Container(
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
                            padding: const EdgeInsets.fromLTRB(8.0, 0, 8, 0),
                            child: new Text(
                              "₹" + document['order_total_price'].toString(),
                              style: new TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 26.0),
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
  );
}
