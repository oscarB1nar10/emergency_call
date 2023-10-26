import 'dart:async';

import 'package:emergency_call/domain/interactors/Subscribe.dart';
import 'package:emergency_call/domain/model/SubscriptionModel.dart';
import 'package:emergency_call/framework/presentation/home/subscription/PurchaseEvents.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../../../../domain/interactors/GetUserId.dart';
import 'PurchaseState.dart';

class InAppPurchaseBloc extends Bloc<PurchaseEvents, PurchaseState> {
  InAppPurchaseBloc() : super(PurchaseState()) {
    on<EventGetProducts>(_onGetProducts);
    on<EventBuyProduct>(_onBuyProduct);
    on<EventPurchaseUpdated>(_onPurchaseUpdated);
    on<EventSubscribeUser>(_onSubscriberUser);
  }

  final GetUserId _getUserId = GetUserId();
  final Subscribe _subscribe = Subscribe();

  // Define  product IDs
  final Set<String> _productIds = {
    'location_service2',
    // 'location_service',
    // 'location-service-base-plan'
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

  final _stateStreamController = StreamController<PurchaseState>.broadcast();

  Stream<PurchaseState> get stateStream => _stateStreamController.stream;

  _onGetProducts(EventGetProducts event, Emitter<PurchaseState> emit) async {
    emit(state.copyWith(isLoading: true));

    final Stream<List<PurchaseDetails>> purchaseUpdated =
        InAppPurchase.instance.purchaseStream;
    purchaseUpdated.listen((purchaseDetailsList) {
      if (!_purchaseStreamController.isClosed) {
        _purchaseStreamController.sink.add(purchaseDetailsList);
      }
      add(EventPurchaseUpdated(purchaseDetailsList: purchaseDetailsList));
    }, onError: (error) {
      // Handle error here
      emit(state.copyWith(isLoading: false));
    });

    // Fetch product details
    await _queryProductDetails(emit);
  }

  Future<void> _queryProductDetails(Emitter<PurchaseState> emit) async {
    final ProductDetailsResponse response =
        await InAppPurchase.instance.queryProductDetails(_productIds);
    if (response.notFoundIDs.isNotEmpty) {
      // Handle the error
      emit(state.copyWith(isLoading: false));
    }
    _products = response.productDetails;
    if (!_productsStreamController.isClosed) {
      _productsStreamController.sink.add(_products);
      emit(state.copyWith(isLoading: false, products: _products));
    }
  }

  _onPurchaseUpdated(
      EventPurchaseUpdated event, Emitter<PurchaseState> emit) async {
    await _listenToPurchaseUpdated(event.purchaseDetailsList, emit);
  }

  // Listen to purchase updates
  Future<void> _listenToPurchaseUpdated(
      List<PurchaseDetails> purchaseDetailsList,
      Emitter<PurchaseState> emit) async {
    for (PurchaseDetails purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        // Handle pending state
        add(const EventSubscribeUser());
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          // Handle error state
          emit(state.copyWith(isLoading: false));
        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
            purchaseDetails.status == PurchaseStatus.restored) {
          if (purchaseDetails.pendingCompletePurchase) {
            await InAppPurchase.instance.completePurchase(purchaseDetails);
            emit(state.copyWith(isLoading: true));
            add(const EventSubscribeUser());
          }
        }
      }
    }
  }

  _onSubscriberUser(EventSubscribeUser eventSubscribeUser, Emitter<PurchaseState> emit) async {
    try {
      emit(state.copyWith(isLoading: true));
      var userId = await _getUserId.getUserId();
      print("userId: $userId");
      SubscriptionModel subscriptionModel =
      SubscriptionModel(userId: userId, subscriptionStatus: "premium");

      // Emit loading state
      _stateStreamController.sink.add(PurchaseState(isLoading: true));

      // Subscribe user
      var token = await _subscribe.subscribe(subscriptionModel);
      print("Token retrieved: $token");

      // Emit successful state with token
      _stateStreamController.sink
          .add(PurchaseState(token: token, isLoading: false));
      emit(state.copyWith(isLoading: false, token: token));
    } catch (error) {
      // Emit error state
      _stateStreamController.sink
          .add(PurchaseState(errorMessage: error.toString(), isLoading: false));
      emit(state.copyWith(isLoading: false, errorMessage: error.toString()));
    }
  }

  // Trigger purchase
  _onBuyProduct(EventBuyProduct eventBuyProduct, Emitter<PurchaseState> emit) {
    final PurchaseParam purchaseParam =
        PurchaseParam(productDetails: eventBuyProduct.productDetails);
    InAppPurchase.instance.buyNonConsumable(purchaseParam: purchaseParam);
  }

  // Clean up
  void dispose() {
    _productsStreamController.close();
    _purchaseStreamController.close();
  }
}
