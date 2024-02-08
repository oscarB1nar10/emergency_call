import 'dart:ui';

import 'package:flutter/material.dart';


final ThemeData trackingAppTheme = ThemeData(
  // Base colors
  primarySwatch: Colors.blue,
  // Define a ColorScheme for the app
  colorScheme: ColorScheme.fromSwatch(
    primarySwatch: Colors.blue,
    accentColor: Colors.amber, // Here's where `secondary` is effectively used.
  ),
  // Background color
  scaffoldBackgroundColor: Colors.grey[100],

  // AppBar Theme
  appBarTheme: AppBarTheme(
    color: Colors.white,
    elevation: 1,
    iconTheme: IconThemeData(color: Colors.blue[800]),
    titleTextStyle: const TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
    toolbarTextStyle: const TextStyle(color: Colors.black, fontSize: 18),
  ),

  // Text Theme
  textTheme: TextTheme(
    displayLarge: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold, color: Colors.blue[800]),
    titleLarge: const TextStyle(fontSize: 18.0, fontStyle: FontStyle.normal, color: Colors.black),
    bodyMedium: TextStyle(fontSize: 14.0, fontFamily: 'Hind', color: Colors.grey[600]),
  ),

  // Button Theme
  buttonTheme: ButtonThemeData(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
    buttonColor: Colors.blue,
    textTheme: ButtonTextTheme.primary,
  ),

  // Card Theme
  cardTheme: CardTheme(
    color: Colors.white,
    elevation: 2,
    margin: const EdgeInsets.all(10),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
  ),

  // Icon Theme
  iconTheme: IconThemeData(
    color: Colors.blue[600],
  ),

  // Input Decoration Theme (for TextFormFields)
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
    filled: true,
    fillColor: Colors.grey[200],
  ),
);


