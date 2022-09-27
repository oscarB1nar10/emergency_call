import 'package:flutter/material.dart';

import 'WebView.dart';

class DrawerListWidget extends StatelessWidget {
  const DrawerListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(top: 32),
      children: [
        ListTile(
          title: const Text('Privacy Policy'),
          onTap: () {
            _navigateToWebView(context);
          },
        )
      ],
    );
  }
}

void _navigateToWebView(BuildContext context) async {
  // Navigator.push returns a Future that completes after calling
  // Navigator.pop on the Selection Screen.
  final result = await Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const WebViewApp()),
  );
}
