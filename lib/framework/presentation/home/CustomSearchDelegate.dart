import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';

class CustomSearchDelegate extends SearchDelegate {
  List<Contact> contacts = [];

  CustomSearchDelegate(this.contacts);

  // first overwrite to
  // clear the search text
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  // second overwrite to pop out of search menu
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  // third overwrite to show query result
  @override
  Widget buildResults(BuildContext context) {
    List<Contact> matchQuery = [];
    for (var contact in contacts) {
      if (contact.displayName?.toLowerCase().contains(query.toLowerCase()) ??
          false) {
        matchQuery.add(contact);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          title: Text(result.displayName ?? ""),
        );
      },
    );
  }

  // last overwrite to show the
  // querying process at the runtime
  @override
  Widget buildSuggestions(BuildContext context) {
    List<Contact> matchQuery = [];
    for (var contact in contacts) {
      if (contact.displayName?.toLowerCase().contains(query.toLowerCase()) ??
          false) {
        matchQuery.add(contact);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
            title: Text(result.displayName ?? ""),
            focusColor: const Color(0xFFEF9A9A),
            onTap: () {
              close(context, result);
            });
      },
    );
  }
}
