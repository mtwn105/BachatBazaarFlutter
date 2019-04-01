import 'package:bachatbazaar/ProductPage.dart';
import 'package:bachatbazaar/model/Product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CategoryPage extends StatefulWidget {
  final String category;

  final Color categoryColor;
  const CategoryPage({Key key, this.category, this.categoryColor})
      : super(key: key);
  @override
  _CategoryPageState createState() =>
      _CategoryPageState(this.category, this.categoryColor);
}

final FirebaseAuth auth = FirebaseAuth.instance;

class _CategoryPageState extends State<CategoryPage> {
  final String category;
  final Color categoryColor;
  _CategoryPageState(this.category, this.categoryColor);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(category),
        backgroundColor: categoryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Container(
          child: StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance
                .collection('products')
                .where('product_category_name', isEqualTo: category)
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError)
                return new Text('Error: ${snapshot.error}');

              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, childAspectRatio: 0.7),
                        itemCount: 4,
                        itemBuilder: (BuildContext context, int index) {
                          return loadingWidget();
                        },
                      ));

                default:
                  if (snapshot.data.documents.length == 0) {
                    return new Center(
                      child: new Text("No Products Available."),
                    );
                  } else {
                    return new GridView(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, childAspectRatio: 0.7),
                      children: snapshot.data.documents
                          .map((DocumentSnapshot document) {
                        return buildListTile(context, document);
                      }).toList(),
                    );
                  }
              }
            },
          ),
        ),
      ),
    );
  }
}

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

Widget loadingWidget() {
  return Container(
      height: 290,
      width: 175,
      child: Card(
          shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(16.0),
          ),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300],
            highlightColor: Colors.grey[100],
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: new Container(
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 150,
                        color: Colors.white,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 4.0),
                      child: Container(
                        height: 16,
                        color: Colors.white,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Container(
                        height: 16,
                        color: Colors.white,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 4.0),
                      child: Container(
                        height: 16,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )));
}
