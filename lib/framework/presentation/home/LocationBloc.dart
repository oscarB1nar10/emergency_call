import 'package:emergency_call/domain/interactors/GetSubscriptionToken.dart';
import 'package:emergency_call/domain/interactors/GetUserCredentials.dart';
import 'package:emergency_call/domain/interactors/SaveLocation.dart';
import 'package:emergency_call/domain/model/ErrorType.dart';
import 'package:emergency_call/domain/model/SaveLocationResponse.dart';
import 'package:emergency_call/framework/presentation/home/LocationState.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/model/ErrorType.dart';
import 'LocationEvents.dart';

class LocationBloc extends Bloc<LocationEvents, LocationState> {
  LocationBloc() : super(LocationState()) {
    on<EventSaveLocation>(_onSaveLocation);
    on<EventGetUserCredentials>(_onGetUserCredentials);
    on<EventGetSubscriptionToken>(_onGetSubscriptionToken);
    on<EventUpdateDisplaySubsDialog>(_onUpdateDisplaySubsDialog);
  }

  final SaveLocation _saveLocation = SaveLocation();
  final GetUserCredentials _getUserCredentials = GetUserCredentials();
  final GetSubscriptionToken _getSubscriptionToken = GetSubscriptionToken();

  void _onGetUserCredentials(
      EventGetUserCredentials event, Emitter<dynamic> emit) async {
    emit(state.copyWith(isLoading: true));
    UserCredential userCredential =
        await _getUserCredentials.getUserCredentials();
    emit(state.copyWith(userCredentials: userCredential));
  }

  void _onSaveLocation(EventSaveLocation event, Emitter<dynamic> emit) async {
    emit(state.copyWith(isLoading: true));
    SaveLocationResponse saveLocationResponse =
        await _saveLocation.saveLocation(event.location);
    emit(state.copyWith(
        saveLocationResponse: saveLocationResponse,
        displaySubscriptionDialog: saveLocationResponse.errorType
            is UnauthorizedError)); // Display the subs dialog if the location was not saved
  }

  void _onGetSubscriptionToken(EventGetSubscriptionToken subscriptionToken,
      Emitter<dynamic> emit) async {
    emit(state.copyWith(isLoading: true));
    var subscriptionToken = await _getSubscriptionToken.getToken();
    if (subscriptionToken != null && !subscriptionToken.isEmpty) {
      emit(state.copyWith(token: subscriptionToken));
    }
  }

  void _onUpdateDisplaySubsDialog(
      EventUpdateDisplaySubsDialog event, Emitter<LocationState> emit) {
    emit(state.copyWith(displaySubscriptionDialog: false));
  }
}
