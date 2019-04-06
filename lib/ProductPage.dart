import 'dart:collection';
import 'dart:core';
import 'dart:math';

import 'package:bachatbazaar/CartPage.dart';
import 'package:bachatbazaar/NegotiatePage.dart';
import 'package:bachatbazaar/model/Product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class ProductPage extends StatefulWidget {
  final Product product;

  const ProductPage({Key key, this.product}) : super(key: key);

  @override
  _ProductPageState createState() => _ProductPageState(this.product);
}

final FirebaseAuth auth = FirebaseAuth.instance;

class _ProductPageState extends State<ProductPage>
    with TickerProviderStateMixin {
  bool addToCart = false;

  String category = "";
  Color selectedCategoryColor;
  IconData selectedCategoryIcon;

  bool favorite = false;
  IconData favoriteIcon;
  List categories = ["Food", "Clothes", "Medical", "Handcraft", "Cosmetics"];

  List<Color> categoryColor = [
    Colors.redAccent,
    Colors.pinkAccent,
    Colors.green,
    Colors.purpleAccent,
    Colors.orangeAccent
  ];
  List<IconData> categoryIcons = [
    FontAwesomeIcons.utensils,
    FontAwesomeIcons.tshirt,
    FontAwesomeIcons.briefcaseMedical,
    FontAwesomeIcons.puzzlePiece,
    FontAwesomeIcons.mitten
  ];

  final Product product;
  _ProductPageState(this.product);

  Animation<double> animation;
  AnimationController animationController;

  int quantity;

  String userId = "";
  String phoneNumber = "";

  Future checkFavorite() async {
    QuerySnapshot wishlistCollection = await Firestore.instance
        .collection('users')
        .document(userId)
        .collection('wishlist')
        .getDocuments();
    for (var i = 0; i < wishlist_items; i++) {
      if (wishlistCollection.documents[i].documentID
              .compareTo(product.productID) ==
          0) {
        setState(() {
          favorite = true;
        });
        break;
      }
    }

    setState(() {
      if (favorite) {
        favoriteIcon = FontAwesomeIcons.solidHeart;
      } else {
        favoriteIcon = FontAwesomeIcons.heart;
      }
    });
  }

  void categoryCheck() {
    category = product.productCategoryName;
    switch (category) {
      case "Food":
        selectedCategoryColor = categoryColor[0];
        selectedCategoryIcon = categoryIcons[0];
        break;
      case "Clothes":
        selectedCategoryColor = categoryColor[1];
        selectedCategoryIcon = categoryIcons[1];
        break;
      case "Medical":
        selectedCategoryColor = categoryColor[2];
        selectedCategoryIcon = categoryIcons[2];
        break;
      case "Handcraft":
        selectedCategoryColor = categoryColor[3];
        selectedCategoryIcon = categoryIcons[3];
        break;
      case "Cosmetics":
        selectedCategoryColor = categoryColor[4];
        selectedCategoryIcon = categoryIcons[4];
        break;
      default:
        selectedCategoryColor = categoryColor[0];
        selectedCategoryIcon = categoryIcons[0];
        break;
    }
  }

  int wishlist_items = 0;

  Future userDetails() async {
    String uid = await auth.currentUser().then((user) => user.uid);
    DocumentSnapshot userInfo =
        await Firestore.instance.collection('users').document(uid).get();

    setState(() {
      userId = uid;
      wishlist_items = userInfo['wishlist_items'];
    });

    await checkFavorite();
  }

  @override
  void initState() {
    animationController = new AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);

    final CurvedAnimation logoCurve =
        new CurvedAnimation(parent: animationController, curve: Curves.ease);
    animation = new Tween(begin: 800.0, end: 320.0).animate(logoCurve)
      ..addListener(() {
        setState(() {});
      });
    animationController.forward();
    userDetails();
    categoryCheck();
    quantity = 1;
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var getBackground = new Container(
        child: new Image.network(
      product.productImage,
      fit: BoxFit.cover,
      height: 450,
    ));

    var getGradient = new Container(
      height: 470.0,
      decoration: new BoxDecoration(
        gradient: new LinearGradient(
          colors: <Color>[
            new Color.fromRGBO(207, 208, 211, 0),
            Theme.of(context).primaryColor
          ],
          stops: [0.0, 1.1],
          begin: const FractionalOffset(0.0, 0.0),
          end: const FractionalOffset(0.0, 1.0),
        ),
      ),
    );

    var getContent = new ListView(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 8, 8, 8),
          child: Card(
            margin: EdgeInsets.fromLTRB(4, animation.value, 4, 4),
            shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(16.0)),
            child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: new BorderRadius.circular(16.0),
                        child: new Container(
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                            child: new Text(
                              product.productName,
                              style: new TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0),
                            ),
                          ),
                        ),
                      ),
                      new Expanded(child: Container()),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 8, 8, 0),
                        child: new IconButton(
                          onPressed: () async {
                            int wishlist_items = 0;
                            DocumentSnapshot user = await Firestore.instance
                                .collection('users')
                                .document(userId)
                                .get();

                            wishlist_items = user['wishlist_items'];
                            QuerySnapshot wishlistCollection = await Firestore
                                .instance
                                .collection('users')
                                .document(userId)
                                .collection('wishlist')
                                .getDocuments();

                            setState(() {
                              favorite = !favorite;
                              if (favorite) {
                                favoriteIcon = FontAwesomeIcons.solidHeart;
                              } else {
                                favoriteIcon = FontAwesomeIcons.heart;
                              }
                            });

                            if (favorite) {
                              bool containsAlready = false;
                              for (var i = 0;
                                  i < wishlistCollection.documents.length;
                                  i++) {
                                if (wishlistCollection.documents[i].documentID
                                        .compareTo(product.productID) ==
                                    0) {
                                  containsAlready = true;
                                  break;
                                }
                              }
                              if (!containsAlready) {
                                wishlist_items++;

                                await Firestore.instance
                                    .collection('users')
                                    .document(userId)
                                    .updateData(
                                        {'wishlist_items': wishlist_items});

                                await Firestore.instance
                                    .collection('users')
                                    .document(userId)
                                    .collection('wishlist')
                                    .document(product.productID)
                                    .setData(product.toJson());
                              }
                            } else {
                              wishlist_items--;

                              await Firestore.instance
                                  .collection('users')
                                  .document(userId)
                                  .updateData(
                                      {'wishlist_items': wishlist_items});

                              await Firestore.instance
                                  .collection('users')
                                  .document(userId)
                                  .collection('wishlist')
                                  .document(product.productID)
                                  .delete();
                            }
                          },
                          icon: Icon(
                            favoriteIcon,
                            color: Colors.redAccent,
                          ),
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                    child: new Text(
                      product.productDescShort.toUpperCase(),
                      softWrap: true,
                      style: new TextStyle(
                          letterSpacing: 1.0,
                          fontSize: 10.0,
                          color: Colors.grey,
                          fontWeight: FontWeight.w700),
                      maxLines: 2,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                    child: product.productOffer
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              new Text(
                                "₹" + product.productOfferPrice.toString(),
                                softWrap: true,
                                style: new TextStyle(
                                    fontSize: 26.0,
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.w700),
                                maxLines: 2,
                              ),
                              new Padding(
                                padding:
                                    new EdgeInsets.symmetric(horizontal: 2.0),
                              ),
                              new Text(
                                product.productPrice.toString(),
                                softWrap: true,
                                style: new TextStyle(
                                    fontSize: 18.0,
                                    color: Colors.blueGrey,
                                    decoration: TextDecoration.lineThrough,
                                    fontWeight: FontWeight.w700),
                                maxLines: 2,
                              ),
                              new Padding(
                                padding:
                                    new EdgeInsets.symmetric(horizontal: 2.0),
                              ),
                              ClipRRect(
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
                              ),
                            ],
                          )
                        : new Text(
                            "₹" + product.productPrice.toString(),
                            softWrap: true,
                            style: new TextStyle(
                                fontSize: 26.0,
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.w700),
                            maxLines: 2,
                          ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 8, 8, 4),
                    child: Container(
                      alignment: Alignment.center,
                      color: Colors.grey,
                      //Theme.of(context).accentColor,
                      child: new SizedBox.fromSize(
                        size: Size(100.0, 0.5),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        new Text(
                          "Category: ",
                          softWrap: true,
                          style: new TextStyle(
                              fontSize: 14.0,
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w700),
                          maxLines: 2,
                        ),
                        new Padding(
                          padding: new EdgeInsets.symmetric(horizontal: 2.0),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8.0, 4, 8, 0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              color: selectedCategoryColor,
                              child: Row(
                                children: <Widget>[
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(8, 4, 2, 4),
                                    child: Icon(
                                      selectedCategoryIcon,
                                      size: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(2, 4, 4, 4),
                                    child: new Text(
                                      product.productCategoryName.toUpperCase(),
                                      style: new TextStyle(
                                          fontSize: 12.0, color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        new Text(
                          "Description: ",
                          softWrap: true,
                          style: new TextStyle(
                              fontSize: 14.0,
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w700),
                          maxLines: 2,
                        ),
                        new Padding(
                          padding: new EdgeInsets.symmetric(horizontal: 2.0),
                        ),
                        Flexible(
                          child: new Text(
                            product.productDesc,
                            softWrap: true,
                            style: new TextStyle(
                              fontFamily: "Subtitle",
                              fontSize: 14.0,
                            ),
                            maxLines: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        new Text(
                          "Seller: ",
                          softWrap: true,
                          style: new TextStyle(
                              fontSize: 14.0,
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w700),
                          maxLines: 2,
                        ),
                        new Padding(
                          padding: new EdgeInsets.symmetric(horizontal: 2.0),
                        ),
                        new Text(
                          product.productSellerName,
                          softWrap: true,
                          style: new TextStyle(
                            fontSize: 14.0,
                            fontFamily: "Subtitle",
                          ),
                          maxLines: 10,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        new Text(
                          "In Stock: ",
                          softWrap: true,
                          style: new TextStyle(
                              fontSize: 14.0,
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w700),
                          maxLines: 2,
                        ),
                        new Padding(
                          padding: new EdgeInsets.symmetric(horizontal: 2.0),
                        ),
                        new Text(
                          product.productStock.toString() + " Available",
                          softWrap: true,
                          style: new TextStyle(
                            fontSize: 14.0,
                            fontFamily: "Subtitle",
                          ),
                          maxLines: 10,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 8, 8, 4),
                    child: Container(
                      alignment: Alignment.center,
                      color: Colors.grey,
                      //Theme.of(context).accentColor,
                      child: new SizedBox.fromSize(
                        size: Size(100.0, 0.5),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        new Text(
                          "Quantity: ",
                          softWrap: true,
                          style: new TextStyle(
                              fontSize: 14.0,
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w700),
                          maxLines: 2,
                        ),
                        new Padding(
                          padding: new EdgeInsets.symmetric(horizontal: 2.0),
                        ),
                        Container(
                          decoration: new BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(16)),
                          height: 30,
                          child: new Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(
                                height: 30,
                                width: 40,
                                child: new FlatButton(
                                  child: new Text(
                                    "-",
                                    style: new TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      if (quantity != 1) {
                                        quantity--;
                                      }

                                      print(quantity);
                                    });
                                    //Navigator.of(context).pop();
                                  },
                                ),
                              ),
                              Container(
                                  alignment: Alignment.center,
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(16),
                                      child: Container(
                                        alignment: Alignment.center,
                                        height: 30,
                                        width: 30,
                                        color: Theme.of(context).primaryColor,
                                        child: new Text(
                                          quantity.toString(),
                                          style: new TextStyle(
                                              fontSize: 15,
                                              color: Colors.white),
                                        ),
                                      ))),
                              SizedBox(
                                height: 30,
                                width: 40,
                                child: new FlatButton(
                                  child: new Text(
                                    "+",
                                    style: new TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      quantity++;
                                    });
                                    print(quantity);
                                    //Navigator.of(context).pop();
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  addToCart
                      ? new Container(
                          height: 60,
                          decoration: BoxDecoration(
                              color: Theme.of(context).accentColor,
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(16),
                                  bottomRight: Radius.circular(16))),
                          child: Center(
                              child: Text(
                            "Adding...",
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                            ),
                          )),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              height: 60,
                              alignment: Alignment.center,
                              child: SizedBox(
                                height: 60,
                                width:
                                    MediaQuery.of(context).size.width / 2 - 12,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(16.0),
                                  ),
                                  child: RaisedButton(
                                    child: new Text("Negotiate"),
                                    color: Colors.orangeAccent,
                                    onPressed: () async {
                                      if (quantity >= product.productMinStock) {
                                        Navigator.push(
                                          context,
                                          new MaterialPageRoute(
                                              builder: (context) =>
                                                  new NegotiatePage(
                                                      product: product)),
                                        );
                                      } else {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title:
                                                  new Text("Can't Negotiate"),
                                              content: new Text(
                                                "Purchase at least " +
                                                    product.productMinStock
                                                        .toString() +
                                                    " quantity to enter the negotitation",
                                                style: new TextStyle(
                                                    fontFamily: "Subtitle"),
                                              ),
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
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              height: 60,
                              alignment: Alignment.center,
                              child: SizedBox(
                                height: 60,
                                width:
                                    MediaQuery.of(context).size.width / 2 - 12,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(16)),
                                  child: RaisedButton(
                                    child: new Text("Add to Cart"),
                                    color: Theme.of(context).accentColor,
                                    onPressed: () async {
                                      DocumentSnapshot user = await Firestore
                                          .instance
                                          .collection('users')
                                          .document(userId)
                                          .get();

                                      int cart_items = user['cart_items'];
                                      int cart_price = user['cart_total_price'];

                                      bool alreadyPresentInCart = false;
                                      bool sameSeller = true;
                                      for (var i = 0; i < cart_items; i++) {
                                        DocumentSnapshot cartData =
                                            await Firestore.instance
                                                .collection('users')
                                                .document(userId)
                                                .collection('cart')
                                                .document(i.toString())
                                                .get();

                                        Product cartProduct = Product.fromJson(
                                            cartData['product_data']);

                                        if (cartProduct.productImage ==
                                            product.productImage) {
                                          alreadyPresentInCart = true;
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: new Text(
                                                      "Product Already in Cart"),
                                                  content: new Text(
                                                    "Empty the cart and then add the product again.",
                                                    style: new TextStyle(
                                                        fontFamily: "Subtitle"),
                                                  ),
                                                  actions: <Widget>[
                                                    new FlatButton(
                                                      child: new Text("Close"),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                    ),
                                                  ],
                                                );
                                              });
                                          break;
                                        }

                                        if (cartProduct.productSellerName !=
                                            product.productSellerName) {
                                          sameSeller = false;
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: new Text(
                                                      "Can't add to cart"),
                                                  content: new Text(
                                                    "You cannot add two products from two different sellers. ",
                                                    style: new TextStyle(
                                                        fontFamily: "Subtitle"),
                                                  ),
                                                  actions: <Widget>[
                                                    new FlatButton(
                                                      child: new Text("Close"),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                    ),
                                                  ],
                                                );
                                              });
                                          break;
                                        }
                                      }

                                      if (!alreadyPresentInCart && sameSeller) {
                                        setState(() {
                                          addToCart = true;
                                        });

                                        int totalPrice = quantity *
                                            (product.productOffer
                                                ? product.productOfferPrice
                                                : product.productPrice);

                                        Map<String, dynamic> productData =
                                            new HashMap();
                                        productData['product_data'] =
                                            product.toJson();
                                        productData['product_price'] =
                                            product.productOffer
                                                ? product.productOfferPrice
                                                : product.productPrice;
                                        productData['product_quantity'] =
                                            quantity;
                                        productData['product_total_price'] =
                                            totalPrice;

                                        print(cart_items);
                                        print(cart_price);

                                        cart_items++;
                                        cart_price += totalPrice;

                                        await Firestore.instance
                                            .collection('users')
                                            .document(userId)
                                            .collection('cart')
                                            .document(
                                                (cart_items - 1).toString())
                                            .setData(productData);

                                        await Firestore.instance
                                            .collection('users')
                                            .document(userId)
                                            .updateData({
                                          'cart_items': cart_items,
                                          'cart_total_price': cart_price,
                                        });

                                        setState(() {
                                          addToCart = false;
                                        });

                                        Navigator.push(
                                          context,
                                          new MaterialPageRoute(
                                              builder: (context) =>
                                                  new CartPage()),
                                        );
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                ]),
          ),
        ),
        Padding(
          child: new Card(
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text("You might also like",
                        style: new TextStyle(fontSize: 20)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: StreamBuilder<QuerySnapshot>(
                      stream: Firestore.instance
                          .collection('products')
                          .where('product_category_name',
                              isEqualTo: product.productCategoryName)
                          .snapshots(),
                      builder:
                          (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError)
                          return new Text('Error: ${snapshot.error}');
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                            return new Center(child: new Text("Loading..."));
                          default:
                            if (snapshot.data.documents.length == 0 || snapshot.data.documents.length == 1) {
                              return new Center(
                                  child: new Text("No Related Products."));
                            } else {
                              return new Column(
                                children: snapshot.data.documents
                                    .map((DocumentSnapshot document) {
                                  Product product =
                                      Product.fromDocument(document);
                                  if (product.productName== widget.product.productName) {
                                    return Container();
                                  } else {
                                    return buildSimilarProdictListTile(
                                        context, document);
                                  }
                                }).toList(),
                              );
                            }
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(16.0)),
          ),
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        )
      ],
    );

    var getToolbar = new Container(
      margin: new EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          new BackButton(color: Colors.white),
        ],
      ),
    );

    return Scaffold(
        body: Container(
            color: Theme.of(context).primaryColor,
            child: Stack(children: <Widget>[
              getBackground,
              getGradient,
              getContent,
              getToolbar,
            ])));
  }
}

Widget buildSimilarProdictListTile(
    BuildContext context, DocumentSnapshot document) {
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
      height: 120,
      child: Card(
        elevation: 16,
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
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12.0),
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
                                          decoration:
                                              TextDecoration.lineThrough,
                                          color: Colors.blueGrey,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12.0),
                                    )
                                  : new Container(),
                            ),
                            new Padding(
                              padding:
                                  new EdgeInsets.symmetric(horizontal: 2.0),
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
