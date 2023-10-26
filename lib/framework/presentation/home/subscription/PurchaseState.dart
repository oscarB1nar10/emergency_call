import 'package:equatable/equatable.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class PurchaseState extends Equatable {
  final List<ProductDetails> products;
  final String token;
  final String errorMessage;
  final bool isLoading;

  PurchaseState(
      {
        this.products = const [],
        this.token = "",
        this.errorMessage = "",
        this.isLoading = false
      });

  PurchaseState copyWith({
    List<ProductDetails>? products,
    String? token,
    String? errorMessage,
    bool? isLoading,
  }) {
    return PurchaseState(
      products: products ?? this.products,
      token: token ?? this.token,
      errorMessage: errorMessage ?? this.errorMessage,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [products, token, errorMessage, isLoading];
}
