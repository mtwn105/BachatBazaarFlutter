import 'package:bachatbazaar/AddProductPage.dart';
import 'package:bachatbazaar/AllProductListTile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AllProductsPage extends StatefulWidget {
  @override
  _AllProductsPageState createState() => _AllProductsPageState();
}

final FirebaseAuth auth = FirebaseAuth.instance;

class _AllProductsPageState extends State<AllProductsPage> {
  List categories = ["Food", "Clothes", "Medical", "Handcraft", "Cosmetics"];

  String sellerName;
  String sellerId;

  Future userDetails() async {
    String uid = await auth.currentUser().then((user) => user.uid);
    DocumentSnapshot userInfo =
        await Firestore.instance.collection('sellers').document(uid).get();
    setState(() {
      sellerName = userInfo['seller_name'];
      sellerId = uid;
      print(sellerName);
    });
  }

  @override
  void initState() {
    // TODO: implement initState

    userDetails();
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
        title: new Text("Products"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance
              .collection('products')
              .where('product_seller_id', isEqualTo: sellerId)
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return new Center(child: new Text("Loading..."));
              default:
                return new GridView(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, childAspectRatio: 0.6),
                  children:
                      snapshot.data.documents.map((DocumentSnapshot document) {
                    return buildListTile(context, document);
                  }).toList(),
                );
            }
          },
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            new MaterialPageRoute(builder: (context) => new AddProductPage()),
          );
        },
        child: new Icon(Icons.add),
      ),
    );
  }
}
