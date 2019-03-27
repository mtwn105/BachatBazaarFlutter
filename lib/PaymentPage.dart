import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentPage extends StatefulWidget {
  final String url;

  const PaymentPage({Key key, this.url}) : super(key: key);

  @override
  _PaymentPageState createState() => _PaymentPageState(this.url);
}

class _PaymentPageState extends State<PaymentPage> {
  final String url;
  _PaymentPageState(this.url);

 

  @override
  Widget build(BuildContext context) {
  

    return Scaffold(
      appBar: new AppBar(
        title: new Text("Checkout"),
      ),
      body: WebView(
        gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
          Factory<OneSequenceGestureRecognizer>(
            () => TapGestureRecognizer(),
          ),
        ].toSet(),
        initialUrl: url,
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
