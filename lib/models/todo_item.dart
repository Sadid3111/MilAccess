import 'package:flutter/material.dart';

class TodoItem {
  String id;
  String title;
  DateTime dueDate;
  TimeOfDay time;
  String category;
  String type;
  bool isDone;

  TodoItem({
    String? id,
    required this.title,
    required this.dueDate,
    required this.time,
    required this.category,
    required this.type,
    this.isDone = false,
  }) : id = id ?? DateTime.now().toIso8601String();

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'dueDate': dueDate.toIso8601String(),
    'timeHour': time.hour,
    'timeMinute': time.minute,
    'category': category,
    'type': type,
    'isDone': isDone,
  };

  static TodoItem fromJson(Map<String, dynamic> json) => TodoItem(
    id: json['id'],
    title: json['title'],
    dueDate: DateTime.parse(json['dueDate']),
    time: TimeOfDay(hour: json['timeHour'], minute: json['timeMinute']),
    category: json['category'],
    type: json['type'],
    isDone: json['isDone'],
  );
}