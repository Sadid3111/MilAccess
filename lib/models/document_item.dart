// Define a class for individual document items
class DocumentItem {
  final String title;
  final String id;
  String status;
  String category; // 'pending', 'forwarded', 'rejected'
  bool isExpanded;
  String? createdAt;
  String ownerId;
  String url;
  String type;
  String remarks; // New property to control expansion

  DocumentItem({
    required this.title,
    required this.id,
    this.status = 'Forward',
    this.isExpanded = false,
    this.category = '',
    this.createdAt,
    this.url = '',
    this.type = '',
    this.ownerId = '',
    this.remarks = '',
  });
}
