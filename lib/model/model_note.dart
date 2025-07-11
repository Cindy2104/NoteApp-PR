import 'package:flutter/material.dart';
import 'dart:convert';

class Note {
  final int? id;
  final String title;
  final String content;
  final List<ChecklistItem>? checklist;

  Note({
    this.id,
    required this.title,
    required this.content,
    this.checklist,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'checklist': jsonEncode(checklist?.map((e) => e.toMap()).toList()), // <- encode ke JSON
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      checklist: map['checklist'] != null
          ? (jsonDecode(map['checklist']) as List)
          .map((e) => ChecklistItem.fromMap(e))
          .toList()
          : [],
    );
  }
}

class ChecklistItem {
  String text;
  bool isChecked;

  ChecklistItem({required this.text, this.isChecked = false});

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'isChecked': isChecked,
    };
  }

  factory ChecklistItem.fromMap(Map<String, dynamic> map) {
    return ChecklistItem(
      text: map['text'],
      isChecked: map['isChecked'] ?? false,
    );
  }
}
