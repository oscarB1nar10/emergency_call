import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'WebView.dart';

class DrawerListWidget extends StatelessWidget {
  const DrawerListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(top: 32),
              children: [
                ListTile(
                  title: const Text('Privacy Policy'),
                  onTap: () {
                    _navigateToWebView(context);
                  },
                ),
              ],
            ),
          ),
          Container(
            color: Colors.deepOrangeAccent,
            child: Align(
              alignment: FractionalOffset.bottomCenter,
              child: ListTile(
                title: const Text('Logout'),
                onTap: () {
                  _signOut(context);
                },
              ),
            ),
          ),
        ],
      ),
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

void _signOut(BuildContext context) async {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  // Sign out from Google
  await googleSignIn.signOut();
  // Sign out from Firebase
  await FirebaseAuth.instance.signOut();

  // Name of the route for HomeScreenWidget
  Navigator.pushReplacementNamed(context, '/home');
}
