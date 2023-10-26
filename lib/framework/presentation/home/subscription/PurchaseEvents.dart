import 'package:equatable/equatable.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

abstract class PurchaseEvents extends Equatable {
  const PurchaseEvents();

  @override
  List<Object> get props => [];
}

class EventGetProducts extends PurchaseEvents {
  const EventGetProducts();
}

class EventBuyProduct extends PurchaseEvents {
  final ProductDetails productDetails;
  const EventBuyProduct({required this.productDetails});
}

// New event to handle purchase updates
class EventPurchaseUpdated extends PurchaseEvents {
  final List<PurchaseDetails> purchaseDetailsList;

  const EventPurchaseUpdated({this.purchaseDetailsList = const []});
}

class EventSubscribeUser extends PurchaseEvents {
  const EventSubscribeUser();
}
