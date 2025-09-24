import 'package:flutter/material.dart';
import 'package:note_application/Models/note.dart';
import 'package:note_application/services/database_helper.dart';

class NotePage extends StatefulWidget {
  const NotePage({super.key});

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  //--------------------------------variables-------------------------------
  final TitleController = TextEditingController();
  final ContentController = TextEditingController();
  final DBHelper = DatabaseHelper();
  List<Note> notes = [];

  @override
  void initState() {
    super.initState();
    refreshNotes();
  }

  Future<void> refreshNotes() async {
    final data = await DBHelper.getAllNotes();
    setState(() {
      notes = data;
    });
  }

  Future<void> addNote() async {
    final note = Note(
      title: TitleController.text,
      content: ContentController.text,
    );
    await DBHelper.insertNote(note);
    // Clear the text fields after adding the note
    TitleController.clear();
    ContentController.clear();
    refreshNotes();
  }

  Future<void> deleteNote(int id) async {
    await DBHelper.deleteNote(id);
    refreshNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],

      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBar(
          title: const Text(
            'Note Application',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: [
                Shadow(blurRadius: 6, color: Colors.black38, offset: Offset(1, 2)),
              ],
            ),
          ),
          centerTitle: true,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF3366FF), Color(0xFF00CCFF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(20),
              ),
            ),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextField(
                      controller: TitleController,
                      decoration: InputDecoration(
                        labelText: 'Title',
                        prefixIcon: const Icon(Icons.title),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: ContentController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: 'Content',
                        prefixIcon: const Icon(Icons.notes),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: addNote,
                        icon: const Icon(Icons.add, color: Color(0xFFFFFFFF),),
                        label: const Text('Add Note', style: TextStyle(color: Color(0xFFFFFFFF), fontSize: 15),),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'Your Notes',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.blueAccent,
              ),
            ),
            Expanded(
              child: notes.isEmpty
                  ? const Center(
                      child: Text(
                        'No Notes Yet!',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: notes.length,
                      itemBuilder: (context, index) {
                        final note = notes[index];
                        return Card(
                          elevation: 3,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(16),
                            title: Text(
                              note.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 6.0),
                              child: Text(
                                note.content,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => deleteNote(note.id!),
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
