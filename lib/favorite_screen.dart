import 'package:flutter/material.dart';

class FavoriteScreen extends StatelessWidget {
  final List<Map<String, dynamic>> contacts;

  const FavoriteScreen({super.key, required this.contacts});

  @override
  Widget build(BuildContext context) {
    // Filter Favorite Contacts
    final favoriteContacts = contacts
        .where((contact) => contact['is_favorite'] == 1)
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Favorite Contacts')),

      body: favoriteContacts.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border, size: 70, color: Colors.grey),
                  SizedBox(height: 10),
                  Text(
                    'No Favorite Contacts Found!',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: favoriteContacts.length,
              itemBuilder: (context, index) {
                final contact = favoriteContacts[index];

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    tileColor: Colors.green[100],

                    title: Text(
                      contact['name'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),

                    subtitle: Text(
                      'Phone: ${contact['phone_number']}\n'
                      'Email: ${contact['email']}\n'
                      'Address: ${contact['address']}',
                    ),

                    trailing: const Icon(Icons.favorite, color: Colors.red),
                  ),
                );
              },
            ),
    );
  }
}
