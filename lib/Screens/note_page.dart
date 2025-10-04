import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:note_application/Models/note.dart';
import 'package:note_application/services/database_helper.dart';
import 'package:note_application/Screens/settings_page.dart';


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
  final List<Color> noteColors = [
    const Color(0xFFfaca24),
    const Color(0xFF00b894),
    const Color(0xFF092462),
  ];

  int _selectedIndex = 0;

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
      backgroundColor: const Color(0xFFF152e6a),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBar(
          title: Text(
            'app_title'.tr(),
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: [
                Shadow(
                  blurRadius: 6,
                  color: Colors.black38,
                  offset: Offset(1, 2),
                ),
              ],
            ),
          ),
          backgroundColor: const Color(0xFFF152e6a),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: notes.isEmpty
                  ? Center(
                      child: Text(
                        'no_notes'.tr(),
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    )
                  : GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.9,
                      ),
                      itemCount: notes.length,
                      itemBuilder: (context, index) {
                        final note = notes[index];
                        return Card(
                          elevation: 3,
                          color: noteColors[index % noteColors.length],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  note.title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  note.content,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                  maxLines: 4,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const Spacer(),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: IconButton(
                                    icon: const Icon(Icons.delete,
                                        color: Colors.white),
                                    onPressed: () => deleteNote(note.id!),
                                    tooltip: 'delete'.tr(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
            ),
            builder: (context) {
              return Padding(
                padding: EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 20,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: TitleController,
                      decoration: InputDecoration(
                        labelText: 'title'.tr(),
                        prefixIcon: const Icon(Icons.title),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: ContentController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: 'content'.tr(),
                        prefixIcon: const Icon(Icons.notes),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            TitleController.clear();
                            ContentController.clear();
                            Navigator.pop(context);
                          },
                          child: Text("cancel".tr()),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            addNote();
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                          ),
                          child: Text("add".tr()),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
        backgroundColor: const Color(0xFF0c2b86),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        child: const Icon(Icons.edit_outlined, color: Colors.white),
      ),

      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF092462),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(45),
            topRight: Radius.circular(45),
          ),
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          currentIndex: _selectedIndex,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
            if (index == 3) { // settings tab
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SettingsPage()),
              );
            }
          },

          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.notifications_none_outlined),
              label: "",
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.search_outlined),
              label: "",
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.credit_card),
              label: "",
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.settings_outlined),
              label: ""
              
            ),
          ],
        ),
      ),
    );
  }
}
