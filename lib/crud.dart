import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Crud extends StatefulWidget {
  const Crud({super.key});

  @override
  State<Crud> createState() => _CrudState();
}

class _CrudState extends State<Crud> {
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  int? editingId;
  List<Map<String, dynamic>> students = [];
  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    ageController.dispose();
  }

  //Open Database
  Future<Database> openMyDatabase() async {
    String folder = await getDatabasesPath();
    String path = join(folder, 'student.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE students(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT,
          age INTEGER)
        ''');
      },
    );
  }

  //Add Student
  Future<void> addStudent() async {
    Database db = await openMyDatabase();
    await db.insert('students', {
      'name': nameController.text,
      'age': ageController.text,
    });
    clearBoxes();
    readStudent();
  }

  //Read Student
  Future<void> readStudent() async {
    Database db = await openMyDatabase();
    List<Map<String, dynamic>> rows = await db.query('students');
    setState(() {
      students = rows;
    });
  }

  //Update Student
  Future<void> updateStudent() async {
    Database db = await openMyDatabase();
    await db.update(
      'students',
      {'name': nameController.text, 'age': ageController.text},
      where: 'id =?',
      whereArgs: [editingId],
    );
    clearBoxes();
    readStudent();
  }

  //Delete Student
  Future<void> deleteStudent(int id) async {
    Database db = await openMyDatabase();
    await db.delete('students', where: 'id =?', whereArgs: [id]);
    clearBoxes();
    readStudent();
  }

  void startEditing(Map<String, dynamic> student) {}

  void saveButtonPressed() {}

  void clearBoxes() {
    setState(() {
      editingId = null;
      nameController.clear();
      ageController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('CRUD Operations')),
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
              controller: ageController,
              decoration: const InputDecoration(
                hintText: 'Enter Age',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
