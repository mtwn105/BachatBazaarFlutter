import 'package:bachatbazaar/ProductPage.dart';
import 'package:bachatbazaar/model/Product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class WishlistPage extends StatefulWidget {
  @override
  _WishlistPageState createState() => _WishlistPageState();
}

final FirebaseAuth auth = FirebaseAuth.instance;

class _WishlistPageState extends State<WishlistPage> {
  String userId = "";

  Future userDetails() async {
    String uid = await auth.currentUser().then((user) => user.uid);
    DocumentSnapshot userInfo =
        await Firestore.instance.collection('users').document(uid).get();
    setState(() {
      userId = uid;
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
          title: new Text("Wishlist"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance
                .collection('users')
                .document(userId)
                .collection('wishlist')
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError)
                return new Text('Error: ${snapshot.error}');
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return new Center(child: new Text("Loading..."));
                default:
                  if (snapshot.data.documents.length == 0) {
                    return new Center(child: new Text("Cart is empty."));
                  } else {
                    return new ListView(
                      children: snapshot.data.documents
                          .map((DocumentSnapshot document) {
                        return buildCartListTile(context, document);
                      }).toList(),
                    );
                  }
              }
            },
          ),
        ));
  }
}

Widget buildCartListTile(BuildContext context, DocumentSnapshot document) {

  Product product = Product.fromDocument(document);


  
  bool offer = product.productOffer;

  return GestureDetector(
    onTap: (){
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductPage(product: product),
          ),
        );
    },
      child: Container(
      height: 120,
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
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 8.0,
                              ),
                              child: new Text(
                                "Seller: ",
                                style: new TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 12.0),
                              ),
                            ),
                            new Text(
                              product.productSellerName.toString(),
                              style: new TextStyle(fontSize: 12.0),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 4.0),
                        child: Row(
                          children: <Widget>[
                            offer
                                ? new Text(
                                    "₹" + product.productOfferPrice.toString(),
                                    style: new TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 22.0),
                                  )
                                : new Text(
                                    "₹" + product.productPrice.toString(),
                                    style: new TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 22.0),
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
                                          fontSize: 12.0),
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
                                                          product
                                                              .productOfferPrice) /
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
              new Expanded(
                child: Container(),
              ),
              ClipRRect(
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
    ),
  );
}
