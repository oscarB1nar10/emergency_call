import 'dart:async';

import 'package:emergency_call/domain/interactors/Subscribe.dart';
import 'package:emergency_call/domain/model/SubscriptionModel.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../../../domain/interactors/GetUserId.dart';

class InAppPurchaseBloc {
  final GetUserId _getUserId = GetUserId();
  final Subscribe _subscribe = Subscribe();

  // Define  product IDs
  final Set<String> _productIds = {
    'location_service2',
    'location_service',
    'location-service-base-plan'
  };

  // Define the list of products
  List<ProductDetails> _products = [];

  // Create a StreamController for the list of products
  final _productsStreamController = StreamController<List<ProductDetails>>();

  Stream<List<ProductDetails>> get productsStream =>
      _productsStreamController.stream;

  // Create a StreamController for  purchases
  final _purchaseStreamController = StreamController<List<PurchaseDetails>>();

  Stream<List<PurchaseDetails>> get purchaseStream =>
      _purchaseStreamController.stream;

  InAppPurchaseBloc() {
    // Add listener to purchase updated
    final Stream<List<PurchaseDetails>> purchaseUpdated =
        InAppPurchase.instance.purchaseStream;
    purchaseUpdated.listen((purchaseDetailsList) {
      _purchaseStreamController.sink.add(purchaseDetailsList);
      _listenToPurchaseUpdated(purchaseDetailsList);
    }, onError: (error) {
      // Handle error here
    });

    // Fetch product details
    _queryProductDetails();
  }

  void _queryProductDetails() async {
    final ProductDetailsResponse response =
        await InAppPurchase.instance.queryProductDetails(_productIds);
    if (response.notFoundIDs.isNotEmpty) {
      // Handle the error
    }
    _products = response.productDetails;
    _productsStreamController.sink.add(_products);
  }

  // Listen to purchase updates
  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        // Handle pending state
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          // Handle error state
        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
            purchaseDetails.status == PurchaseStatus.restored) {
          if (purchaseDetails.pendingCompletePurchase) {
            await InAppPurchase.instance.completePurchase(purchaseDetails);
            _subscribeUser();
          }
        }
      }
    });
  }

  Future<void> _subscribeUser() async {
    var userId = await _getUserId.getUserId();
    SubscriptionModel subscriptionModel =
        SubscriptionModel(userId: userId, subscriptionStatus: "premium");

    // Subscribe user
    var token = await _subscribe.subscribe(subscriptionModel);
    print("Token retrived: $token");
  }

  // Trigger purchase
  void buyProduct(ProductDetails productDetails) {
    final PurchaseParam purchaseParam =
        PurchaseParam(productDetails: productDetails);
    InAppPurchase.instance.buyNonConsumable(purchaseParam: purchaseParam);
  }

  // Clean up
  void dispose() {
    _productsStreamController.close();
    _purchaseStreamController.close();
  }
}
