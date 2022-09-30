import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static const platform = MethodChannel("razorpay_flutter");
  late Razorpay _razorpay;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton(
                      onPressed:openCheckout,
                      child:const Text("Book Tickets")),
                ])),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  void openCheckout() async {
    var options = {
      //api key
      'key': 'rzp_live_ILgsfZCZoFIKMb',
      'amount': 100,
      'name': 'Abhivyakti Garba',
      'description': 'Dainik Bhasker',
      'retry': {'enabled': true, 'max_count': 1},
      'send_sms_hash': true,
      'prefill': {'contact': '', 'email': ''},
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: e');
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    print('Success Response: $response');
    /*Fluttertoast.showToast(
        msg: "SUCCESS: " + response.paymentId!,
        toastLength: Toast.LENGTH_SHORT); */
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print('Error Response: $response');
    /* Fluttertoast.showToast(
        msg: "ERROR: " + response.code.toString() + " - " + response.message!,
        toastLength: Toast.LENGTH_SHORT); */
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print('External SDK Response: $response');
    /* Fluttertoast.showToast(
        msg: "EXTERNAL_WALLET: " + response.walletName!,
        toastLength: Toast.LENGTH_SHORT); */
  }

  void _handleNetworkFailure(PaymentFailureResponse response) {
    print('Error Response: $response');
    /*Fluttertoast.showToast(
    msg:"NETWORKERROR: " + response.code.toString() + "-" + response.message!,
    toastLength: Toast.LENGTH_SHORT);
     */
  }

  void _handleInvalidOptions(PaymentFailureResponse response) {
    print('Invalid Response: $response');
    /*Fluttertoast.showToast(
    msg:"INVALIDERROR: " + response.code.toString()  + "-" + response.message!,
    toastLength: Toast.LENGTH_SHORT);
     */
  }
}
