import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utility/Strings.dart';
import 'webviews/PrivacyPolicyWebView.dart';

class DrawerListWidget extends StatelessWidget {
  const DrawerListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Access a more subtle color from the theme
    final textColor = Colors.grey[800]; // A dark shade of grey

    return Drawer(
      child: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(top: 64),
              children: [
                ListTile(
                  leading: const Icon(Icons.card_membership, color: Colors.red),
                  title: const Text('Subscription'),
                  onTap: () {
                    _navigateToSubscription(context);
                  },
                  textColor: textColor,
                ),
                ListTile(
                  leading: const Icon(Icons.track_changes, color: Colors.red),
                  title: const Text('Web tracking'),
                  onTap: () {
                    _launchInBrowser(Strings.webpageUrl);
                  },
                  textColor: textColor,
                ),
                ListTile(
                  leading: const Icon(Icons.privacy_tip, color: Colors.red),
                  title: const Text('Privacy Policy'),
                  onTap: () {
                    _navigateToPrivacyPolicy(context);
                  },
                  textColor: textColor,
                ),
              ],
            ),
          ),
          Container(
            color: Colors.deepOrangeAccent,
            child: Align(
              alignment: FractionalOffset.bottomCenter,
              child: ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title: const Text('Logout'),
                onTap: () {
                  _signOut(context);
                },
                textColor: textColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _launchInBrowser(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw 'Could not launch $urlString';
    }
  }

  void _navigateToSubscription(BuildContext context) async {
    Navigator.pushNamed(context, '/subscriptions');
  }

  void _navigateToPrivacyPolicy(BuildContext context) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PrivacyPolicyWebView()),
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
}
