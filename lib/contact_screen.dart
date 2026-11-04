import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflit_crud_app/favorite_screen.dart';
import 'package:sqflite/sqflite.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  int? editingId;
  List<Map<String, dynamic>> contacts = [];

  @override
  initState() {
    super.initState();
    readContacts();
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    phoneNumberController.dispose();
    emailController.dispose();
    addressController.dispose();
  }

  //Open Database
  Future<Database> openMyDatabase() async {
    String folder = await getDatabasesPath();
    String path = join(folder, 'contacts.db');

    return openDatabase(
      path,
      version: 2, // Version 1 থেকে 2 করো

      onCreate: (db, version) async {
        await db.execute('''
        CREATE TABLE contacts(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT,
          phone_number TEXT,
          email TEXT,
          address TEXT,
          is_favorite INTEGER DEFAULT 0
        )
      ''');
      },

      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute(
            'ALTER TABLE contacts ADD COLUMN is_favorite INTEGER DEFAULT 0',
          );
        }
      },
    );
  }

  //Add Contact
  Future<void> addContact() async {
    Database db = await openMyDatabase();
    await db.insert('contacts', {
      'name': nameController.text,
      'phone_number': phoneNumberController.text,
      'email': emailController.text,
      'address': addressController.text,
      'is_favorite': 0,
    });
    clearBoxes();
    readContacts();
  }

  //Read Contact
  Future<void> readContacts() async {
    Database db = await openMyDatabase();

    List<Map<String, dynamic>> rows = await db.query(
      'contacts',
      orderBy: 'is_favorite DESC, name ASC',
    );

    if (!mounted) return;

    setState(() {
      contacts = rows;
    });
  }

  //Update Contact
  Future<void> updateContact() async {
    Database db = await openMyDatabase();
    await db.update(
      'contacts',
      {
        'name': nameController.text,
        'phone_number': phoneNumberController.text,
        'email': emailController.text,
        'address': addressController.text,
        'is_favorite': 0,
      },
      where: 'id =?',
      whereArgs: [editingId],
    );
    clearBoxes();
    readContacts();
  }

  //Delete Contact
  Future<void> deleteContact(int id) async {
    Database db = await openMyDatabase();
    await db.delete('contacts', where: 'id =?', whereArgs: [id]);
    clearBoxes();
    readContacts();
  }

  void startEditing(Map<String, dynamic> contact) {
    setState(() {
      editingId = contact['id'];
      nameController.text = contact['name'];
      phoneNumberController.text = contact['phone_number'];
      emailController.text = contact['email'];
      addressController.text = contact['address'];
    });
  }

  void saveButtonPressed() {
    if (nameController.text.isEmpty ||
        phoneNumberController.text.isEmpty ||
        emailController.text.isEmpty ||
        addressController.text.isEmpty) {
      return;
    }
    if (editingId == null) {
      addContact();
    } else {
      updateContact();
    }
  }

  void clearBoxes() {
    setState(() {
      editingId = null;
      nameController.clear();
      phoneNumberController.clear();
      emailController.clear();
      addressController.clear();
    });
  }

  Future<void> toggleFavorite(int id) async {
    Database db = await openMyDatabase();

    List<Map<String, dynamic>> result = await db.query(
      'contacts',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (result.isNotEmpty) {
      int currentFavorite = result.first['is_favorite'];

      await db.update(
        'contacts',
        {'is_favorite': currentFavorite == 1 ? 0 : 1},
        where: 'id = ?',
        whereArgs: [id],
      );
    }

    await readContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact Management App'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FavoriteScreen(contacts: contacts),
                ),
              );
            },
            icon: const Icon(Icons.favorite),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          spacing: 8.0,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                hintText: 'Enter Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                ),
              ),
            ),
            TextField(
              controller: phoneNumberController,
              decoration: const InputDecoration(
                hintText: 'Enter Phone Number',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                ),
              ),
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                hintText: 'Enter Email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                ),
              ),
            ),
            TextField(
              controller: addressController,
              decoration: const InputDecoration(
                hintText: 'Enter Address',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: saveButtonPressed,
              child: Text(editingId == null ? 'Add Contact' : 'Update Contact'),
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: contacts.length,
                itemBuilder: (context, index) {
                  final contact = contacts[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      tileColor: index % 2 == 0
                          ? Colors.green[100]
                          : Colors.green[200],
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            contact['name'],
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                padding: EdgeInsets.zero,
                                icon: const Icon(Icons.edit),
                                onPressed: () => startEditing(contact),
                              ),
                              IconButton(
                                padding: EdgeInsets.zero,
                                icon: const Icon(Icons.delete),
                                onPressed: () => deleteContact(contact['id']),
                              ),
                              IconButton(
                                padding: EdgeInsets.zero,
                                icon: Icon(
                                  contact['is_favorite'] == 1
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: contact['is_favorite'] == 1
                                      ? Colors.red
                                      : Colors.grey,
                                ),
                                onPressed: () => toggleFavorite(contact['id']),
                              ),
                            ],
                          ),
                        ],
                      ),
                      subtitle: Text(
                        'Phone: ${contact['phone_number']}\nEmail: ${contact['email']}\nAddress: ${contact['address']} ',
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
