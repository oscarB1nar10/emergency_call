import 'dart:async';

import 'package:emergency_call/framework/presentation/home/InAppPurchaseBloc.dart';
import 'package:emergency_call/framework/presentation/home/PurchaseEvents.dart';
import 'package:emergency_call/framework/presentation/home/PurchaseState.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SubscriptionWidget extends StatefulWidget {
  const SubscriptionWidget({Key? key}) : super(key: key);

  @override
  _SubscriptionWidgetState createState() => _SubscriptionWidgetState();
}

class _SubscriptionWidgetState extends State<SubscriptionWidget> {
  late InAppPurchaseBloc _inAppPurchaseBloc;
  bool isBlocLoading = false;
  String errorMessage = "";
  StreamSubscription<dynamic>? _streamSubscription;

  @override
  void initState() {
    super.initState();
    _inAppPurchaseBloc =
        BlocProvider.of<InAppPurchaseBloc>(context, listen: false);
    _fireEvents();
    _eventListener();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onWillPop, // Handle back button press
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Location subscription'),
          ),
          body: BlocBuilder<InAppPurchaseBloc, PurchaseState>(
            builder: (context, state) {
              if (state.isLoading) {
                return _buildProgressIndicator();
              } else if (state.products.isNotEmpty) {
                return ListView.builder(
                  itemCount: state.products.length,
                  itemBuilder: (context, index) {
                    var product = state.products[index];
                    return ListTile(
                      title: Text(product.title),
                      subtitle: Text(product.description),
                      trailing: Text(product.price),
                      onTap: () => _inAppPurchaseBloc
                          .add(EventBuyProduct(productDetails: product)),
                    );
                  },
                );
              } else if (state.errorMessage.isNotEmpty) {
                return Center(child: Text(state.errorMessage));
              } else {
                return const Center(child: Text("Not data available"));
              }
            },
          ),
        ));
  }

  _fireEvents() {
    _inAppPurchaseBloc.add(const EventGetProducts());
  }

  _eventListener() {
    _streamSubscription?.cancel();
    _streamSubscription = _inAppPurchaseBloc.stateStream.listen((state) {
      if (errorMessage.isNotEmpty) {
        _showRetryDialog(context);
      }

      setState(() {
        isBlocLoading = state.isLoading;
      });
    });
  }

  Widget _buildProgressIndicator() {
    return Container(
      color: Colors.black38, // semi-transparent overlay
      child: const Center(
        child: CircularProgressIndicator(), // progress indicator in the center
      ),
    );
  }

  void _showRetryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Error'),
          content: const Text(
              'An error occurred while subscribing. Would you like to retry?'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: const Text('Retry'),
              onPressed: () {
                // Retry the _subscribeUser method
                _inAppPurchaseBloc.add(const EventSubscribeUser());
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  Future<bool> _onWillPop() async {
    Navigator.pushReplacementNamed(context, '/home');
    return false; // This prevents the page from actually poping
  }

  @override
  void dispose() {
    _inAppPurchaseBloc.dispose();
    super.dispose();
  }
}
