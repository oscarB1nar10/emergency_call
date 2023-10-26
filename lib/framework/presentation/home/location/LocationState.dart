import 'package:emergency_call/domain/model/SaveLocationResponse.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LocationState {
  final UserCredential? userCredentials;
  final String token;
  final SaveLocationResponse? saveLocationResponse;
  final bool displaySubscriptionDialog;
  final bool isLoading;

  LocationState(
      {this.userCredentials,
      this.token = "",
      this.displaySubscriptionDialog = false,
      this.saveLocationResponse,
      this.isLoading = false});

  LocationState copyWith(
      {UserCredential? userCredentials,
      String? token,
      SaveLocationResponse? saveLocationResponse,
      bool? displaySubscriptionDialog,
      bool? isLoading}) {
    return LocationState(
        userCredentials: userCredentials ?? this.userCredentials,
        token: token ?? this.token,
        displaySubscriptionDialog:
            displaySubscriptionDialog ?? this.displaySubscriptionDialog,
        saveLocationResponse: saveLocationResponse ?? this.saveLocationResponse,
        isLoading: isLoading ?? this.isLoading);
  }
}
