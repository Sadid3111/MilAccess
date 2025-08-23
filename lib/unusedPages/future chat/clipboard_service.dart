import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

class ClipboardService {
  static const Duration _feedbackDuration = Duration(seconds: 2);

  /// Copy text to clipboard with optional feedback
  static Future<void> copyToClipboard(
    String text, {
    BuildContext? context,
    String? feedbackMessage,
    bool showFeedback = true,
  }) async {
    try {
      await Clipboard.setData(ClipboardData(text: text));
      
      // Provide haptic feedback
      HapticFeedback.lightImpact();
      
      // Show user feedback if context is provided
      if (showFeedback && context != null) {
        final message = feedbackMessage ?? 'Copied to clipboard';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            duration: _feedbackDuration,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            backgroundColor: Colors.green.shade600,
          ),
        );
      }
    } catch (e) {
      // Handle clipboard access errors
      if (showFeedback && context != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to copy: ${e.toString()}'),
            duration: _feedbackDuration,
            backgroundColor: Colors.red.shade600,
          ),
        );
      }
    }
  }

  /// Paste text from clipboard
  static Future<String?> pasteFromClipboard({
    BuildContext? context,
    bool showFeedback = false,
  }) async {
    try {
      final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
      final text = clipboardData?.text;
      
      if (text != null && text.isNotEmpty) {
        // Provide haptic feedback
        HapticFeedback.selectionClick();
        
        if (showFeedback && context != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Pasted from clipboard'),
              duration: _feedbackDuration,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              backgroundColor: Colors.blue.shade600,
            ),
          );
        }
        
        return text;
      } else {
        if (showFeedback && context != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Clipboard is empty'),
              duration: _feedbackDuration,
              backgroundColor: Colors.orange.shade600,
            ),
          );
        }
        return null;
      }
    } catch (e) {
      // Handle clipboard access errors
      if (showFeedback && context != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to paste: ${e.toString()}'),
            duration: _feedbackDuration,
            backgroundColor: Colors.red.shade600,
          ),
        );
      }
      return null;
    }
  }

  /// Check if clipboard has text content
  static Future<bool> hasClipboardText() async {
    try {
      final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
      return clipboardData?.text?.isNotEmpty ?? false;
    } catch (e) {
      return false;
    }
  }

  /// Get clipboard text without consuming it
  static Future<String?> peekClipboard() async {
    try {
      final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
      return clipboardData?.text;
    } catch (e) {
      return null;
    }
  }

  /// Copy message content with military formatting
  static Future<void> copyMilitaryMessage(
    String content,
    String senderRank,
    String senderName,
    String unit,
    DateTime timestamp, {
    BuildContext? context,
    bool includeMetadata = true,
  }) async {
    String formattedMessage;
    
    if (includeMetadata) {
      final timeStr = _formatMilitaryTime(timestamp);
      formattedMessage = '''
FROM: $senderRank $senderName, $unit
TIME: $timeStr
MSG: $content
''';
    } else {
      formattedMessage = content;
    }

    await copyToClipboard(
      formattedMessage,
      context: context,
      feedbackMessage: 'Military message copied',
    );
  }

  /// Copy contact information
  static Future<void> copyContactInfo(
    String rank,
    String name,
    String unit,
    String designation, {
    BuildContext? context,
  }) async {
    final contactInfo = '''
$rank $name
Unit: $unit
Designation: $designation
''';

    await copyToClipboard(
      contactInfo,
      context: context,
      feedbackMessage: 'Contact info copied',
    );
  }

  /// Copy group information
  static Future<void> copyGroupInfo(
    String groupName,
    String unit,
    List<String> memberNames, {
    BuildContext? context,
  }) async {
    final membersStr = memberNames.join(', ');
    final groupInfo = '''
Group: $groupName
Unit: $unit
Members: $membersStr
''';

    await copyToClipboard(
      groupInfo,
      context: context,
      feedbackMessage: 'Group info copied',
    );
  }

  /// Smart paste that handles different content types
  static Future<String?> smartPaste({
    BuildContext? context,
    bool autoFormat = true,
  }) async {
    final text = await pasteFromClipboard(context: context);
    
    if (text == null || !autoFormat) {
      return text;
    }

    // Auto-format military messages
    if (_isMilitaryMessage(text)) {
      return _formatPastedMilitaryMessage(text);
    }

    // Auto-format coordinates
    if (_isCoordinateText(text)) {
      return _formatCoordinates(text);
    }

    // Auto-format time
    if (_isTimeText(text)) {
      return _formatTime(text);
    }

    return text;
  }

  /// Format military time (24-hour format)
  static String _formatMilitaryTime(DateTime dateTime) {
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final day = dateTime.day.toString().padLeft(2, '0');
    final month = dateTime.month.toString().padLeft(2, '0');
    final year = dateTime.year.toString().substring(2);
    
    return '${hour}${minute}H $day$month$year';
  }

  /// Check if text looks like a military message
  static bool _isMilitaryMessage(String text) {
    final militaryKeywords = [
      'FROM:', 'TO:', 'MSG:', 'TIME:', 'SITREP', 'OPREP', 'INTSUM',
      'ROGER', 'WILCO', 'COPY', 'OVER', 'OUT'
    ];
    
    final upperText = text.toUpperCase();
    return militaryKeywords.any((keyword) => upperText.contains(keyword));
  }

  /// Format pasted military message
  static String _formatPastedMilitaryMessage(String text) {
    // Clean up common formatting issues
    return text
        .replaceAll(RegExp(r'\s+'), ' ') // Multiple spaces to single
        .replaceAll(RegExp(r'\n+'), '\n') // Multiple newlines to single
        .trim();
  }

  /// Check if text contains coordinates
  static bool _isCoordinateText(String text) {
    // Simple regex for coordinate patterns
    final coordPattern = RegExp(r'\d+[°]\s*\d+[\']\s*\d*["]?\s*[NSEW]');
    return coordPattern.hasMatch(text);
  }

  /// Format coordinates
  static String _formatCoordinates(String text) {
    // Basic coordinate formatting
    return text
        .replaceAll(RegExp(r'\s+'), ' ')
        .replaceAll('°', '° ')
        .replaceAll('\'', '\' ')
        .replaceAll('"', '" ')
        .trim();
  }

  /// Check if text contains time information
  static bool _isTimeText(String text) {
    final timePattern = RegExp(r'\d{1,2}:\d{2}|\d{4}H');
    return timePattern.hasMatch(text);
  }

  /// Format time text
  static String _formatTime(String text) {
    // Convert civilian time to military time if needed
    return text.replaceAllMapped(
      RegExp(r'(\d{1,2}):(\d{2})\s*(AM|PM)', caseSensitive: false),
      (match) {
        int hour = int.parse(match.group(1)!);
        final minute = match.group(2)!;
        final period = match.group(3)!.toUpperCase();
        
        if (period == 'PM' && hour != 12) {
          hour += 12;
        } else if (period == 'AM' && hour == 12) {
          hour = 0;
        }
        
        return '${hour.toString().padLeft(2, '0')}${minute}H';
      },
    );
  }

  /// Clear clipboard
  static Future<void> clearClipboard({
    BuildContext? context,
    bool showFeedback = true,
  }) async {
    try {
      await Clipboard.setData(const ClipboardData(text: ''));
      
      if (showFeedback && context != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Clipboard cleared'),
            duration: _feedbackDuration,
            backgroundColor: Colors.grey.shade600,
          ),
        );
      }
    } catch (e) {
      if (showFeedback && context != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to clear clipboard: ${e.toString()}'),
            duration: _feedbackDuration,
            backgroundColor: Colors.red.shade600,
          ),
        );
      }
    }
  }

  /// Copy with custom formatting options
  static Future<void> copyWithFormat(
    String text, {
    BuildContext? context,
    ClipboardFormat format = ClipboardFormat.plain,
    Map<String, String>? metadata,
  }) async {
    String formattedText;
    
    switch (format) {
      case ClipboardFormat.plain:
        formattedText = text;
        break;
      case ClipboardFormat.military:
        formattedText = _formatAsMilitaryMessage(text, metadata);
        break;
      case ClipboardFormat.structured:
        formattedText = _formatAsStructured(text, metadata);
        break;
    }

    await copyToClipboard(formattedText, context: context);
  }

  /// Format text as military message
  static String _formatAsMilitaryMessage(String text, Map<String, String>? metadata) {
    final timestamp = DateTime.now();
    final timeStr = _formatMilitaryTime(timestamp);
    
    return '''
TIME: $timeStr
FROM: ${metadata?['from'] ?? 'UNKNOWN'}
TO: ${metadata?['to'] ?? 'ALL STATIONS'}
MSG: $text
''';
  }

  /// Format text as structured data
  static String _formatAsStructured(String text, Map<String, String>? metadata) {
    final buffer = StringBuffer();
    
    if (metadata != null) {
      for (final entry in metadata.entries) {
        buffer.writeln('${entry.key.toUpperCase()}: ${entry.value}');
      }
      buffer.writeln('---');
    }
    
    buffer.write(text);
    return buffer.toString();
  }
}

/// Clipboard format options
enum ClipboardFormat {
  plain,
  military,
  structured,
}

/// Clipboard history manager (for future implementation)
class ClipboardHistory {
  static final List<ClipboardEntry> _history = [];
  static const int maxHistorySize = 50;

  static List<ClipboardEntry> get history => List.unmodifiable(_history);

  static void addToHistory(String text, {String? source}) {
    final entry = ClipboardEntry(
      text: text,
      timestamp: DateTime.now(),
      source: source,
    );

    _history.insert(0, entry);
    
    // Keep history size manageable
    if (_history.length > maxHistorySize) {
      _history.removeRange(maxHistorySize, _history.length);
    }
  }

  static void clearHistory() {
    _history.clear();
  }

  static ClipboardEntry? getFromHistory(int index) {
    if (index >= 0 && index < _history.length) {
      return _history[index];
    }
    return null;
  }
}

/// Clipboard entry for history
class ClipboardEntry {
  final String text;
  final DateTime timestamp;
  final String? source;

  const ClipboardEntry({
    required this.text,
    required this.timestamp,
    this.source,
  });

  String get preview {
    const maxLength = 50;
    if (text.length <= maxLength) {
      return text;
    }
    return '${text.substring(0, maxLength)}...';
  }

  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}

/// Enhanced text field with clipboard integration
class ClipboardTextField extends StatefulWidget {
  final TextEditingController controller;
  final String? hintText;
  final int? maxLines;
  final bool enableClipboardActions;
  final Function(String)? onChanged;
  final VoidCallback? onPaste;

  const ClipboardTextField({
    super.key,
    required this.controller,
    this.hintText,
    this.maxLines = 1,
    this.enableClipboardActions = true,
    this.onChanged,
    this.onPaste,
  });

  @override
  State<ClipboardTextField> createState() => _ClipboardTextFieldState();
}

class _ClipboardTextFieldState extends State<ClipboardTextField> {
  bool _hasClipboardText = false;

  @override
  void initState() {
    super.initState();
    _checkClipboard();
  }

  Future<void> _checkClipboard() async {
    final hasText = await ClipboardService.hasClipboardText();
    if (mounted) {
      setState(() {
        _hasClipboardText = hasText;
      });
    }
  }

  Future<void> _pasteFromClipboard() async {
    final text = await ClipboardService.smartPaste(context: context);
    if (text != null) {
      widget.controller.text += text;
      widget.onChanged?.call(widget.controller.text);
      widget.onPaste?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      onChanged: widget.onChanged,
      maxLines: widget.maxLines,
      decoration: InputDecoration(
        hintText: widget.hintText,
        suffixIcon: widget.enableClipboardActions && _hasClipboardText
            ? IconButton(
                onPressed: _pasteFromClipboard,
                icon: const Icon(Icons.content_paste),
                tooltip: 'Paste',
              )
            : null,
      ),
    );
  }
}

