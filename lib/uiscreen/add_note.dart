import 'package:flutter/material.dart';
import '../helper/db_helper.dart';
import '../model/model_note.dart';

class AddNote extends StatefulWidget {
  const AddNote({Key? key}) : super(key: key);

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _content = '';
  final dbHelper = DatabaseHelper();

  // Checklist related
  final TextEditingController _checklistController = TextEditingController();
  List<ChecklistItem> _checklistItems = [];

  void _addChecklistItem() {
    if (_checklistController.text.isNotEmpty) {
      setState(() {
        _checklistItems.add(ChecklistItem(text: _checklistController.text));
        _checklistController.clear();
      });
    }
  }

  void _saveNote() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      await dbHelper.insertNote(
        Note(
          title: _title,
          content: _content,
          checklist: _checklistItems,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Note"),
        backgroundColor: Colors.pink.shade100,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'Title'),
                  onSaved: (val) => _title = val!,
                  validator: (val) => val!.isEmpty ? 'Enter a title' : null,
                ),
                SizedBox(height: 16),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Content'),
                  onSaved: (val) => _content = val!,
                  validator: (val) => val!.isEmpty ? 'Enter content' : null,
                  maxLines: 5,
                ),
                SizedBox(height: 20),

                // Checklist input field
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _checklistController,
                        decoration: InputDecoration(labelText: 'Checklist Item'),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.add_circle_outline),
                      onPressed: _addChecklistItem,
                    ),
                  ],
                ),

                // Checklist display
                ..._checklistItems.map((item) {
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Checkbox(
                      value: item.isChecked,
                      onChanged: (val) {
                        setState(() {
                          item.isChecked = val!;
                        });
                      },
                    ),
                    title: Text(item.text),
                  );
                }).toList(),

                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _saveNote,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink.shade100,
                    foregroundColor: Colors.black,
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 3,
                  ),
                  child: Text(
                    'Save',
                    style: TextStyle(fontSize: 16),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
