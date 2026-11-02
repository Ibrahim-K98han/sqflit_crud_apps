import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class Crud extends StatefulWidget {
  const Crud({super.key});

  @override
  State<Crud> createState() => _CrudState();
}

class _CrudState extends State<Crud> {
  //Open Database
  Future<Database> openDatabase() async {}

  //Add Student
  Future<void> addStudent() async {}
  //Update Student
  Future<void> updateStudent() async {}
  //Delete Student
  Future<void> deleteStudent() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('CRUD Operations')),
      body: const Center(child: Text('CRUD Operations Page')),
    );
  }
}
