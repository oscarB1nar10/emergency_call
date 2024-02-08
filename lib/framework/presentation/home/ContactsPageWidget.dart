import 'dart:typed_data';

import 'package:contacts_service/contacts_service.dart';
import 'package:emergency_call/framework/presentation/utility/Strings.dart';
import 'package:flutter/material.dart';

import '../model/PersonalContact.dart';
import '../utility/CustomTheme.dart';
import 'CustomSearchDelegate.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({Key? key}) : super(key: key);

  @override
  _ContactsPageState createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  Iterable<Contact> _contacts = [Contact()];

  @override
  void initState() {
    getContacts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
        appBar: AppBar(
          title: (const Text(Strings.contacts)),
          actions: [
            IconButton(
              onPressed: () async {
                // method to show the search bar
                var result = await showSearch(
                    context: context,
                    // delegate to customize the search bar
                    delegate: CustomSearchDelegate(_contacts.toList()));
                goBackWithContactSelected(result);
              },
              icon: const Icon(Icons.search),
            )
          ],
        ),
        //Build a list view of all contacts, displaying their avatar and
        // display name
        body: Column(children: [
          Expanded(
              child: ListView.builder(
            itemCount: _contacts.length,
            itemBuilder: (BuildContext context, int index) {
              Contact contact = _contacts.elementAt(index);
              return ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 2, horizontal: 18),
                leading: (contact.avatar != null &&
                        (contact.avatar?.isNotEmpty ?? false))
                    ? CircleAvatar(
                        backgroundImage:
                            MemoryImage(contact.avatar ?? Uint8List(0)),
                      )
                    : CircleAvatar(
                        backgroundColor:
                            Theme.of(context).colorScheme.secondary,
                        child: Text(
                          contact.initials(),
                          style: TextStyle(color: theme.colorScheme.onSecondary),
                        ),
                      ),
                title: Text(
                  contact.displayName ?? '',
                  style: theme.textTheme.bodyLarge, // using the highlight color,
                ),
                onTap: () {
                  goBackWithContactSelected(contact);
                },
                //This can be further expanded to showing contacts detail
                // onPressed().
              );
            },
          )),
        ]));
  }

  Future<void> getContacts() async {
    //Make sure we already have permissions for contacts when we get to this
    //page, so we can just retrieve it
    final Iterable<Contact> contacts = await ContactsService.getContacts();
    setState(() {
      _contacts = contacts;
    });
  }

  void goBackWithContactSelected(Contact contact) {
    Navigator.pop(
        context,
        PersonalContact(
            name: contact.displayName ?? '',
            phone: contact.phones?.first.value ?? ''));
  }
}
