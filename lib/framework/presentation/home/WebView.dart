import 'package:flutter/material.dart';
import 'dart:io';

import 'package:webview_flutter/webview_flutter.dart';

import '../utility/Strings.dart';

class WebViewApp extends StatefulWidget {
  const WebViewApp({Key? key}) : super(key: key);

  @override
  State<WebViewApp> createState() => _WebViewAppState();
}

class _WebViewAppState extends State<WebViewApp> {
  late WebViewController _controller;

  // Add from here ...
  @override
  void initState() {
    if (Platform.isAndroid) {
      _controller = WebViewController()
        ..loadRequest(Uri.parse(Strings.privacyPolicyUrl));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms and condictions'),
      ),
      body: WebViewWidget(
        controller: _controller,
      ),
    );
  }
}
