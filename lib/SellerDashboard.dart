import 'package:bachatbazaar/AllProductsPage.dart';
import 'package:bachatbazaar/LoginPage.dart';
import 'package:bachatbazaar/SellerOrdersPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_sparkline/flutter_sparkline.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class SellerDashboard extends StatefulWidget {
  @override
  _SellerDashboardState createState() => _SellerDashboardState();
}

final FirebaseAuth auth = FirebaseAuth.instance;

class _SellerDashboardState extends State<SellerDashboard> {
  List<charts.Series<OrdersInfo, int>> lastOrderPriceList = new List();
  List<OrdersInfo> orders = new List();
  List<charts.Series<OrderCategory, String>> categoryOrdersList = new List();
  List<OrderCategory> categoryOrders = new List();
  int totalOrders = 0;
  int totalProducts = 0;
  double totalRevenue = 0;
  String uid = "";
  List<double> orderTotalPriceList = [0];
  List<DateTime> orderDateList = new List();

  int totalSold = 0;
  int foodItemsSold = 0;
  int clothesItemsSold = 0;
  int medicalItemsSold = 0;
  int handcraftItemsSold = 0;
  int cosmeticsItemsSold = 0;

  String userName = "A";
  String email = "";
  String phoneNumber = "";

  Future userDetails() async {
    String uid = await auth.currentUser().then((user) => user.uid);
    DocumentSnapshot userInfo =
        await Firestore.instance.collection('sellers').document(uid).get();
    setState(() {
      userName = userInfo['seller_name'];
      email = userInfo['email'];
      print(userName);
    });
  }

  Future getSellerData() async {
    String u = await auth.currentUser().then((user) => user.uid);
    setState(() {
      uid = u;
    });

    Firestore.instance
        .collection('sellers')
        .document(uid)
        .collection('orders')
        .getDocuments()
        .then((QuerySnapshot q) {
      setState(() {
        if (q.documents.length != 0) {
          totalOrders = q.documents.length;
        }
      });
    });

    Firestore.instance
        .collection('products')
        .where('product_seller_id', isEqualTo: uid)
        .getDocuments()
        .then((QuerySnapshot q) {
      setState(() {
        if (q.documents.length != 0) {
          totalProducts = q.documents.length;
        }
      });
    });

    Firestore.instance
        .collection('sellers')
        .document(uid)
        .collection('orders')
        .limit(10)
        .orderBy('order_date', descending: true)
        .getDocuments()
        .then((QuerySnapshot d) {
      for (var i = 0; i < d.documents.length; i++) {
        if (i == 0) {
          setState(() {
            DateTime orderDate = d.documents[i].data['order_date'];
            double orderPrice =
                d.documents[i].data['order_total_price'].toDouble();
            orderTotalPriceList[0] =
                d.documents[i].data['order_total_price'].toDouble();

            OrdersInfo ordersInfo = new OrdersInfo(i, orderPrice);
            orders.add(ordersInfo);
          });
        } else {
          setState(() {
            DateTime orderDate = d.documents[i].data['order_date'];
            double orderPrice =
                d.documents[i].data['order_total_price'].toDouble();
            orderTotalPriceList
                .add(d.documents[i].data['order_total_price'].toDouble());

            OrdersInfo ordersInfo = new OrdersInfo(i, orderPrice);
            orders.add(ordersInfo);
          });
        }
      }
    });
    await Firestore.instance
        .collection('sellers')
        .document(uid)
        .collection('orders')
        .getDocuments()
        .then((QuerySnapshot d) {
      for (var i = 0; i < d.documents.length; i++) {
        for (var j = 0; j < d.documents[i].data['order_items']; j++) {
          String productCategory =
              d.documents[i].data['order_products'][j]['product_category_name'];

          switch (productCategory) {
            case "Food":
              setState(() {
                foodItemsSold +=
                    d.documents[i].data['order_products_quantity'][j];
              });

              break;
            case "Clothes":
              setState(() {
                clothesItemsSold +=
                    d.documents[i].data['order_products_quantity'][j];
              });

              break;
            case "Medical":
              setState(() {
                medicalItemsSold +=
                    d.documents[i].data['order_products_quantity'][j];
              });
              break;
            case "Handcraft":
              setState(() {
                handcraftItemsSold +=
                    d.documents[i].data['order_products_quantity'][j];
              });
              break;
            case "Cosmetics":
              setState(() {
                cosmeticsItemsSold +=
                    d.documents[i].data['order_products_quantity'][j];
              });
              break;
            default:
              break;
          }
        }
        setState(() {
          totalRevenue += d.documents[i].data['order_total_price'].toDouble();
        });
      }
    });

    setState(() {
      lastOrderPriceList = _orderTotalPrice();

      OrderCategory foodCategory = new OrderCategory(foodItemsSold, "Food");
      categoryOrders.add(foodCategory);
      OrderCategory clothesCategory =
          new OrderCategory(clothesItemsSold, "Clothes");
      categoryOrders.add(clothesCategory);
      OrderCategory medicalCategory =
          new OrderCategory(medicalItemsSold, "Medical");
      categoryOrders.add(medicalCategory);
      OrderCategory handcraftCategory =
          new OrderCategory(handcraftItemsSold, "Handcraft");
      categoryOrders.add(handcraftCategory);
      OrderCategory cosmeticsCategory =
          new OrderCategory(cosmeticsItemsSold, "Cosmetics");
      categoryOrders.add(cosmeticsCategory);

      categoryOrdersList = _categoryOrdersData();

      totalSold = foodItemsSold +
          clothesItemsSold +
          medicalItemsSold +
          handcraftItemsSold +
          cosmeticsItemsSold;
    });

    print(orderTotalPriceList);
  }

  List<charts.Series<OrdersInfo, int>> _orderTotalPrice() {
    return [
      new charts.Series<OrdersInfo, int>(
        id: 'Orders',
        displayName: 'Last 10 orders',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (OrdersInfo orders, _) => orders.orderDate,
        measureFn: (OrdersInfo orders, _) => orders.orderPrice,
        data: orders,
      )
    ];
  }

  List<charts.Series<OrderCategory, String>> _categoryOrdersData() {
    return [
      new charts.Series<OrderCategory, String>(
        id: 'Order Category',
        domainFn: (OrderCategory orderCategory, _) =>
            orderCategory.categoryName,
        measureFn: (OrderCategory orderCategory, _) =>
            orderCategory.numOfOrders,
        data: categoryOrders,
      )
    ];
  }

  @override
  void initState() {
    getSellerData();
    userDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    new MaterialPageRoute(
                        builder: (context) => new LoginPage()),
                  );
                },
              ),
            ],
          ),
        ),
        appBar: new AppBar(
          centerTitle: true,
          leading: Icon(Icons.menu),
          title: new Text("Dashboard"),
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(4,4,4,0),
          child: new ListView(
            children: <Widget>[
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
                child: Material(
                    elevation: 14.0,
                    borderRadius: BorderRadius.circular(12.0),
                    shadowColor: Color(0x802196F3),
                    child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (context) => new SellerOrdersPage()),
                          );
                        },
                        child: Container(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                            child: Row(
                              children: <Widget>[
                                new Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text("Total Orders"),
                                    Text(
                                      totalOrders.toString(),
                                      style: TextStyle(
                                          fontSize: 40,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                                new Expanded(
                                  child: Container(),
                                ),
                                new ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: new Container(
                                    height: 60,
                                    width: 60,
                                    color: Theme.of(context).primaryColor,
                                    child: new Center(
                                      child: new Icon(
                                        FontAwesomeIcons.shoppingBag,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          height: 100,
                        ))),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
                child: Material(
                    elevation: 14.0,
                    borderRadius: BorderRadius.circular(12.0),
                    shadowColor: Color(0x802196F3),
                    child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (context) => new AllProductsPage()),
                          );
                        },
                        child: Container(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                            child: Row(
                              children: <Widget>[
                                new Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text("Total Products"),
                                    Text(
                                      totalProducts.toString(),
                                      style: TextStyle(
                                          fontSize: 40,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                                new Expanded(
                                  child: Container(),
                                ),
                                new ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: new Container(
                                    height: 60,
                                    width: 60,
                                    color: Theme.of(context).primaryColor,
                                    child: new Center(
                                      child: new Icon(
                                        FontAwesomeIcons.th,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          height: 100,
                        ))),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
                child: Material(
                    elevation: 14.0,
                    borderRadius: BorderRadius.circular(12.0),
                    shadowColor: Color(0x802196F3),
                    child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (context) => new SellerOrdersPage()),
                          );
                        },
                        child: Container(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                            child: Row(
                              children: <Widget>[
                                new Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text("Total Revenue"),
                                    Text(
                                      "₹" + totalRevenue.toString(),
                                      style: TextStyle(
                                          fontSize: 40,
                                          fontWeight: FontWeight.bold),
                                   maxLines: 1, )
                                  ],
                                ),
                                new Expanded(
                                  child: Container(),
                                ),
                                new ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: new Container(
                                    height: 60,
                                    width: 60,
                                    color: Theme.of(context).primaryColor,
                                    child: new Center(
                                      child: new Icon(
                                        FontAwesomeIcons.dollarSign,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          height: 100,
                        ))),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
                child: Material(
                    elevation: 14.0,
                    borderRadius: BorderRadius.circular(12.0),
                    shadowColor: Color(0x802196F3),
                    child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (context) => new SellerOrdersPage()),
                          );
                        },
                        child: Container(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                            child: new Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text("Last 10 Orders"),
                                new Container(
                                    height: 150.0,
                                    child: charts.LineChart(
                                      lastOrderPriceList,
                                      animationDuration:
                                          new Duration(milliseconds: 1000),
                                      animate: true,
                                      // Optionally pass in a [DateTimeFactory] used by the chart. The factory
                                      // should create the same type of [DateTime] as the data provided. If none
                                      // specified, the default creates local date time.
                                      defaultRenderer:
                                          new charts.LineRendererConfig(
                                              includePoints: true),
                                      behaviors: [
                                        new charts.ChartTitle('Order Price (₹)',
                                            titleStyleSpec:
                                                charts.TextStyleSpec(
                                                    fontFamily: "Title",
                                                    fontSize: 10),
                                            behaviorPosition:
                                                charts.BehaviorPosition.start,
                                            titleOutsideJustification: charts
                                                .OutsideJustification
                                                .middleDrawArea),
                                      ], /* new Sparkline(
                                    data: orderTotalPriceList,
                                  ), */
                                    )),
                              ],
                            ),
                          ),
                          height: 200,
                        ))),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
                child: Material(
                    elevation: 14.0,
                    borderRadius: BorderRadius.circular(12.0),
                    shadowColor: Color(0x802196F3),
                    child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (context) => new AllProductsPage()),
                          );
                        },
                        child: Container(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                            child: Row(
                              children: <Widget>[
                                new Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text("Total Products Sold"),
                                    Text(
                                      totalSold.toString(),
                                      style: TextStyle(
                                          fontSize: 40,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                                new Expanded(
                                  child: Container(),
                                ),
                                new ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: new Container(
                                    height: 60,
                                    width: 60,
                                    color: Theme.of(context).primaryColor,
                                    child: new Center(
                                      child: new Icon(
                                        FontAwesomeIcons.diceD6,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          height: 100,
                        ))),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
                child: Material(
                    elevation: 14.0,
                    borderRadius: BorderRadius.circular(12.0),
                    shadowColor: Color(0x802196F3),
                    child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (context) => new SellerOrdersPage()),
                          );
                        },
                        child: Container(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                            child: new Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text("Products Sold by Category"),
                                new Container(
                                    height: 150.0,
                                    child: charts.BarChart(
                                      categoryOrdersList,
                                      animate: true,
                                      vertical: false,
                                    ))
                              ],
                            ),
                          ),
                          height: 200,
                        ))),
              ),
            ],
          ),
        ));
  }
}

/// Sample linear data type.
class OrdersInfo {
  final double orderPrice;
  final int orderDate;

  OrdersInfo(this.orderDate, this.orderPrice);
}

class OrderCategory {
  final int numOfOrders;
  final String categoryName;

  OrderCategory(this.numOfOrders, this.categoryName);
}
