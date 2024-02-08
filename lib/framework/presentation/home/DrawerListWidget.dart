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
    // Use theme colors and text styles
    final theme = Theme.of(context);
    final iconColor = theme.iconTheme.color; // Use the icon color from theme
    final textColor =
        theme.textTheme.bodyLarge?.color; // Use the text color from theme

    return Drawer(
      child: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(top: 64),
              children: [
                ListTile(
                  leading: Icon(Icons.card_membership, color: iconColor),
                  title:
                      Text('Subscription', style: TextStyle(color: textColor)),
                  onTap: () {
                    _navigateToSubscription(context);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.track_changes, color: iconColor),
                  title:
                      Text('Web tracking', style: TextStyle(color: textColor)),
                  onTap: () {
                    _launchInBrowser(Strings.webpageUrl);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.privacy_tip, color: iconColor),
                  title: Text('Privacy Policy',
                      style: TextStyle(color: textColor)),
                  onTap: () {
                    _navigateToPrivacyPolicy(context);
                  },
                ),
              ],
            ),
          ),
          Container(
            color: theme.colorScheme.secondary, // Use a color from the theme
            child: Align(
              alignment: FractionalOffset.bottomCenter,
              child: ListTile(
                leading: Icon(Icons.logout, color: iconColor),
                title: Text('Logout', style: TextStyle(color: textColor)),
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
    await Navigator.push(
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
