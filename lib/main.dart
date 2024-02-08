import 'dart:io';

import 'package:emergency_call/framework/presentation/home/dashboard/HomeBloc.dart';
import 'package:emergency_call/framework/presentation/home/subscription/PurchaseWidget.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_intro/flutter_intro.dart';

import 'framework/presentation/home/dashboard/HomeScreenWidget.dart';
import 'framework/presentation/home/subscription/InAppPurchaseBloc.dart';
import 'framework/presentation/home/location/LocationBloc.dart';
import 'framework/presentation/utility/MyHttpOverrides.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
  initFirebaseCrashlytics();
  //startServiceInAndroidPlatform();
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

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<HomeBloc>(
          create: (context) => HomeBloc(),
        ),
        BlocProvider<LocationBloc>(
          create: (context) => LocationBloc(),
        ),
        BlocProvider<InAppPurchaseBloc>(
          create: (context) => InAppPurchaseBloc(),
        )
      ],
      child: Intro(
        padding: const EdgeInsets.all(8),
        borderRadius: const BorderRadius.all(Radius.circular(4)),
        maskColor: const Color.fromRGBO(0, 0, 0, .6),
        buttonTextBuilder: (order) => 'Next',
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.red,
          ),
          initialRoute: '/home',
          routes: {
            '/home': (context) => const HomeScreenWidget(),
            '/subscriptions': (context) => const SubscriptionWidget()
            // Add more routes as needed
          },
        ),
      ),
    );
  }
}

