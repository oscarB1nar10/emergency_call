import 'package:flutter/material.dart';
import 'dart:io';

import 'package:webview_flutter/webview_flutter.dart';

import '../../utility/Strings.dart';

class PrivacyPolicyWebView extends StatefulWidget {
  const PrivacyPolicyWebView({Key? key}) : super(key: key);

  @override
  State<PrivacyPolicyWebView> createState() => _PrivacyPolicyWebViewState();
}

class _PrivacyPolicyWebViewState extends State<PrivacyPolicyWebView> {
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
