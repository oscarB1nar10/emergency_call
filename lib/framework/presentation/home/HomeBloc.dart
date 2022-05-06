import 'package:emergency_call/domain/interactors/AddFavoriteContact.dart';
import 'package:emergency_call/domain/interactors/GetFavoriteContacts.dart';
import 'package:emergency_call/domain/interactors/RemoveFavoriteContact.dart';
import 'package:emergency_call/domain/interactors/SaveLocation.dart';
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
  }

  final AddFavoriteContact _addFavoriteContact = AddFavoriteContact();
  final GetFavoriteContacts _getFavoriteContacts = GetFavoriteContacts();
  final DeleteFavoriteContact _deleteFavoriteContact = DeleteFavoriteContact();
  final SaveCountry _saveCountryDialCode = SaveCountry();
  final GetCountry _getCountryDialCode = GetCountry();
  final SaveLocation _saveLocation = SaveLocation();

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
        country: state.country);
    emit(stateUpdated);
  }

  void _onGetFavoriteContacts(
      EventGetFavoriteContact event, Emitter<dynamic> emit) async {
    List<FavoriteContact> favoriteContacts =
        await _getFavoriteContacts.getFavoriteContacts();

    HomeState stateUpdated = HomeState(
        favoriteContactsDataSource: favoriteContacts,
        favoriteContacts: state.favoriteContacts,
        country: state.country);

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
    await _saveCountryDialCode.saveCountryDialCode(event.country);

    HomeState stateUpdated = HomeState(
        favoriteContactsDataSource: state.favoriteContactsDataSource,
        favoriteContacts: state.favoriteContacts,
        country: event.country);

    emit(stateUpdated);
  }

  void _onGetCountryDialCode(
      EventGetCountryDealCode event, Emitter<dynamic> emit) async {
    Country country = await _getCountryDialCode.getCountryDialCode();

    HomeState stateUpdated = HomeState(
        favoriteContactsDataSource: state.favoriteContactsDataSource,
        favoriteContacts: state.favoriteContacts,
        country: country);

    emit(stateUpdated);
  }

  void _onSaveLocation(EventSaveLocation event, Emitter<dynamic> emit) async {
    print("Location in bloc!: ${event.location}");
    await _saveLocation.saveLocation(event.location);
  }
}
