import 'package:emergency_call/domain/interactors/AddFavoriteContact.dart';
import 'package:emergency_call/domain/interactors/GetFavoriteContacts.dart';
import 'package:emergency_call/domain/interactors/GetFirstTimeLogin.dart';
import 'package:emergency_call/domain/interactors/GetImei.dart';
import 'package:emergency_call/domain/interactors/GetSubscriptionToken.dart';
import 'package:emergency_call/domain/interactors/GetUserCredentials.dart';
import 'package:emergency_call/domain/interactors/RemoveFavoriteContact.dart';
import 'package:emergency_call/domain/interactors/SaveFirstTimeLogin.dart';
import 'package:emergency_call/domain/interactors/SaveImei.dart';
import 'package:emergency_call/domain/interactors/SaveLocation.dart';
import 'package:emergency_call/domain/interactors/SaveUserPhone.dart';
import 'package:emergency_call/domain/model/FavoriteContact.dart';
import 'package:emergency_call/framework/presentation/utility/Countries.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:emergency_call/framework/presentation/home/dashboard/HomeEvents.dart';

import '../../../../domain/interactors/GetCountry.dart';
import '../../../../domain/interactors/SaveCountry.dart';
import '../../../../domain/model/UserPhone.dart';
import '../../utility/ErrorMessages.dart';
import 'HomeState.dart';

class HomeBloc extends Bloc<HomeEvents, HomeState> {
  HomeBloc() : super(HomeState()) {
    on<EventAddFavoriteContact>(_onAddFavoriteContact);
    on<EventGetFavoriteContact>(_onGetFavoriteContacts);
    on<EventDeleteFavoriteContact>(_onDeleteFavoriteContact);
    on<EventSaveCountryDealCode>(_onSaveCountryDialCode);
    on<EventGetCountryDealCode>(_onGetCountryDialCode);
    on<EventSaveLocation>(_onSaveLocation);
    on<EventSaveUserPhone>(_onSaveUserPhone);
    on<EventSaveImei>(_onSaveImei);
    on<EventGetImei>(_onGetImei);
    on<EventGetUserCredentials>(_onGetUserCredentials);
    on<EventGetSubscriptionToken>(_onGetSubscriptionToken);
    on<EventShowSnackbarError>(_onShowSnackbarError);
    on<EventUpdateSaveUserPhone>(_onUpdateSaveUserPhone);
    on<EventUpdateShownContactInfo>(_onUpdateShownContactInfo);
    on<EventUpdateShownEmergencyBell>(_onUpdateShownEmergencyBell);
    on<EventSaveFirstTimeLogin>(_onCheckIfFirstTimeLogin);
  }

  final AddFavoriteContact _addFavoriteContact = AddFavoriteContact();
  final GetFavoriteContacts _getFavoriteContacts = GetFavoriteContacts();
  final DeleteFavoriteContact _deleteFavoriteContact = DeleteFavoriteContact();
  final SaveCountry _saveCountryDialCode = SaveCountry();
  final GetCountry _getCountryDialCode = GetCountry();
  final SaveLocation _saveLocation = SaveLocation();
  final SaveUserPhone _saveUserPhone = SaveUserPhone();
  final SaveImei _saveImei = SaveImei();
  final GetImei _getImei = GetImei();
  final GetUserCredentials _getUserCredentials = GetUserCredentials();
  final GetSubscriptionToken _getSubscriptionToken = GetSubscriptionToken();
  final SaveFirstTimeLogin _saveFirstTimeLogin = SaveFirstTimeLogin();
  final GetFirstTimeLogin _getFirstTimeLogin = GetFirstTimeLogin();

  void _onAddFavoriteContact(
      EventAddFavoriteContact event, Emitter<dynamic> emit) {
    emit(state.copyWith(isLoading: true));
    _addFavoriteContact.addFavoriteContact(event.favoriteContact);
    // Create a modifiable copy of the original list
    List<FavoriteContact> favoriteContacts = List.from(state.favoriteContacts);
    // Add the new favorite contact to the modifiable list
    favoriteContacts.add(event.favoriteContact);
    emit(state.copyWith(isLoading: false, favoriteContacts: favoriteContacts));
  }

  void _onGetFavoriteContacts(
      EventGetFavoriteContact event, Emitter<dynamic> emit) async {
    emit(state.copyWith(isLoading: true));
    List<FavoriteContact> favoriteContacts =
        await _getFavoriteContacts.getFavoriteContacts();
    emit(state.copyWith(isLoading: false, favoriteContacts: favoriteContacts));
  }

  void _onDeleteFavoriteContact(
      EventDeleteFavoriteContact event, Emitter<dynamic> emit) async {
    emit(state.copyWith(isLoading: true));
    await _deleteFavoriteContact
        .deleteFavoriteContacts(event.favoriteContact.phone);

    List<FavoriteContact> favoriteContacts = state.favoriteContacts;
    favoriteContacts
        .removeWhere((contact) => contact.phone == event.favoriteContact.phone);
    emit(state.copyWith(isLoading: false));
  }

  void _onSaveCountryDialCode(
      EventSaveCountryDealCode event, Emitter<dynamic> emit) async {
    emit(state.copyWith(isLoading: true));
    await _saveCountryDialCode.saveCountryDialCode(event.country);
    emit(state.copyWith(isLoading: false, country: event.country));
  }

  void _onGetCountryDialCode(
      EventGetCountryDealCode event, Emitter<dynamic> emit) async {
    emit(state.copyWith(isLoading: true));
    Country country = await _getCountryDialCode.getCountryDialCode();
    emit(state.copyWith(isLoading: false, country: country));
  }

  void _onGetImei(EventGetImei event, Emitter<dynamic> emit) async {
    emit(state.copyWith(isLoading: true));
    String imei = await _getImei.getImei();
    emit(state.copyWith(isLoading: false, imei: imei));
  }

  void _onGetUserCredentials(
      EventGetUserCredentials event, Emitter<dynamic> emit) async {
    emit(state.copyWith(isLoading: true));
    UserCredential userCredential =
        await _getUserCredentials.getUserCredentials();

    // Trigger the event to save the user phone
    if (userCredential.credential != null) {
      add(EventSaveUserPhone(UserPhone(
          id: userCredential.user?.uid ?? "",
          imei: state.imei,
          name: "")));
    }
    emit(state.copyWith(isLoading: false, userCredentials: userCredential));
  }

  void _onSaveUserPhone(EventSaveUserPhone event, Emitter<dynamic> emit,
      {int retryCount = 0}) async {
    emit(state.copyWith(isLoading: true));
    var token = await _saveUserPhone.saveUserPhone(event.userPhone);
    print("Token retrived: $token");

    if (token != null) {
      emit(state.copyWith(
          isLoading: false, hasSavedUserPhone: true, errorMessage: ""));
    } else {
      emit(state.copyWith(
          isLoading: false,
          hasSavedUserPhone: false,
          errorMessage: ErrorMessages.savePhoneError));
    }
  }

  void _onSaveImei(EventSaveImei event, Emitter<dynamic> emit) async {
    await _saveImei.saveImei(event.imei);
  }

  void _onSaveLocation(EventSaveLocation event, Emitter<dynamic> emit) async {
    emit(state.copyWith(isLoading: true));
    await _saveLocation.saveLocation(event.location);
    emit(state.copyWith(isLoading: false));
  }

  void _onGetSubscriptionToken(EventGetSubscriptionToken subscriptionToken,
      Emitter<dynamic> emit) async {
    emit(state.copyWith(isLoading: true));
    var subscriptionToken = await _getSubscriptionToken.getToken();
    if (subscriptionToken != null && !subscriptionToken.isEmpty) {
      emit(state.copyWith(isLoading: true, token: subscriptionToken));
    }
  }

  void _onUpdateSaveUserPhone(
      EventUpdateSaveUserPhone event, Emitter<HomeState> emit) {
    emit(state.copyWith(hasSavedUserPhone: true));
  }

  void _onUpdateShownContactInfo(
      EventUpdateShownContactInfo event, Emitter<HomeState> emit) {
    emit(state.copyWith(hasShownContactInfo: true));
  }

  void _onUpdateShownEmergencyBell(
      EventUpdateShownEmergencyBell event, Emitter<HomeState> emit) {
    emit(state.copyWith(hasShownEmergencyBell: true));
  }

  Future<void> _onCheckIfFirstTimeLogin(
      EventSaveFirstTimeLogin event, Emitter<HomeState> emit) async {
    emit(state.copyWith(isLoading: true));
    var isFirstTimeLogin = await _getFirstTimeLogin.getFirstTimeLogin();
    if (isFirstTimeLogin) {
      _saveFirstTimeLogin.saveFirstTimeLogin(false);
      emit(state.copyWith(isLoading: false, isFirstTimeLogin: true));
    } else {
      //_saveFirstTimeLogin.saveFirstTimeLogin(false);
      emit(state.copyWith(isLoading: false, isFirstTimeLogin: false));
    }
  }

  void _onShowSnackbarError(
      EventShowSnackbarError event, Emitter<dynamic> emit) async {
    if (event.errorMessage.isNotEmpty) {
      emit(state.copyWith(errorMessage: event.errorMessage));
    }
  }
}
