//  name of the table;
import 'package:flutter/material.dart';

final String tableName = 'notes';

// what are the fields you need or the name of columns
class NoteFields {
  static const String id = '_id';
  static const String isImportant = '_isImportant';
  static const String priorityLevel = '_priorityLevel';
  static const String title = '_title';
  static const String description = '_description';
  static const String time = '_time';
  static final List<String> values = [
    id,
    isImportant,
    priorityLevel,
    title,
    description,
    time
  ];
}

class Note {
  final int? id;
  final bool isImportant;
  final int priorityLevel;
  final String title;
  final String description;
  final DateTime createdTime;

  const Note(
      {this.id,
      required this.isImportant,
      required this.priorityLevel,
      required this.title,
      required this.description,
      required this.createdTime});

  Note copy({
    int? id,
    bool? isImportant,
    int? priorityLevel,
    String? title,
    String? description,
    DateTime? createdTime,
  }) =>
      Note(
          id: id ?? this.id,
          isImportant: isImportant ?? this.isImportant,
          priorityLevel: priorityLevel ?? this.priorityLevel,
          title: title ?? this.title,
          description: description ?? this.description,
          createdTime: createdTime ?? this.createdTime);
  //? Code to Read the value from the JSON data to Fields
  static Note fromJson(Map<String, Object?> json) => Note(
        id: json[NoteFields.id] as int?,
        isImportant: json[NoteFields.isImportant] == 1,
        priorityLevel: json[NoteFields.priorityLevel] as int,
        title: json[NoteFields.title] as String,
        description: json[NoteFields.description] as String,
        createdTime: DateTime.parse(json[NoteFields.time] as String),
      );
//? Code to Write Values from the Fields to JSON
  Map<String, Object?> toJson() => {
        NoteFields.id: id,
        NoteFields.isImportant: isImportant ? 1 : 0,
        NoteFields.priorityLevel: priorityLevel,
        NoteFields.title: title,
        NoteFields.description: description,
        NoteFields.time: createdTime.toIso8601String(),
      };
}
