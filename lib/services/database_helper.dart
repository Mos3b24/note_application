import 'package:flutter/widgets.dart';
import 'package:note_application/Models/note.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  Database? _DB;

  Future <Database> get database async{
    // if the database is already opened return it
    if (_DB != null) return _DB!;
    
    // if the database is not opened, open it
    String path = join (await getDatabasesPath(), 'Nots.DB');
    _DB = await openDatabase(
      path,
      version: 1,
      onCreate: (_DB, version) async{
      await _DB.execute(
        '''CREATE TABLE Notes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        content TEXT)''',
       );
      },
    );
    return _DB!;
  }

  // Insert note to database
  Future <int> insertNote(Note note) async{
    final DB = await database;
    return await DB.insert('Notes', note.toMap());
  }

  // Update specific note in database
  Future <int> UpdateNote(Note note) async{
    final DB = await database;
    return await DB.update(
      'Notes', note.toMap(),
       where : 'id = ?', whereArgs: [note.id]
    );
  }

  // Delete specific note from database
  Future <int>  deleteNote (int id) async{
    final DB = await database;
    return await DB.delete(
      'Notes',
       where: 'id = ?',
       whereArgs: [id]
    );
  }


  // Get all notes from database
  Future <List<Note>> getAllNotes() async{
    final DB = await database;
    final result =  await DB.query('Notes');

    return result.map((e) => Note.fromMap(e)).toList();
    

    return List.generate(result.length, (i) {
      return Note.fromMap(result[i]);
    });
  }
}