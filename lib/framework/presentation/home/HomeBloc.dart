import 'package:emergency_call/domain/interactors/AddFavoriteContact.dart';
import 'package:emergency_call/domain/interactors/GetFavoriteContacts.dart';
import 'package:emergency_call/domain/interactors/GetImei.dart';
import 'package:emergency_call/domain/interactors/RemoveFavoriteContact.dart';
import 'package:emergency_call/domain/interactors/SaveImei.dart';
import 'package:emergency_call/domain/interactors/SaveLocation.dart';
import 'package:emergency_call/domain/interactors/SaveUserPhone.dart';
import 'package:emergency_call/domain/model/FavoriteContact.dart';
import 'package:emergency_call/framework/presentation/home/HomeEvents.dart';
import 'package:emergency_call/framework/presentation/home/HomeState.dart';
import 'package:emergency_call/framework/presentation/utility/Countries.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/interactors/GetCountry.dart';
import '../../../domain/interactors/SaveCountry.dart';

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

  void _onAddFavoriteContact(
      EventAddFavoriteContact event, Emitter<dynamic> emit) {
    _addFavoriteContact.addFavoriteContact(event.favoriteContact);
    // Create an empty list of favorite contacts
    List<FavoriteContact> favoriteContact = [event.favoriteContact];
    // Add the existing into the new list.
    favoriteContact.addAll(state.favoriteContacts);
    // Update the state
    HomeState stateUpdated = HomeState(
        favoriteContactsDataSource: state.favoriteContactsDataSource,
        favoriteContacts: favoriteContact,
        country: state.country,
        imei: state.imei);
    emit(stateUpdated);
  }

  void _onGetFavoriteContacts(
      EventGetFavoriteContact event, Emitter<dynamic> emit) async {
    List<FavoriteContact> favoriteContacts =
        await _getFavoriteContacts.getFavoriteContacts();

    HomeState stateUpdated = HomeState(
        favoriteContactsDataSource: favoriteContacts,
        favoriteContacts: state.favoriteContacts,
        country: state.country,
        imei: state.imei);

    emit(stateUpdated);
  }

  void _onDeleteFavoriteContact(
      EventDeleteFavoriteContact event, Emitter<dynamic> emit) async {
    await _deleteFavoriteContact
        .deleteFavoriteContacts(event.favoriteContact.id);

    emit(state);
  }

  void _onSaveCountryDialCode(
      EventSaveCountryDealCode event, Emitter<dynamic> emit) async {
    bool isCountrySaved =
        await _saveCountryDialCode.saveCountryDialCode(event.country);

    if (isCountrySaved) {
      HomeState stateUpdated = HomeState(
          favoriteContactsDataSource: state.favoriteContactsDataSource,
          favoriteContacts: state.favoriteContacts,
          country: event.country,
          imei: state.imei);

      emit(stateUpdated);
    } else {
      emit(state);
    }
  }

  void _onGetCountryDialCode(
      EventGetCountryDealCode event, Emitter<dynamic> emit) async {
    Country country = await _getCountryDialCode.getCountryDialCode();

    HomeState stateUpdated = HomeState(
        favoriteContactsDataSource: state.favoriteContactsDataSource,
        favoriteContacts: state.favoriteContacts,
        country: country,
        imei: state.imei);

    emit(stateUpdated);
  }

  void _onGetImei(EventGetImei event, Emitter<dynamic> emit) async {
    String imei = await _getImei.getImei();

    HomeState stateUpdated = HomeState(
        favoriteContactsDataSource: state.favoriteContactsDataSource,
        favoriteContacts: state.favoriteContacts,
        country: state.country,
        imei: imei);

    emit(stateUpdated);
  }

  void _onSaveUserPhone(EventSaveUserPhone event, Emitter<dynamic> emit) async {
    await _saveUserPhone.saveUserPhone(event.userPhone);
  }

  void _onSaveImei(EventSaveImei event, Emitter<dynamic> emit) async {
    await _saveImei.saveImei(event.imei);
  }

  void _onSaveLocation(EventSaveLocation event, Emitter<dynamic> emit) async {
    await _saveLocation.saveLocation(event.location);
  }
}
