import 'package:emergency_call/domain/interactors/AddFavoriteContact.dart';
import 'package:emergency_call/domain/interactors/GetFavoriteContacts.dart';
import 'package:emergency_call/domain/model/FavoriteContact.dart';
import 'package:emergency_call/framework/presentation/home/HomeEvents.dart';
import 'package:emergency_call/framework/presentation/home/HomeState.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeBloc extends Bloc<HomeEvents, HomeState> {
  HomeBloc() : super(HomeState()) {
    on<EventAddFavoriteContact>(_onAddFavoriteContact);
    on<EventGetFavoriteContact>(_onGetFavoriteContacts);
  }

  final AddFavoriteContact _addFavoriteContact = AddFavoriteContact();
  final GetFavoriteContacts _getFavoriteContacts = GetFavoriteContacts();

  void _onAddFavoriteContact(
      EventAddFavoriteContact event, Emitter<dynamic> emit) {
    _addFavoriteContact.addFavoriteContact(event.favoriteContact);
    // Create an empty list of favorite contacts
    List<FavoriteContact> favoriteContact = [event.favoriteContact];
    // Add the existing into the new list.
    favoriteContact.addAll(this.state.favoriteContacts);
    // Update the state
    HomeState state = HomeState(favoriteContacts: favoriteContact);
    emit(state);
  }

  void _onGetFavoriteContacts(
      EventGetFavoriteContact event, Emitter<dynamic> emit) async {
    List<FavoriteContact> favoriteContacts =
        await _getFavoriteContacts.getFavoriteContacts();
    // Create an empty list of favorite contacts
    List<FavoriteContact> favoriteContactDataSource = favoriteContacts;
    // Add the existing into the new list.
    favoriteContactDataSource.addAll(this.state.favoriteContactsDataSource);
    // Update the state
    HomeState state = HomeState(
        favoriteContactsDataSource: favoriteContactDataSource.toSet().toList());
    emit(state);
  }
}
