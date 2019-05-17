import 'package:bachatbazaar/CartPage.dart';
import 'package:bachatbazaar/CategoryPage.dart';
import 'package:bachatbazaar/LoginPage.dart';
import 'package:bachatbazaar/OrdersPage.dart';
import 'package:bachatbazaar/ProductPage.dart';
import 'package:bachatbazaar/SearchPage.dart';
import 'package:bachatbazaar/WishlistPage.dart';
import 'package:bachatbazaar/model/Product.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shimmer/shimmer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

final FirebaseAuth auth = FirebaseAuth.instance;

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  List categories = ["Food", "Clothes", "Medical", "Handcraft", "Cosmetics"];
  bool isOpen = false;

  AnimationController _controller;
  Animation<double> _scaleAnimation;

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

  String getName(FirebaseUser user) {
    if (user != null) {
      return user.displayName;
    } else {
      return null;
    }
  }

  String userName = "A";
  String email = "";
  String phoneNumber = "";

  Future userDetails() async {
    String uid = await auth.currentUser().then((user) => user.uid);
    DocumentSnapshot userInfo =
        await Firestore.instance.collection('users').document(uid).get();
    setState(() {
      userName = userInfo['name'];
      email = userInfo['email'];
      phoneNumber = userInfo['phone'];
      print(userName);
    });
  }

  @override
  void initState() {
    userDetails();
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _scaleAnimation = Tween<double>(begin: 1, end: 0.6).animate(_controller);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    Widget _appBarTitle = new Text(
      'SHOP NOW'.toUpperCase(),
      style: TextStyle(
        letterSpacing: 1.4,
        fontSize: 20.0,
        color: Theme.of(context).primaryColor,
      ),
    );

    Color primaryColor = Theme.of(context).primaryColor;
    Color bgColor = new Color(0xfffafafA);

    TextStyle style = TextStyle(
        color: Theme.of(context).primaryColor,
        fontSize: 14,
        fontWeight: FontWeight.bold);

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            width: double.infinity,
            color: primaryColor,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 48.0, 0, 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        CircleAvatar(
                          radius: size.height * 0.06,
                          backgroundColor: Theme.of(context).accentColor,
                          child: Text(
                            userName[0],
                            style: TextStyle(fontSize: 36.0),
                          ),
                        ),
                        SizedBox(height: 20.0),
                        Text(
                          userName,
                          style: TextStyle(
                              fontSize: 18,
                              color: Theme.of(context).accentColor),
                        ),
                        SizedBox(height: 5.0),
                        Text(
                          email,
                          style: TextStyle(fontSize: 14, color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 40.0),
                  ListTile(
                    title: Text(
                      "Shop Now",
                      style: TextStyle(fontSize: 14, color: Colors.white),
                    ),
                    leading: Icon(
                      Icons.dashboard,
                      color: Colors.white,
                    ),
                  ),
                  ListTile(
                    title: Text(
                      "Wishlist",
                      style: TextStyle(fontSize: 14, color: Colors.white54),
                    ),
                    leading: Icon(
                      Icons.favorite,
                      color: Colors.white54,
                    ),
                    onTap: () {
                      setState(() {
                        isOpen = !isOpen;
                        _controller.reverse();
                      });
                      Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => new WishlistPage()),
                      );
                    },
                  ),
                  ListTile(
                    title: Text(
                      "Your Cart",
                      style: TextStyle(fontSize: 14, color: Colors.white54),
                    ),
                    leading: Icon(
                      Icons.shopping_cart,
                      color: Colors.white54,
                    ),
                    onTap: () {
                      setState(() {
                        isOpen = !isOpen;
                        _controller.reverse();
                      });
                      Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => new CartPage()),
                      );
                    },
                  ),
                  ListTile(
                    title: Text(
                      "Your Orders",
                      style: TextStyle(fontSize: 14, color: Colors.white54),
                    ),
                    leading: Icon(
                      Icons.stars,
                      color: Colors.white54,
                    ),
                    onTap: () {
                      setState(() {
                        isOpen = !isOpen;
                        _controller.reverse();
                      });
                      Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => new OrdersPage()),
                      );
                    },
                  ),
                  Expanded(
                    child: Container(),
                  ),
                  ListTile(
                    title: Text(
                      "Log Out",
                      style: TextStyle(fontSize: 14, color: Colors.white),
                    ),
                    leading: Icon(
                      Icons.exit_to_app,
                      color: Colors.white,
                    ),
                    onTap: () {
                      setState(() {
                        isOpen = !isOpen;
                        _controller.reverse();
                      });
                      auth.signOut();
                      Navigator.pushReplacement(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => new LoginPage()),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          AnimatedPositioned(
            duration: Duration(microseconds: 500),
            top: isOpen ? 0.02 * size.height : 0,
            bottom: isOpen ? 0.02 * size.height : 0,
            left: isOpen ? 0.4 * size.width : 0,
            right: isOpen ? -0.6 * size.width : 0,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: InkWell(
                onTap: () {
                  if (isOpen) {
                    setState(() {
                      isOpen = !isOpen;
                      _controller.reverse();
                    });
                  }
                },
                child: Material(
                  borderRadius: BorderRadius.circular(16.0),
                  elevation: 8.0,
                  child: Column(
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.only(top: 32),
                        child: Stack(
                          children: <Widget>[
                            Container(
                                margin: EdgeInsets.only(top: 14.0),
                                alignment: Alignment.center,
                                child: _appBarTitle),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                IconButton(
                                  icon: Icon(FontAwesomeIcons.bars,
                                      color: primaryColor, size: 16.0),
                                  onPressed: () {
                                    setState(() {
                                      if (!isOpen) {
                                        _controller.forward();
                                      } else {
                                        _controller.reverse();
                                      }
                                      isOpen = !isOpen;
                                    });
                                  },
                                ),
                                Row(
                                  children: <Widget>[
                                    IconButton(
                                      icon: Icon(
                                        FontAwesomeIcons.search,
                                        size: 16,
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          new MaterialPageRoute(
                                              builder: (context) =>
                                                  new SearchPage()),
                                        );
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        FontAwesomeIcons.shoppingCart,
                                        size: 16,
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          new MaterialPageRoute(
                                              builder: (context) =>
                                                  new CartPage()),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: new ListView(
                          // mainAxisAlignment: MainAxisAlignment.start,
                          //  crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(16.0, 0, 16, 16),
                              child: new Text(
                                "Categories",
                                style: style,
                              ),
                            ),
                            Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: Container(
                                  height: 100,
                                  width: 100,
                                  child: new ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: 5,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    CategoryPage(
                                                      category:
                                                          categories[index],
                                                      categoryColor:
                                                          categoryColor[index],
                                                    ),
                                              ),
                                            );
                                          },
                                          child: Container(
                                            height: 100,
                                            width: 100,
                                            decoration: new BoxDecoration(
                                              shape: BoxShape.circle,
                                            ),
                                            child: InkWell(
                                              child: new Material(
                                                shape:
                                                    new RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                ),
                                                child: new Center(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                        new Icon(
                                                          categoryIcons[index],
                                                          size: 18,
                                                          color: categoryColor[
                                                              index],
                                                        ),
                                                        new SizedBox(
                                                          height: 10,
                                                        ),
                                                        new Text(
                                                          categories[index],
                                                          style: new TextStyle(
                                                              fontSize: 12),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                elevation: 4.0,
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                )),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: new Text(
                                "Featured",
                                style: style,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 16.0, right: 16.0),
                              child: Container(
                                height: size.height * 0.4,
                                child: StreamBuilder<QuerySnapshot>(
                                  stream: Firestore.instance
                                      .collection('products')
                                      .where('product_offer', isEqualTo: true)
                                      .limit(5)
                                      .snapshots(),
                                  builder: (context,
                                      AsyncSnapshot<QuerySnapshot> snapshot) {
                                    if (snapshot.hasError)
                                      return new Text(
                                          'Error: ${snapshot.error}');
                                    switch (snapshot.connectionState) {
                                      case ConnectionState.waiting:
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8.0),
                                          child: ListView.builder(
                                            shrinkWrap: true,
                                            scrollDirection: Axis.horizontal,
                                            itemCount: 5,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return loadingWidget();
                                            },
                                          ),
                                        );

                                      default:
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8.0),
                                          child: new ListView(
                                            scrollDirection: Axis.horizontal,
                                            children: snapshot.data.documents
                                                .map((DocumentSnapshot
                                                    document) {
                                              return _buildListTile(
                                                  context, document);
                                            }).toList(),
                                          ),
                                        );
                                    }
                                  },
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: new Text(
                                "Food",
                                style: TextStyle(
                                    color: categoryColor[0],
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 16.0, right: 16.0),
                              child: Container(
                                height: size.height * 0.4,
                                child: StreamBuilder<QuerySnapshot>(
                                  stream: Firestore.instance
                                      .collection('products')
                                      .where('product_category_name',
                                          isEqualTo: 'Food')
                                      .limit(5)
                                      .snapshots(),
                                  builder: (context,
                                      AsyncSnapshot<QuerySnapshot> snapshot) {
                                    if (snapshot.hasError)
                                      return new Text(
                                          'Error: ${snapshot.error}');
                                    switch (snapshot.connectionState) {
                                      case ConnectionState.waiting:
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8.0),
                                          child: ListView.builder(
                                            shrinkWrap: true,
                                            scrollDirection: Axis.horizontal,
                                            itemCount: 5,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return loadingWidget();
                                            },
                                          ),
                                        );
                                      default:
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8.0),
                                          child: new ListView(
                                            scrollDirection: Axis.horizontal,
                                            children: snapshot.data.documents
                                                .map((DocumentSnapshot
                                                    document) {
                                              return _buildListTile(
                                                  context, document);
                                            }).toList(),
                                          ),
                                        );
                                    }
                                  },
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: new Text(
                                "Handcraft",
                                style: TextStyle(
                                    color: categoryColor[3],
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 16.0, right: 16.0),
                              child: SizedBox(
                                height: size.height * 0.4,
                                child: StreamBuilder<QuerySnapshot>(
                                  stream: Firestore.instance
                                      .collection('products')
                                      .where('product_category_name',
                                          isEqualTo: 'Handcraft')
                                      .limit(5)
                                      .snapshots(),
                                  builder: (context,
                                      AsyncSnapshot<QuerySnapshot> snapshot) {
                                    if (snapshot.hasError)
                                      return new Text(
                                          'Error: ${snapshot.error}');
                                    switch (snapshot.connectionState) {
                                      case ConnectionState.waiting:
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8.0),
                                          child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            itemCount: 5,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return loadingWidget();
                                            },
                                          ),
                                        );
                                      default:
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8.0),
                                          child: new ListView(
                                            scrollDirection: Axis.horizontal,
                                            children: snapshot.data.documents
                                                .map((DocumentSnapshot
                                                    document) {
                                              return _buildListTile(
                                                  context, document);
                                            }).toList(),
                                          ),
                                        );
                                    }
                                  },
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: new Text(
                                "Medical",
                                style: TextStyle(
                                    color: categoryColor[2],
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 16.0, right: 16.0),
                              child: SizedBox(
                                height: size.height * 0.4,
                                child: StreamBuilder<QuerySnapshot>(
                                  stream: Firestore.instance
                                      .collection('products')
                                      .where('product_category_name',
                                          isEqualTo: 'Medical')
                                      .limit(5)
                                      .snapshots(),
                                  builder: (context,
                                      AsyncSnapshot<QuerySnapshot> snapshot) {
                                    if (snapshot.hasError)
                                      return new Text(
                                          'Error: ${snapshot.error}');
                                    switch (snapshot.connectionState) {
                                      case ConnectionState.waiting:
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8.0),
                                          child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            itemCount: 5,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return loadingWidget();
                                            },
                                          ),
                                        );
                                      default:
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8.0),
                                          child: new ListView(
                                            scrollDirection: Axis.horizontal,
                                            children: snapshot.data.documents
                                                .map((DocumentSnapshot
                                                    document) {
                                              return _buildListTile(
                                                  context, document);
                                            }).toList(),
                                          ),
                                        );
                                    }
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListTile(BuildContext context, DocumentSnapshot document) {
    Product product = Product.fromDocument(document);
    var size = MediaQuery.of(context).size;

    bool offer = product.productOffer;
    //Rreturn tempWidget();
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
        margin: EdgeInsets.all(8),
        width: size.width * 0.45,
        decoration: new BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          borderRadius: new BorderRadius.circular(16.0),
          boxShadow: <BoxShadow>[
            new BoxShadow(
              color: Colors.black12,
              blurRadius: 10.0,
              offset: new Offset(0.0, 5.0),
            ),
          ],
        ),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.only(
                  topLeft: new Radius.circular(16.0),
                  topRight: Radius.circular(16.0)),
              child: new Image.network(
                product.productImage,
                height: size.height * 0.23,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: new Text(
                product.productName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
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
                maxLines: 1,
                style: new TextStyle(
                  color: Colors.grey,
                  fontSize: 12.0,
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
                              fontWeight: FontWeight.bold, fontSize: 22.0),
                        )
                      : new Text(
                          "₹" + product.productPrice.toString(),
                          style: new TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 22.0),
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
}
