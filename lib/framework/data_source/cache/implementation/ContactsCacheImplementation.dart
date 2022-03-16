import 'dart:developer';

import 'package:emergency_call/domain/model/FavoriteContact.dart';
import 'package:sqflite/sqflite.dart';
import '../abstraction/ContactsCache.dart';
import 'dataBase.dart';

class ContactsCacheImplementation implements ContactsCache {
  final String TABLE_NAME = "favorite_contacts";

  @override
  Future<void> addFavoriteContact(FavoriteContact contact) async {
    // Get a reference to the database.
    final db = await DatabaseHelper.instance.database;

    // Insert the FavoriteContact into the correct table. You might also specify the
    int idLastInsertedRow = await db.insert(
      TABLE_NAME,
      contact.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    log('idLastInsertedRow: $idLastInsertedRow');
  }

  @override
  Future<List<FavoriteContact>> getFavoriteContacts() async {
    final db = await DatabaseHelper.instance.database;

    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps = await db.query(TABLE_NAME);

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
  Future<void> deleteFavoriteContact(int id) async {
    final db = await DatabaseHelper.instance.database;

    // Remove the favorite contact from the database.
    await db.delete(TABLE_NAME,
        // Use a `where` clause to delete a specific favorite contact.
        where: 'id = ?',
        // Pass the Dog's id as a whereArg to prevent SQL injection.
        whereArgs: [id]);
  }
}
