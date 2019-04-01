import 'package:bachatbazaar/CartPage.dart';
import 'package:bachatbazaar/LoginPage.dart';
import 'package:bachatbazaar/OrdersPage.dart';
import 'package:bachatbazaar/ProductPage.dart';
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

class _MainPageState extends State<MainPage> {
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
    CollectionReference productsList =
        Firestore.instance.collection('products');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle style = TextStyle(
        color: Theme.of(context).primaryColor,
        fontSize: 14,
        fontWeight: FontWeight.bold);

    return Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        title: new Text("Bachat Bazaar"),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              FontAwesomeIcons.shoppingCart,
              size: 16,
            ),
            onPressed: () {
              Navigator.push(
                context,
                new MaterialPageRoute(builder: (context) => new CartPage()),
              );
            },
          ),
        ],
      ),
      body: new ListView(
        // mainAxisAlignment: MainAxisAlignment.start,
        //  crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: new Text(
              "Categories",
              style: style,
            ),
          ),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                height: 100,
                width: 100,
                child: new ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 5,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 100,
                        width: 100,
                        decoration: new BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: InkWell(
                          child: new Material(
                            shape: new RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: new Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    new Icon(
                                      categoryIcons[index],
                                      size: 18,
                                      color: categoryColor[index],
                                    ),
                                    new SizedBox(
                                      height: 10,
                                    ),
                                    new Text(
                                      categories[index],
                                      style: new TextStyle(fontSize: 12),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            elevation: 4.0,
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
            padding: const EdgeInsets.only(left: 16.0, right: 16.0),
            child: Container(
              height: 275,
              child: StreamBuilder<QuerySnapshot>(
                stream: Firestore.instance
                    .collection('products')
                    .where('product_offer', isEqualTo: true)
                    .limit(5)
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError)
                    return new Text('Error: ${snapshot.error}');
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 5,
                          itemBuilder: (BuildContext context, int index) {
                            return loadingWidget();
                          },
                        ),
                      );

                    default:
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical:8.0),
                        child: new ListView(
                          scrollDirection: Axis.horizontal,
                          children: snapshot.data.documents
                              .map((DocumentSnapshot document) {
                            return _buildListTile(context, document);
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
            padding: const EdgeInsets.only(left: 16.0, right: 16.0),
            child: Container(
              height: 275,
              child: StreamBuilder<QuerySnapshot>(
                stream: Firestore.instance
                    .collection('products')
                    .where('product_category_name', isEqualTo: 'Food')
                    .limit(5)
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError)
                    return new Text('Error: ${snapshot.error}');
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 5,
                        itemBuilder: (BuildContext context, int index) {
                          return loadingWidget();
                        },
                      );
                    default:
                      return new ListView(
                        scrollDirection: Axis.horizontal,
                        children: snapshot.data.documents
                            .map((DocumentSnapshot document) {
                          return _buildListTile(context, document);
                        }).toList(),
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
            padding: const EdgeInsets.only(left: 16.0, right: 16.0),
            child: SizedBox(
              height: 275,
              child: StreamBuilder<QuerySnapshot>(
                stream: Firestore.instance
                    .collection('products')
                    .where('product_category_name', isEqualTo: 'Handcraft')
                    .limit(5)
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError)
                    return new Text('Error: ${snapshot.error}');
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 5,
                        itemBuilder: (BuildContext context, int index) {
                          return loadingWidget();
                        },
                      );
                    default:
                      return new ListView(
                        scrollDirection: Axis.horizontal,
                        children: snapshot.data.documents
                            .map((DocumentSnapshot document) {
                          return _buildListTile(context, document);
                        }).toList(),
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
            padding: const EdgeInsets.only(left: 16.0, right: 16.0),
            child: SizedBox(
              height: 275,
              child: StreamBuilder<QuerySnapshot>(
                stream: Firestore.instance
                    .collection('products')
                    .where('product_category_name', isEqualTo: 'Medical')
                    .limit(5)
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError)
                    return new Text('Error: ${snapshot.error}');
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 5,
                        itemBuilder: (BuildContext context, int index) {
                          return loadingWidget();
                        },
                      );
                    default:
                      return new ListView(
                        scrollDirection: Axis.horizontal,
                        children: snapshot.data.documents
                            .map((DocumentSnapshot document) {
                          return _buildListTile(context, document);
                        }).toList(),
                      );
                  }
                },
              ),
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text(userName),
              accountEmail:
                  Text(email, style: new TextStyle(fontFamily: "Subtitle")),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Theme.of(context).accentColor,
                child: Text(
                  userName[0],
                  style: TextStyle(fontSize: 40.0),
                ),
              ),
            ),
            ListTile(
              title: Text("Wishlist"),
              leading: Icon(
                Icons.favorite,
                color: Theme.of(context).primaryColor,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  new MaterialPageRoute(builder: (context) => new WishlistPage()),
                );
              },
            ),
            ListTile(
              title: Text("Cart"),
              leading: Icon(
                Icons.shopping_basket,
                color: Theme.of(context).primaryColor,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  new MaterialPageRoute(builder: (context) => new CartPage()),
                );
              },
            ),
            ListTile(
              title: Text("Orders"),
              leading: Icon(
                Icons.stars,
                color: Theme.of(context).primaryColor,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  new MaterialPageRoute(builder: (context) => new OrdersPage()),
                );
              },
            ),
            Expanded(
              child: Container(),
            ),
            ListTile(
              title: Text("Log out",
                  style: new TextStyle(
                    color: Theme.of(context).primaryColor,
                  )),
              leading: Icon(
                Icons.exit_to_app,
                color: Theme.of(context).primaryColor,
              ),
              onTap: () {
                auth.signOut();
                Navigator.pushReplacement(
                  context,
                  new MaterialPageRoute(builder: (context) => new LoginPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListTile(BuildContext context, DocumentSnapshot document) {
    Product product = Product.fromDocument(document);

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
        height: 300,
        width: 175,
        decoration: new BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          borderRadius: new BorderRadius.circular(8.0),
          boxShadow: <BoxShadow>[
            new BoxShadow(
              color: Colors.black12,
              blurRadius: 10.0,
              offset: new Offset(0.0, 5.0),
            ),
          ],
        ),
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
