class Note {
  String id;
  String title;
  String content;
  DateTime createdAt;
  bool isPinned;
  String category;
  String priority;

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.isPinned,
    required this.category,
    required this.priority,
  });
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'isPinned': isPinned,
      'category': category,
      'priority': priority,
    };
  }
}
