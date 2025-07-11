import 'package:flutter/material.dart';
import 'package:note/model/model_note.dart';
import '../helper/db_helper.dart';

class EditNote extends StatefulWidget {
  final Note note;

  const EditNote({Key? key, required this.note}) : super(key: key);

  @override
  State<EditNote> createState() => _EditNoteState();
}

class _EditNoteState extends State<EditNote> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _content;
  final dbHelper = DatabaseHelper();

  late List<ChecklistItem> _checklistItems;
  final TextEditingController _checklistController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _title = widget.note.title;
    _content = widget.note.content;
    _checklistItems = widget.note.checklist ?? [];
  }

  void _addChecklistItem() {
    if (_checklistController.text.isNotEmpty) {
      setState(() {
        _checklistItems.add(ChecklistItem(text: _checklistController.text));
        _checklistController.clear();
      });
    }
  }

  void _updateNote() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Note updatedNote = Note(
        id: widget.note.id,
        title: _title,
        content: _content,
        checklist: _checklistItems,
      );
      await dbHelper.updateNote(updatedNote);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Note"),
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
                  initialValue: _title,
                  decoration: InputDecoration(labelText: 'Title'),
                  onSaved: (val) => _title = val!,
                  validator: (val) => val!.isEmpty ? 'Enter a title' : null,
                ),
                SizedBox(height: 16),
                TextFormField(
                  initialValue: _content,
                  decoration: InputDecoration(labelText: 'Content'),
                  onSaved: (val) => _content = val!,
                  validator: (val) => val!.isEmpty ? 'Enter content' : null,
                  maxLines: 5,
                ),
                SizedBox(height: 20),

                // Checklist input
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

                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: _updateNote,
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
                    'Update',
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
