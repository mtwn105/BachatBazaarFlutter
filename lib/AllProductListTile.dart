import 'package:bachatbazaar/ProductPage.dart';
import 'package:bachatbazaar/model/Product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

Widget buildListTile(BuildContext context, DocumentSnapshot document) {
  Product product = Product.fromDocument(document);

  bool offer = product.productOffer;

  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProductPage(product: product),
        ),
      );
    },
    child: Container(
      child: Card(
        shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(16.0),
        ),
        child: new Container(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.only(
                    topLeft: new Radius.circular(16.0),
                    topRight: Radius.circular(16.0)),
                child: new Image.network(
                  product.productImage,
                  height: 150,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: new Text(
                  product.productName,
                  maxLines: 2,
                  softWrap: true,
                  style: new TextStyle(
                    fontFamily: "Title",
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                      fontSize: 18.0),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: new Text(
                  product.productDescShort,
                  maxLines: 1,
                  style: new TextStyle(color: Colors.grey, fontSize: 12.0),
                ),
              ),
              Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 4, 8, 0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    color: Theme.of(context).primaryColor,
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: new Text(
                        product.productCategoryName.toUpperCase(),
                        style: new TextStyle(fontSize: 10.0,color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: Row(
                  children: <Widget>[
                    offer
                        ? new Text(
                            "₹" + product.productOfferPrice.toString(),
                            style: new TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 24.0),
                          )
                        : new Text(
                            "₹" + product.productPrice.toString(),
                            style: new TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 24.0),
                          ),
                    Padding(
                      padding: const EdgeInsets.only(left: 2.0),
                      child: offer
                          ? new Text(
                              product.productPrice.toString(),
                              style: new TextStyle(
                                  decoration: TextDecoration.lineThrough,
                                  color: Colors.blueGrey,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.0),
                            )
                          : new Container(),
                    ),
                    new Padding(
                      padding: new EdgeInsets.symmetric(horizontal: 2.0),
                    ),
                    offer
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(16.0),
                            child: Container(
                              color: Colors.green,
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: new Text(
                                  ((product.productPrice -
                                                  product.productOfferPrice) /
                                              product.productPrice *
                                              100)
                                          .round()
                                          .toString() +
                                      "% off",
                                  softWrap: true,
                                  style: new TextStyle(
                                      fontSize: 12.0,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700),
                                  maxLines: 2,
                                ),
                              ),
                            ),
                          )
                        : new Container(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
