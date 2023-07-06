import 'package:emergency_call/framework/presentation/home/InAppPurchaseBloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class SubscriptionWidget extends StatefulWidget {
  const SubscriptionWidget({Key? key}) : super(key: key);

  @override
  _SubscriptionWidgetState createState() => _SubscriptionWidgetState();
}

class _SubscriptionWidgetState extends State<SubscriptionWidget> {
  late InAppPurchaseBloc _inAppPurchaseBloc;

  @override
  void initState() {
    super.initState();
    _inAppPurchaseBloc = InAppPurchaseBloc();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Location subscription'),
      ),
      body: StreamBuilder<List<ProductDetails>>(
        stream: _inAppPurchaseBloc.productsStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data?.length,
              itemBuilder: (context, index) {
                var product = snapshot.data?[index];
                if (product != null) {
                  return ListTile(
                    title: Text(product.title),
                    subtitle: Text(product.description),
                    trailing: Text(product.price),
                    onTap: () => _inAppPurchaseBloc.buyProduct(product),
                  );
                }
              },
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _inAppPurchaseBloc.dispose();
    super.dispose();
  }
}
