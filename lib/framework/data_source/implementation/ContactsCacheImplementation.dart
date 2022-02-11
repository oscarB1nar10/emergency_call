import 'dart:developer';

import 'package:emergency_call/domain/model/FavoriteContact.dart';
import 'package:emergency_call/framework/data_source/abstraction/ContactsCache.dart';
import 'package:emergency_call/framework/data_source/implementation/dataBase.dart';
import 'package:sqflite/sqflite.dart';

class ContactsCacheImplementation implements ContactsCache {
  @override
  Future<void> addFavoriteContact(FavoriteContact contact) async {
    // Get a reference to the database.
    final db = await DatabaseHelper.instance.database;

    // Insert the FavoriteContact into the correct table. You might also specify the
    int idLastInsertedRow =  await db.insert(
      'favorite_contacts',
      contact.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    log('idLastInsertedRow: $idLastInsertedRow');
  }

  @override
  Future<List<FavoriteContact>> getFavoriteContacts() async {
    final db = await DatabaseHelper.instance.database;

    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps = await db.query('favorite_contacts');

    // Convert the List<Map<String, dynamic> into a List<FavoriteContact>.
    return List.generate(maps.length, (i) {
      return FavoriteContact(
        id: maps[i]['id'],
        name: maps[i]['name'],
        phone: maps[i]['phone'],
      );
    });
  }

  @override
  Future removeFavoriteContact(int id) {
    // TODO: implement removeFavoriteContact
    throw UnimplementedError();
  }
}
