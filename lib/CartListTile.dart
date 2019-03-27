import 'package:bachatbazaar/ProductPage.dart';
import 'package:bachatbazaar/model/Product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final FirebaseAuth auth = FirebaseAuth.instance;

Widget buildCartListTile(BuildContext context, DocumentSnapshot document) {



  Product product = Product.fromJson(document['product_data']);
  int product_price = document['product_price'];
  int product_quantity  = document['product_quantity'];
  int product_total_price = document['product_total_price'];


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
              padding: const EdgeInsets.only(left:8.0),
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 4.0),
                      child: new Text(
                        product.productName,
                        style: new TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                            fontSize: 16.0),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: new Text(
                        product.productDescShort,
                        style:
                            new TextStyle(color: Colors.grey, fontSize: 12.0),
                      ),
                    ),
                    Padding(
                       padding: const EdgeInsets.only(top:4.0),
                       child: Row(
                         children: <Widget>[
                           Padding(
                            padding: const EdgeInsets.only(
                                left: 8.0,),
                            child: new Text(
                                     "Seller: ",
                                     style: new TextStyle(
                                         fontWeight: FontWeight.bold,
                                         fontSize: 12.0),
                                   ),
                    ),
                           new Text(
                                    product.productSellerName.toString(),
                                    style: new TextStyle(
                                        fontSize: 12.0),
                                  ),
                         ],
                       ),
                     ),
                     Padding(
                       padding: const EdgeInsets.symmetric(vertical:4.0),
                       child: Row(
                         children: <Widget>[
                           Padding(
                            padding: const EdgeInsets.only(
                                left: 8.0,),
                            child: new Text(
                                     "Quantity: ",
                                     style: new TextStyle(
                                         fontWeight: FontWeight.bold,
                                         fontSize: 14.0),
                                   ),
                    ),
                           new Text(
                                    product_quantity.toString(),
                                    style: new TextStyle(
                                        fontSize: 14.0),
                                  ),
                         ],
                       ),
                     ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                           8.0,0,8,4),
                      child: new Text(
                               "₹" + product_total_price.toString(),
                               style: new TextStyle(
                                   fontWeight: FontWeight.bold,
                                   fontSize: 22.0),
                             ),
                    ),
                  ],
                ),
              ),
            ),
            new Expanded(child: Container(),)
,             ClipRRect(
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(16.0),
                  topRight: new Radius.circular(16.0)),
              child: new Image.network(
                product.productImage,
                width: 170,
                fit: BoxFit.cover,
              ),
            ),
           
          ],
        ),
      ),
    ),
    
  );

}
