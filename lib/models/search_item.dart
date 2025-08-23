import 'package:flutter/material.dart';

class SearchItem {
  final String title;
  final String category;
  final List<String> keywords;
  final IconData icon;
  final Function(BuildContext) onTap;

  SearchItem({
    required this.title,
    required this.category,
    required this.keywords,
    required this.icon,
    required this.onTap,
  });
}
