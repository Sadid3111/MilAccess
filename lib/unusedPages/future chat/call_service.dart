import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import '../models/military_contact.dart';

enum CallType { voice, video, groupVoice, groupVideo }

enum CallStatus { 
  idle, 
  connecting, 
  ringing, 
  connected, 
  ended, 
  failed, 
  busy,
  declined 
}

class CallData {
  final String id;
  final CallType type;
  final MilitaryContact? contact;
  final MilitaryGroup? group;
  final DateTime startTime;
  final CallStatus status;
  final Duration? duration;
  final bool isMuted;
  final bool isVideoEnabled;
  final bool isSpeakerOn;

  const CallData({
    required this.id,
    required this.type,
    this.contact,
    this.group,
    required this.startTime,
    required this.status,
    this.duration,
    this.isMuted = false,
    this.isVideoEnabled = true,
    this.isSpeakerOn = false,
  });

  CallData copyWith({
    String? id,
    CallType? type,
    MilitaryContact? contact,
    MilitaryGroup? group,
    DateTime? startTime,
    CallStatus? status,
    Duration? duration,
    bool? isMuted,
    bool? isVideoEnabled,
    bool? isSpeakerOn,
  }) {
    return CallData(
      id: id ?? this.id,
      type: type ?? this.type,
      contact: contact ?? this.contact,
      group: group ?? this.group,
      startTime: startTime ?? this.startTime,
      status: status ?? this.status,
      duration: duration ?? this.duration,
      isMuted: isMuted ?? this.isMuted,
      isVideoEnabled: isVideoEnabled ?? this.isVideoEnabled,
      isSpeakerOn: isSpeakerOn ?? this.isSpeakerOn,
    );
  }

  String get displayName {
    if (contact != null) {
      return contact!.fullTitle;
    } else if (group != null) {
      return group!.name;
    }
    return 'Unknown';
  }

  String get callTypeText {
    switch (type) {
      case CallType.voice:
        return 'Voice Call';
      case CallType.video:
        return 'Video Call';
      case CallType.groupVoice:
        return 'Group Voice Call';
      case CallType.groupVideo:
        return 'Group Video Call';
    }
  }

  bool get isGroupCall => type == CallType.groupVoice || type == CallType.groupVideo;
  bool get isVideoCall => type == CallType.video || type == CallType.groupVideo;
}

class CallService extends ChangeNotifier {
  static final CallService _instance = CallService._internal();
  factory CallService() => _instance;
  CallService._internal();

  CallData? _currentCall;
  final List<CallData> _callHistory = [];

  CallData? get currentCall => _currentCall;
  List<CallData> get callHistory => List.unmodifiable(_callHistory);

  // Voice Call Methods
  static Future<void> initiateVoiceCall(MilitaryContact contact) async {
    await _instance._initiateCall(
      type: CallType.voice,
      contact: contact,
    );
  }

  static Future<void> initiateVideoCall(MilitaryContact contact) async {
    await _instance._initiateCall(
      type: CallType.video,
      contact: contact,
    );
  }

  static Future<void> initiateGroupVoiceCall(MilitaryGroup group) async {
    await _instance._initiateCall(
      type: CallType.groupVoice,
      group: group,
    );
  }

  static Future<void> initiateGroupVideoCall(MilitaryGroup group) async {
    await _instance._initiateCall(
      type: CallType.groupVideo,
      group: group,
    );
  }

  Future<void> _initiateCall({
    required CallType type,
    MilitaryContact? contact,
    MilitaryGroup? group,
  }) async {
    if (_currentCall != null) {
      throw Exception('Another call is already in progress');
    }

    final callId = DateTime.now().millisecondsSinceEpoch.toString();
    
    _currentCall = CallData(
      id: callId,
      type: type,
      contact: contact,
      group: group,
      startTime: DateTime.now(),
      status: CallStatus.connecting,
    );

    notifyListeners();

    // Simulate call connection process
    await _simulateCallConnection();
  }

  Future<void> _simulateCallConnection() async {
    if (_currentCall == null) return;

    // Simulate connecting phase
    await Future.delayed(const Duration(seconds: 1));
    
    if (_currentCall != null) {
      _currentCall = _currentCall!.copyWith(status: CallStatus.ringing);
      notifyListeners();
    }

    // Simulate ringing phase
    await Future.delayed(const Duration(seconds: 3));
    
    if (_currentCall != null) {
      // Randomly simulate call outcomes
      final random = DateTime.now().millisecond % 100;
      
      if (random < 70) {
        // 70% chance of successful connection
        _currentCall = _currentCall!.copyWith(status: CallStatus.connected);
        HapticFeedback.lightImpact();
      } else if (random < 85) {
        // 15% chance of busy
        _currentCall = _currentCall!.copyWith(status: CallStatus.busy);
        HapticFeedback.heavyImpact();
      } else {
        // 15% chance of declined/failed
        _currentCall = _currentCall!.copyWith(status: CallStatus.declined);
        HapticFeedback.heavyImpact();
      }
      
      notifyListeners();
    }
  }

  static Future<void> endCall() async {
    await _instance._endCall();
  }

  Future<void> _endCall() async {
    if (_currentCall == null) return;

    final endTime = DateTime.now();
    final duration = endTime.difference(_currentCall!.startTime);

    final endedCall = _currentCall!.copyWith(
      status: CallStatus.ended,
      duration: duration,
    );

    // Add to call history
    _callHistory.insert(0, endedCall);
    
    // Keep only last 50 calls
    if (_callHistory.length > 50) {
      _callHistory.removeRange(50, _callHistory.length);
    }

    _currentCall = null;
    notifyListeners();

    // Haptic feedback
    HapticFeedback.lightImpact();
  }

  static Future<void> toggleMute() async {
    await _instance._toggleMute();
  }

  Future<void> _toggleMute() async {
    if (_currentCall == null) return;

    _currentCall = _currentCall!.copyWith(
      isMuted: !_currentCall!.isMuted,
    );
    
    notifyListeners();
    HapticFeedback.selectionClick();
  }

  static Future<void> toggleVideo() async {
    await _instance._toggleVideo();
  }

  Future<void> _toggleVideo() async {
    if (_currentCall == null || !_currentCall!.isVideoCall) return;

    _currentCall = _currentCall!.copyWith(
      isVideoEnabled: !_currentCall!.isVideoEnabled,
    );
    
    notifyListeners();
    HapticFeedback.selectionClick();
  }

  static Future<void> toggleSpeaker() async {
    await _instance._toggleSpeaker();
  }

  Future<void> _toggleSpeaker() async {
    if (_currentCall == null) return;

    _currentCall = _currentCall!.copyWith(
      isSpeakerOn: !_currentCall!.isSpeakerOn,
    );
    
    notifyListeners();
    HapticFeedback.selectionClick();
  }

  // Call History Methods
  static List<CallData> getCallHistoryForContact(String contactId) {
    return _instance._callHistory
        .where((call) => call.contact?.id == contactId)
        .toList();
  }

  static List<CallData> getCallHistoryForGroup(String groupId) {
    return _instance._callHistory
        .where((call) => call.group?.id == groupId)
        .toList();
  }

  static void clearCallHistory() {
    _instance._callHistory.clear();
    _instance.notifyListeners();
  }

  // Incoming Call Simulation (for future implementation)
  static Future<void> simulateIncomingCall(MilitaryContact contact, {bool isVideo = false}) async {
    if (_instance._currentCall != null) {
      // Reject if already in call
      return;
    }

    final callId = DateTime.now().millisecondsSinceEpoch.toString();
    
    _instance._currentCall = CallData(
      id: callId,
      type: isVideo ? CallType.video : CallType.voice,
      contact: contact,
      startTime: DateTime.now(),
      status: CallStatus.ringing,
    );

    _instance.notifyListeners();
    
    // Auto-decline after 30 seconds if not answered
    Future.delayed(const Duration(seconds: 30), () {
      if (_instance._currentCall?.id == callId && 
          _instance._currentCall?.status == CallStatus.ringing) {
        _instance._currentCall = _instance._currentCall!.copyWith(
          status: CallStatus.declined,
        );
        _instance.notifyListeners();
      }
    });
  }

  static Future<void> acceptIncomingCall() async {
    if (_instance._currentCall?.status != CallStatus.ringing) return;

    _instance._currentCall = _instance._currentCall!.copyWith(
      status: CallStatus.connected,
    );
    
    _instance.notifyListeners();
    HapticFeedback.lightImpact();
  }

  static Future<void> declineIncomingCall() async {
    if (_instance._currentCall?.status != CallStatus.ringing) return;

    _instance._currentCall = _instance._currentCall!.copyWith(
      status: CallStatus.declined,
    );
    
    _instance.notifyListeners();
    HapticFeedback.heavyImpact();
  }

  // Network Quality Simulation
  static String getNetworkQuality() {
    final random = DateTime.now().millisecond % 100;
    if (random < 60) return 'Excellent';
    if (random < 80) return 'Good';
    if (random < 95) return 'Fair';
    return 'Poor';
  }

  // Call Statistics
  static Map<String, dynamic> getCallStatistics() {
    final totalCalls = _instance._callHistory.length;
    final successfulCalls = _instance._callHistory
        .where((call) => call.status == CallStatus.ended)
        .length;
    
    final totalDuration = _instance._callHistory
        .where((call) => call.duration != null)
        .fold<Duration>(
          Duration.zero,
          (total, call) => total + call.duration!,
        );

    final videoCalls = _instance._callHistory
        .where((call) => call.isVideoCall)
        .length;

    final groupCalls = _instance._callHistory
        .where((call) => call.isGroupCall)
        .length;

    return {
      'totalCalls': totalCalls,
      'successfulCalls': successfulCalls,
      'successRate': totalCalls > 0 ? (successfulCalls / totalCalls * 100).round() : 0,
      'totalDuration': totalDuration,
      'averageDuration': successfulCalls > 0 
          ? Duration(milliseconds: totalDuration.inMilliseconds ~/ successfulCalls)
          : Duration.zero,
      'videoCalls': videoCalls,
      'groupCalls': groupCalls,
    };
  }

  // Dispose method
  @override
  void dispose() {
    _currentCall = null;
    super.dispose();
  }
}

// Call Permission Helper
class CallPermissions {
  static Future<bool> requestMicrophonePermission() async {
    // In a real app, this would request actual microphone permission
    // For now, we'll simulate permission granted
    await Future.delayed(const Duration(milliseconds: 500));
    return true;
  }

  static Future<bool> requestCameraPermission() async {
    // In a real app, this would request actual camera permission
    // For now, we'll simulate permission granted
    await Future.delayed(const Duration(milliseconds: 500));
    return true;
  }

  static Future<bool> checkPermissions({required bool needsCamera}) async {
    final micPermission = await requestMicrophonePermission();
    if (!micPermission) return false;

    if (needsCamera) {
      final cameraPermission = await requestCameraPermission();
      if (!cameraPermission) return false;
    }

    return true;
  }
}

// Call Quality Monitor
class CallQualityMonitor {
  static const List<String> _qualityLevels = ['Poor', 'Fair', 'Good', 'Excellent'];
  static int _currentQualityIndex = 3; // Start with Excellent

  static String get currentQuality => _qualityLevels[_currentQualityIndex];

  static void simulateQualityChange() {
    // Simulate network quality fluctuations
    final random = DateTime.now().millisecond % 100;
    
    if (random < 10) {
      // 10% chance to decrease quality
      _currentQualityIndex = (_currentQualityIndex - 1).clamp(0, _qualityLevels.length - 1);
    } else if (random < 20) {
      // 10% chance to increase quality
      _currentQualityIndex = (_currentQualityIndex + 1).clamp(0, _qualityLevels.length - 1);
    }
    // 80% chance to maintain current quality
  }

  static Color getQualityColor() {
    switch (_currentQualityIndex) {
      case 0: return const Color(0xFFE53E3E); // Red - Poor
      case 1: return const Color(0xFFDD6B20); // Orange - Fair
      case 2: return const Color(0xFF38A169); // Green - Good
      case 3: return const Color(0xFF3182CE); // Blue - Excellent
      default: return const Color(0xFF718096); // Gray - Unknown
    }
  }
}

