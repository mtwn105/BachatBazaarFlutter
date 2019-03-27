import 'dart:io';
import 'dart:math';
import 'package:bachatbazaar/AllProductsPage.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:bachatbazaar/model/Product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddProductPage extends StatefulWidget {
  @override
  _AddProductPageState createState() => _AddProductPageState();
}

final FirebaseAuth auth = FirebaseAuth.instance;

String imagePath = "";
bool imageSelected = false;
bool uploading = false;
String firebaseImagePath;
File imageFile;

class _AddProductPageState extends State<AddProductPage> {
  String sellerName;
  String sellerId;

  final productNameController = TextEditingController();
  final productDescController = TextEditingController();
  final productShortDescController = TextEditingController();
  final productImageController = TextEditingController();
  final productMinPriceController = TextEditingController();
  final productMinStockController = TextEditingController();
  final productPriceController = TextEditingController();
  final productOfferPriceController = TextEditingController();
  final productStockController = TextEditingController();
  bool productFeatured = false;
  bool productOffer = false;

  List categories = ["Food", "Clothes", "Medical", "Handcraft", "Cosmetics"];

  List<DropdownMenuItem<String>> _dropDownMenuItems;
  String currentCategory;

  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = new List();
    for (String category in categories) {
      items.add(
          new DropdownMenuItem(value: category, child: new Text(category)));
    }
    return items;
  }

  Future<Null> uploadHandle(String imagePath, BuildContext context) async {
    final String rand1 = "${new Random().nextInt(100000)}";
    final String rand2 = "${new Random().nextInt(100000)}";
    final String rand3 = "${new Random().nextInt(100000)}";
    final String rand4 = "${new Random().nextInt(100000)}.jpg";
    final String fileName = rand1 + rand2 + rand3 + rand4;
    final StorageReference reference =
        FirebaseStorage.instance.ref().child(fileName);
    final StorageUploadTask task = reference.putFile(imageFile);
    var downloadUrl = await (await task.onComplete).ref.getDownloadURL();
    firebaseImagePath = downloadUrl.toString();

    await handleProductUpload();
    Navigator.pushReplacement(
      context,
      new MaterialPageRoute(builder: (context) => new AllProductsPage()),
    );

    print(firebaseImagePath);
  }

  uploadImage(BuildContext context) {
    setState(() {
      uploading = true;
    });
    uploadHandle(imagePath, context);
  }

  Future userDetails() async {
    String uid = await auth.currentUser().then((user) => user.uid);
    DocumentSnapshot userInfo =
        await Firestore.instance.collection('sellers').document(uid).get();
    setState(() {
      sellerName = userInfo['seller_name'];
      sellerId = uid;
    });
  }

  Future handleProductUpload() async {
    if (!productOffer) {
      if (productNameController.text.isEmpty ||
          productDescController.text.isEmpty ||
          productShortDescController.text.isEmpty ||
          productMinPriceController.text.isEmpty ||
          productMinStockController.text.isEmpty ||
          productPriceController.text.isEmpty) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: new Text("Enter All Details"),
              content: new Text("Don't leave any field empty"),
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
      } else {
        Product product = new Product(
            productName: productNameController.text,
            productCategoryName: currentCategory,
            productDesc: productDescController.text,
            productDescShort: productShortDescController.text,
            productFeatured: productFeatured,
            productMinPrice: int.parse(productMinPriceController.text),
            productMinStock: int.parse(productMinStockController.text),
            productPrice: int.parse(productPriceController.text),
            productOffer: productOffer,
            productStock: int.parse(productStockController.text),
            productSellerId: sellerId,
            productSellerName: sellerName,
            productImage: firebaseImagePath);

        final String rand1 = "${new Random().nextInt(100000)}";
        final String rand2 = "${new Random().nextInt(100000)}";
        final String rand3 = "${new Random().nextInt(100000)}";
        final String rand4 = "${new Random().nextInt(100000)}";
        final String productId = rand1 + rand2 + rand3 + rand4;

        product.productID = productId;

        await Firestore.instance
            .collection("products")
            .document(productId)
            .setData(product.toJson());
      }
    } else {
      if (productNameController.text.isEmpty ||
          productDescController.text.isEmpty ||
          productShortDescController.text.isEmpty ||
          productMinPriceController.text.isEmpty ||
          productMinStockController.text.isEmpty ||
          productPriceController.text.isEmpty ||
          productOfferPriceController.text.isEmpty) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: new Text("Enter All Details"),
              content: new Text("Don't leave any field empty"),
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
      } else {
        print(firebaseImagePath);
        Product product = new Product(
            productName: productNameController.text,
            productCategoryName: currentCategory,
            productDesc: productDescController.text,
            productDescShort: productShortDescController.text,
            productFeatured: productFeatured,
            productMinPrice: int.parse(productMinPriceController.text),
            productMinStock: int.parse(productMinStockController.text),
            productPrice: int.parse(productPriceController.text),
            productOffer: productOffer,
            productOfferPrice: int.parse(productOfferPriceController.text),
            productStock: int.parse(productStockController.text),
            productSellerId: sellerId,
            productSellerName: sellerName,
            productImage: firebaseImagePath);

        final String rand1 = "${new Random().nextInt(100000)}";
        final String rand2 = "${new Random().nextInt(100000)}";
        final String rand3 = "${new Random().nextInt(100000)}";
        final String rand4 = "${new Random().nextInt(100000)}";
        final String productId = rand1 + rand2 + rand3 + rand4;
        product.productID = productId;
        await Firestore.instance
            .collection("products")
            .document(productId)
            .setData(product.toJson());
      }
    }
  }

  @override
  void initState() {
    _dropDownMenuItems = getDropDownMenuItems();
    currentCategory = _dropDownMenuItems[0].value;
    userDetails();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    imageSelected = false;
    imageFile = null;
    imagePath = "";
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle style =
        TextStyle(color: Theme.of(context).primaryColor, fontSize: 14);
    final productNameField = Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        child: TextField(
          keyboardType: TextInputType.emailAddress,
          obscureText: false,
          controller: productNameController,
          style: style,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              hintText: "Product Name",
              filled: true,
              fillColor: Colors.white,
              focusedBorder: new OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32.0),
                  borderSide: BorderSide(
                      width: 3, color: Theme.of(context).accentColor)),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32.0))),
        ));

    final productDescShortField = Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        child: TextField(
          keyboardType: TextInputType.text,
          obscureText: false,
          controller: productShortDescController,
          style: style,
          maxLength: 35,
          maxLines: 1,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              hintText: "Product Short Description",
              filled: true,
              fillColor: Colors.white,
              focusedBorder: new OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32.0),
                  borderSide: BorderSide(
                      width: 3, color: Theme.of(context).accentColor)),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32.0))),
        ));

    final productDescField = Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        child: TextField(
          keyboardType: TextInputType.text,
          obscureText: false,
          controller: productDescController,
          style: style,
          maxLines: 1,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              hintText: "Product Description",
              filled: true,
              fillColor: Colors.white,
              focusedBorder: new OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32.0),
                  borderSide: BorderSide(
                      width: 3, color: Theme.of(context).accentColor)),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32.0))),
        ));

    final productMinPriceField = Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        child: TextField(
          keyboardType: TextInputType.number,
          obscureText: false,
          controller: productMinPriceController,
          style: style,
          maxLines: 1,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              hintText: "Product Minimum Price (for bulk purchase)",
              filled: true,
              fillColor: Colors.white,
              focusedBorder: new OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32.0),
                  borderSide: BorderSide(
                      width: 3, color: Theme.of(context).accentColor)),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32.0))),
        ));

    final productOfferPriceField = Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        child: TextField(
          keyboardType: TextInputType.number,
          obscureText: false,
          controller: productOfferPriceController,
          style: style,
          maxLines: 1,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              hintText: "Product Offer Price (if offer enabled)",
              filled: true,
              fillColor: Colors.white,
              focusedBorder: new OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32.0),
                  borderSide: BorderSide(
                      width: 3, color: Theme.of(context).accentColor)),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32.0))),
        ));

    final productMinStockField = Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        child: TextField(
          keyboardType: TextInputType.number,
          obscureText: false,
          controller: productMinStockController,
          style: style,
          maxLines: 1,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              hintText: "Product Minimum Stock (for bulk purchase)",
              filled: true,
              fillColor: Colors.white,
              focusedBorder: new OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32.0),
                  borderSide: BorderSide(
                      width: 3, color: Theme.of(context).accentColor)),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32.0))),
        ));

    final productStockField = Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        child: TextField(
          keyboardType: TextInputType.number,
          obscureText: false,
          controller: productStockController,
          style: style,
          maxLines: 1,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              hintText: "Product Available Stock",
              filled: true,
              fillColor: Colors.white,
              focusedBorder: new OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32.0),
                  borderSide: BorderSide(
                      width: 3, color: Theme.of(context).accentColor)),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32.0))),
        ));

    final productPriceField = Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        child: TextField(
          keyboardType: TextInputType.number,
          obscureText: false,
          controller: productPriceController,
          style: style,
          maxLines: 1,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              hintText: "Product Price",
              filled: true,
              fillColor: Colors.white,
              focusedBorder: new OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32.0),
                  borderSide: BorderSide(
                      width: 3, color: Theme.of(context).accentColor)),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32.0))),
        ));

    final uploadImageButton = imageSelected
        ? new Image.file(
            imageFile,
            height: 400.0,
            width: 400.0,
          )
        : new GestureDetector(
            onTap: getImage,
            child: new Container(
              height: 300,
              margin: new EdgeInsets.only(top: 24.0),
              decoration: new BoxDecoration(color: Colors.grey[50]),
              child: new Center(
                child: CircleAvatar(
                  backgroundColor: Theme.of(context).primaryColor,
                  radius: 50,
                  child: new Icon(Icons.add_a_photo,
                      size: 50.0, color: Theme.of(context).accentColor),
                ),
              ),
            ),
          );

    return Scaffold(
      appBar: new AppBar(
        title: new Text("Add Product"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: new ListView(
          children: <Widget>[
            uploadImageButton,
            productNameField,
            productDescShortField,
            productDescField,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: new Text("Product Category",
                      style: new TextStyle(fontSize: 16)),
                ),
                Expanded(child: new Container()),
                new DropdownButton(
                  value: currentCategory,
                  items: _dropDownMenuItems,
                  onChanged: changedDropDownItem,
                ),
              ],
            ),
            productPriceField,
            productStockField,
            productMinPriceField,
            productMinStockField,
            CheckboxListTile(
              title: new Text("Offer"),
              value: productOffer,
              onChanged: (bool v) {
                setState(() {
                  productOffer = v;
                });
              },
            ),
            productOffer ? productOfferPriceField : new Container(),
            CheckboxListTile(
              title: new Text("Featured"),
              value: productFeatured,
              onChanged: (bool v) {
                setState(() {
                  productFeatured = v;
                });
              },
            ),
          ],
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: () async {
          await uploadImage(context);
        },
        child: new Icon(Icons.add),
      ),
    );
  }

  void changedDropDownItem(String selectedCity) {
    setState(() {
      currentCategory = selectedCity;
    });
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      imageFile = image;
      imagePath = imageFile.path;
      imageSelected = true;
    });
  }
}
