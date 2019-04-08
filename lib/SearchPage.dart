import 'package:bachatbazaar/ProductPage.dart';
import 'package:bachatbazaar/model/Product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_search/material_search.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String _selected;
  var productNameList = new List();
  var productList = new List();
  @override
   initState() {
     _fetchList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new MaterialSearch<String>(
        placeholder: "Search Products",

        results: productNameList
            .map((name) => new MaterialSearchResult<String>(
                  value: name, //The value must be of type <String>
                  text: name, //String that will be show in the list
                  icon: FontAwesomeIcons.box,
                ))
            .toList(),

        onSelect: (dynamic selected) {
         Product product = productList.singleWhere((product)=>product.productName.compareTo(selected)==0);
           Navigator.push(
                context,
                new MaterialPageRoute(builder: (context) => new ProductPage(product: product)),
              );
        },
        onSubmit: (String value) {
          print(value);
        },
      ),
    );
  }

  _fetchList() async {

    await Firestore.instance
        .collection('products')
        .getDocuments()
        .then((QuerySnapshot q) {
          
      for (var i = 0; i < q.documents.length; i++) {
        Product product = Product.fromDocument(q.documents[i]);
        String productName = q.documents[i].data['product_name'];
        print(productName);
        productNameList.add(productName);
        productList.add(product);
      }
    });
  }
}
