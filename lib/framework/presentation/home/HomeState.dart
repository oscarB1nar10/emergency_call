import 'package:emergency_call/domain/model/FavoriteContact.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../utility/Countries.dart';

class HomeState extends Equatable {
  final List<FavoriteContact> favoriteContactsDataSource;
  final List<FavoriteContact> favoriteContacts;
  final Country country;
  final String imei;
  final UserCredential? userCredentials;
  final String token;
  final bool hasSavedUserPhone;
  final bool hasShownContactInfo;
  final bool hasShownEmergencyBell;
  final String errorMessage;
  final bool isLoading;

  HomeState({this.favoriteContactsDataSource = const [],
    this.favoriteContacts = const [],
    this.country = const Country(),
    this.imei = "",
    this.userCredentials,
    this.token = "",
    this.hasSavedUserPhone = false,
    this.hasShownContactInfo = false,
    this.hasShownEmergencyBell = false,
    this.errorMessage = "",
    this.isLoading = false});

  HomeState copyWith({
    List<FavoriteContact>? favoriteContactsDataSource,
    List<FavoriteContact>? favoriteContacts,
    Country? country,
    String? imei,
    UserCredential? userCredentials,
    String? token,
    bool? hasSavedUserPhone,
    bool? hasShownContactInfo,
    bool? hasShownEmergencyBell,
    String? errorMessage,
    bool? isLoading,
  }) {
    return HomeState(
      favoriteContactsDataSource:
      favoriteContactsDataSource ?? this.favoriteContactsDataSource,
      favoriteContacts: favoriteContacts ?? this.favoriteContacts,
      country: country ?? this.country,
      imei: imei ?? this.imei,
      userCredentials: userCredentials ?? this.userCredentials,
      token: token ?? this.token,
      hasSavedUserPhone: hasSavedUserPhone ?? this.hasSavedUserPhone,
      hasShownContactInfo: hasShownContactInfo ?? this.hasShownContactInfo,
      hasShownEmergencyBell: hasShownEmergencyBell ?? this.hasShownEmergencyBell,
      errorMessage: errorMessage ?? this.errorMessage,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props =>
      [
        favoriteContactsDataSource,
        favoriteContacts,
        country,
        imei,
        userCredentials,
        token,
        hasSavedUserPhone,
        hasShownContactInfo,
        hasShownEmergencyBell,
        errorMessage,
        isLoading
      ];
}
