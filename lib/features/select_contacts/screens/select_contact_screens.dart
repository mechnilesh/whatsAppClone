import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wpclonemn/common/widgets/error.dart';
import 'package:wpclonemn/features/select_contacts/controller/select_contact_control.dart';

class SelectContactScreen extends ConsumerWidget {
  static const String routeName = '/select-contacts';
  const SelectContactScreen({Key? key}) : super(key: key);

  void selectContact(
      WidgetRef ref, Contact selectedContact, BuildContext context) {
    ref
        .read(selectContactControllerProvider)
        .selectContact(selectedContact, context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select contact'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          )
        ],
      ),
      body: ref.watch(getContactProvider).when(
            data: (contactsList) => ListView.builder(
              itemCount: contactsList.length,
              itemBuilder: (context, index) {
                final contact = contactsList[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: ListTile(
                    onTap: () => selectContact(ref, contact, context),
                    title: Text(
                      contact.displayName,
                    ),
                    leading: contact.photo == null
                        ? CircleAvatar(
                            // backgroundImage: MemoryImage(contact.photo!),
                            backgroundImage: NetworkImage(
                              "http://clipart-library.com/images_k/head-silhouette-png/head-silhouette-png-24.png",
                            ),
                            radius: 20,
                          )
                        : CircleAvatar(
                            backgroundImage: MemoryImage(contact.photo!),
                            radius: 30,
                          ),
                  ),
                );
              },
            ),
            error: (err, trace) => ErrorScreen(
              text: err.toString(),
            ),
            loading: () => Center(
              child: const Text('Loading contacts...'),
            ),
          ),
    );
  }
}
