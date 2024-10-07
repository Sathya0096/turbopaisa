import 'dart:math';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:dio/dio.dart' as dio;

class WebViewScreen extends StatefulWidget {
  var link;
  WebViewScreen({super.key,required this.link});

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {

  // WebViewController? controller;
  bool loading = true;
  double progress = 0;

  WebViewController? controller;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 100),()async{
      controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setNavigationDelegate(
          NavigationDelegate(
            onProgress: (int progress) {
              // Update loading bar.
            },
            onPageStarted: (String url) {},
            onPageFinished: (String url) {},
            onWebResourceError: (WebResourceError error) {},
            onNavigationRequest: (NavigationRequest request) {
              if (request.url.startsWith('https://www.youtube.com/')) {
                return NavigationDecision.prevent;
              }
              return NavigationDecision.navigate;
            },
          ),
        )
        ..loadRequest(Uri.parse(widget.link,),);
      // ..loadRequest(Uri.parse('https://staging_test.rampwms.com/assets/documents/tempserviceinvoice/AugustPaymentReceipt-2-pGDDWp.pdf',),);
        // ..loadRequest(Uri.parse('https://staging_test.rampwms.com/rumpum/printPaymentReceipt?jobCardId=Mg==&paymentDate=MjAyMy0wOC0xNyAxMzoxMjowNA==&receiptType=Q2FyZA==',),);
      setState(() {
        loading = false;
      });
      // String path = (await getTemporaryDirectory()).path;
      // var response = await dio.Dio().download('https://staging_test.rampwms.com/rumpum/printPaymentReceipt?jobCardId=Mg==&paymentDate=MjAyMy0wOC0xNyAxMzoxMjowNA==&receiptType=Q2FyZA==',path+'.pdf');

    });
  }

  @override
  void dispose() {
    super.dispose();
    controller!.goBack();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(toolbarHeight: 0,),
      body:
      loading == true || controller == null
        ?
      Center(child: CircularProgressIndicator(),)
       : WebViewWidget(controller: controller!),
      // WebViewWidget(controller: controller!),
    );;
  }
}
