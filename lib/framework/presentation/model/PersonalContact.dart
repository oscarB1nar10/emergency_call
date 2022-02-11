import '../../../domain/model/FavoriteContact.dart';

class PersonalContact {
  final String name;
  final String phone;

  const PersonalContact({this.name = '', this.phone = ''});

  FavoriteContact fromPersonalToFavoriteContact() {
    return FavoriteContact(id: 0, name: name, phone: phone);
  }
}
