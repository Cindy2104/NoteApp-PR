import 'package:flutter/material.dart';
import '../helper/db_helper.dart';
import '../model/model_note.dart';
import 'add_note.dart';
import 'edit_note.dart';

class ListNote extends StatefulWidget {
  const ListNote({Key? key}) : super(key: key);

  @override
  State<ListNote> createState() => _ListNoteState();
}

class _ListNoteState extends State<ListNote> {
  List<Note> _notes = [];
  final dbHelper = DatabaseHelper();

  final List<Color> cardColors = [
    Colors.amber.shade100,
    Colors.cyan.shade100,
    Colors.pink.shade100,
    Colors.green.shade100,
    Colors.deepPurple.shade100,
    Colors.orange.shade100,
  ];

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  void _loadNotes() async {
    final notes = await dbHelper.getNotes();
    setState(() {
      _notes = notes;
    });
  }

  void _deleteNote(int id) async {
    await dbHelper.deleteNote(id);
    _loadNotes();
  }

  void _confirmDelete(int noteId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Delete Note"),
        content: Text("Are you sure you want to delete this note?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.pink.shade100,
            ),
            onPressed: () {
              _deleteNote(noteId);
              Navigator.of(ctx).pop();
            },
            child: Text("Delete"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "My Notes.",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  CircleAvatar(
                    radius: 22,
                    backgroundImage: AssetImage("assets/images/user.jpg"),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search',
                  prefixIcon: Icon(Icons.search),
                  suffixIcon: Icon(Icons.mic),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            Expanded(
              child: _notes.isEmpty
                  ? Center(child: Text("No notes available"))
                  : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _notes.length,
                itemBuilder: (context, index) {
                  final note = _notes[index];
                  final color = cardColors[index % cardColors.length];

                  return Card(
                    color: color,
                    elevation: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      title: Text(note.title,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (note.content.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(note.content),
                            ),
                          if (note.checklist != null && note.checklist!.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: note.checklist!
                                    .map((item) => Row(
                                  children: [
                                    Icon(
                                      item.isChecked
                                          ? Icons.check_box
                                          : Icons.check_box_outline_blank,
                                      size: 18,
                                    ),
                                    SizedBox(width: 8),
                                    Expanded(child: Text(item.text)),
                                  ],
                                ))
                                    .toList(),
                              ),
                            ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.blueGrey),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => EditNote(note: note),
                                ),
                              ).then((_) => _loadNotes());
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.redAccent),
                            onPressed: () => _confirmDelete(note.id!),
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
        backgroundColor: Colors.pink.shade100,
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddNote()),
          ).then((_) => _loadNotes());
        },
      ),
    );
  }
}
