import 'dart:io';

import 'package:emergency_call/framework/presentation/home/HomeBloc.dart';
import 'package:emergency_call/framework/presentation/home/HomeScreenWidget.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'framework/presentation/utility/MyHttpOverrides.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
  initFirebaseCrashlytics();
  startServiceInAndroidPlatform();
}

initFirebaseCrashlytics() async {
  // Initialize Firebase.
  await Firebase.initializeApp();

  //FirebaseCrashlytics.instance.crash();
}

startServiceInAndroidPlatform() async {
  if (Platform.isAndroid) {
    var methodChannel = const MethodChannel("com.emergency_call.messages");
    String data = await methodChannel.invokeMethod("startProximityService");
    print("service data: $data");
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeBloc>(
      create: (context) => HomeBloc(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.red,
        ),
        initialRoute: '/home',
        routes: {
          '/home': (context) => const HomeScreenWidget()
          // Add more routes as needed
        },
      ),
    );
  }
}
