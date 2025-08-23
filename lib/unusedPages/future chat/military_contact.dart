class MilitaryContact {
  final String id;
  final String name;
  final String rank;
  final String unit;
  final String designation;
  final String avatar;
  final bool isOnline;
  final DateTime? lastSeen;
  final bool hasCallCapability;
  final bool hasVideoCallCapability;

  const MilitaryContact({
    required this.id,
    required this.name,
    required this.rank,
    required this.unit,
    required this.designation,
    required this.avatar,
    this.isOnline = false,
    this.lastSeen,
    this.hasCallCapability = true,
    this.hasVideoCallCapability = true,
  });

  String get fullTitle => '$rank $name';
  String get displayName => name;
  String get statusText => isOnline ? 'Online' : _getLastSeenText();

  String _getLastSeenText() {
    if (lastSeen == null) return 'Offline';
    
    final now = DateTime.now();
    final difference = now.difference(lastSeen!);
    
    if (difference.inMinutes < 1) {
      return 'Last seen just now';
    } else if (difference.inMinutes < 60) {
      return 'Last seen ${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return 'Last seen ${difference.inHours}h ago';
    } else {
      return 'Last seen ${difference.inDays}d ago';
    }
  }

  // Military hierarchy level for sorting
  int get hierarchyLevel {
    if (rank.contains('CO') || rank.contains('Lt Col')) return 1;
    if (rank.contains('2IC') || rank.contains('Maj')) return 2;
    if (rank.contains('Cpy Comd') || rank.contains('Capt')) return 3;
    if (rank.contains('Lt')) return 4;
    if (rank.contains('Sgt') || rank.contains('WO')) return 5;
    if (rank.contains('Cpl')) return 6;
    return 7; // Other ranks
  }
}

// Sample Military Personnel Data
class MilitaryPersonnel {
  static List<MilitaryContact> getAllPersonnel() {
    return [
      MilitaryContact(
        id: '1',
        name: 'Maruf',
        rank: 'Lt',
        unit: '9 Sig Bn',
        designation: 'Signal Officer',
        avatar: 'LM',
        isOnline: true,
        hasCallCapability: true,
        hasVideoCallCapability: true,
      ),
      MilitaryContact(
        id: '2',
        name: 'Zobaer',
        rank: 'Lt',
        unit: '9 Sig Bn',
        designation: 'Communication Officer',
        avatar: 'LZ',
        isOnline: true,
        lastSeen: DateTime.now().subtract(const Duration(minutes: 5)),
        hasCallCapability: true,
        hasVideoCallCapability: true,
      ),
      MilitaryContact(
        id: '3',
        name: 'Rahman',
        rank: 'CO',
        unit: '9 Sig Bn',
        designation: 'Commanding Officer',
        avatar: 'CO',
        isOnline: false,
        lastSeen: DateTime.now().subtract(const Duration(hours: 2)),
        hasCallCapability: true,
        hasVideoCallCapability: true,
      ),
      MilitaryContact(
        id: '4',
        name: 'Ahmed',
        rank: 'Cpy Comd',
        unit: '109 BSC',
        designation: 'Company Commander',
        avatar: 'CC',
        isOnline: true,
        hasCallCapability: true,
        hasVideoCallCapability: true,
      ),
      MilitaryContact(
        id: '5',
        name: 'Hassan',
        rank: '2IC',
        unit: '9 Sig Bn',
        designation: 'Second in Command',
        avatar: '2IC',
        isOnline: false,
        lastSeen: DateTime.now().subtract(const Duration(minutes: 30)),
        hasCallCapability: true,
        hasVideoCallCapability: true,
      ),
      MilitaryContact(
        id: '6',
        name: 'Khan',
        rank: 'Maj',
        unit: '9 Sig Bn',
        designation: 'Operations Officer',
        avatar: 'MK',
        isOnline: true,
        hasCallCapability: true,
        hasVideoCallCapability: true,
      ),
      MilitaryContact(
        id: '7',
        name: 'Islam',
        rank: 'Capt',
        unit: '109 BSC',
        designation: 'Adjutant',
        avatar: 'CI',
        isOnline: false,
        lastSeen: DateTime.now().subtract(const Duration(hours: 1)),
        hasCallCapability: true,
        hasVideoCallCapability: true,
      ),
      MilitaryContact(
        id: '8',
        name: 'Karim',
        rank: 'WO',
        unit: '9 Sig Bn',
        designation: 'Warrant Officer',
        avatar: 'WK',
        isOnline: true,
        hasCallCapability: true,
        hasVideoCallCapability: false, // Some personnel may have limited video access
      ),
    ];
  }

  static List<MilitaryContact> getOnlinePersonnel() {
    return getAllPersonnel().where((contact) => contact.isOnline).toList();
  }

  static List<MilitaryContact> getByUnit(String unit) {
    return getAllPersonnel().where((contact) => contact.unit == unit).toList();
  }

  static MilitaryContact? getById(String id) {
    try {
      return getAllPersonnel().firstWhere((contact) => contact.id == id);
    } catch (e) {
      return null;
    }
  }

  // Get personnel sorted by military hierarchy
  static List<MilitaryContact> getByHierarchy() {
    final personnel = getAllPersonnel();
    personnel.sort((a, b) => a.hierarchyLevel.compareTo(b.hierarchyLevel));
    return personnel;
  }
}

// Group Chat Models
class MilitaryGroup {
  final String id;
  final String name;
  final String unit;
  final List<String> memberIds;
  final String? description;
  final bool isOperational;
  final bool hasCallCapability;
  final bool hasVideoCallCapability;

  const MilitaryGroup({
    required this.id,
    required this.name,
    required this.unit,
    required this.memberIds,
    this.description,
    this.isOperational = false,
    this.hasCallCapability = true,
    this.hasVideoCallCapability = true,
  });

  List<MilitaryContact> get members {
    return memberIds
        .map((id) => MilitaryPersonnel.getById(id))
        .where((contact) => contact != null)
        .cast<MilitaryContact>()
        .toList();
  }

  int get onlineCount => members.where((m) => m.isOnline).length;
  String get participantCount => '${members.length} participants';
}

class MilitaryGroups {
  static List<MilitaryGroup> getAllGroups() {
    return [
      MilitaryGroup(
        id: 'ops_room',
        name: 'Operations Room',
        unit: '9 Sig Bn',
        memberIds: ['1', '2', '3', '5', '6'],
        description: 'Operational communications and briefings',
        isOperational: true,
        hasCallCapability: true,
        hasVideoCallCapability: true,
      ),
      MilitaryGroup(
        id: 'signal_team',
        name: 'Signal Team',
        unit: '9 Sig Bn',
        memberIds: ['1', '2', '8'],
        description: 'Signal operations and maintenance',
        hasCallCapability: true,
        hasVideoCallCapability: true,
      ),
      MilitaryGroup(
        id: 'command_group',
        name: 'Command Group',
        unit: '9 Sig Bn',
        memberIds: ['3', '4', '5', '6'],
        description: 'Command and control communications',
        isOperational: true,
        hasCallCapability: true,
        hasVideoCallCapability: true,
      ),
      MilitaryGroup(
        id: 'bsc_109',
        name: '109 BSC',
        unit: '109 BSC',
        memberIds: ['4', '7'],
        description: 'Base Support Company communications',
        hasCallCapability: true,
        hasVideoCallCapability: false, // Limited video for some units
      ),
    ];
  }

  static MilitaryGroup? getById(String id) {
    try {
      return getAllGroups().firstWhere((group) => group.id == id);
    } catch (e) {
      return null;
    }
  }
}