import 'dart:io';

import 'package:emergency_call/framework/presentation/home/HomeBloc.dart';
import 'package:emergency_call/framework/presentation/home/HomeScreenWidget.dart';
import 'package:emergency_call/framework/presentation/home/PurchaseWidget.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'framework/presentation/home/InAppPurchaseBloc.dart';
import 'framework/presentation/home/LocationBloc.dart';
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
    );
  }
}
