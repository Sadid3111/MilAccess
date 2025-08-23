import 'package:flutter/material.dart';
import '../models/military_contact.dart';
import '../utils/app_theme.dart';
import 'military_avatar.dart';

class GroupAvatar extends StatelessWidget {
  final MilitaryGroup group;
  final double size;
  final bool showOnlineIndicator;

  const GroupAvatar({
    super.key,
    required this.group,
    this.size = 48,
    this.showOnlineIndicator = true,
  });

  @override
  Widget build(BuildContext context) {
    final members = group.members.take(4).toList();
    
    if (members.isEmpty) {
      return _buildEmptyGroupAvatar();
    }
    
    if (members.length == 1) {
      return _buildSingleMemberAvatar(members.first);
    }
    
    return _buildMultiMemberAvatar(members);
  }

  Widget _buildEmptyGroupAvatar() {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppTheme.primaryGreen, AppTheme.lightGreen],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryGreen.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Icon(
        Icons.group,
        color: Colors.white,
        size: size * 0.5,
      ),
    );
  }

  Widget _buildSingleMemberAvatar(MilitaryContact member) {
    return Stack(
      children: [
        MilitaryAvatar(
          contact: member,
          size: size,
        ),
        if (showOnlineIndicator && group.onlineCount > 0)
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: size * 0.25,
              height: size * 0.25,
              decoration: BoxDecoration(
                color: AppTheme.onlineIndicator,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 2,
                ),
              ),
              child: Center(
                child: Text(
                  '${group.onlineCount}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: size * 0.12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildMultiMemberAvatar(List<MilitaryContact> members) {
    return Stack(
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
        ),
        
        // Position member avatars in a grid pattern
        if (members.length >= 2) ...[
          // Top left
          Positioned(
            left: 2,
            top: 2,
            child: MilitaryAvatar(
              contact: members[0],
              size: size * 0.45,
            ),
          ),
          // Top right
          Positioned(
            right: 2,
            top: 2,
            child: MilitaryAvatar(
              contact: members[1],
              size: size * 0.45,
            ),
          ),
        ],
        
        if (members.length >= 3) ...[
          // Bottom left
          Positioned(
            left: 2,
            bottom: 2,
            child: MilitaryAvatar(
              contact: members[2],
              size: size * 0.45,
            ),
          ),
        ],
        
        if (members.length >= 4) ...[
          // Bottom right
          Positioned(
            right: 2,
            bottom: 2,
            child: MilitaryAvatar(
              contact: members[3],
              size: size * 0.45,
            ),
          ),
        ] else if (members.length == 3) ...[
          // Center bottom for 3 members
          Positioned(
            right: 2,
            bottom: 2,
            child: Container(
              width: size * 0.45,
              height: size * 0.45,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppTheme.primaryGreen, AppTheme.lightGreen],
                ),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 1,
                ),
              ),
              child: Icon(
                Icons.add,
                color: Colors.white,
                size: size * 0.2,
              ),
            ),
          ),
        ],
        
        // Online indicator
        if (showOnlineIndicator && group.onlineCount > 0)
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: size * 0.3,
              height: size * 0.3,
              decoration: BoxDecoration(
                color: AppTheme.onlineIndicator,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 2,
                ),
              ),
              child: Center(
                child: Text(
                  '${group.onlineCount}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: size * 0.12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        
        // Operational indicator
        if (group.isOperational)
          Positioned(
            left: 0,
            top: 0,
            child: Container(
              width: size * 0.25,
              height: size * 0.25,
              decoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 2,
                ),
              ),
              child: Icon(
                Icons.security,
                color: Colors.white,
                size: size * 0.12,
              ),
            ),
          ),
      ],
    );
  }
}

// Animated Group Avatar for active states
class AnimatedGroupAvatar extends StatefulWidget {
  final MilitaryGroup group;
  final double size;
  final bool isActive;
  final bool showOnlineIndicator;

  const AnimatedGroupAvatar({
    super.key,
    required this.group,
    this.size = 48,
    this.isActive = false,
    this.showOnlineIndicator = true,
  });

  @override
  State<AnimatedGroupAvatar> createState() => _AnimatedGroupAvatarState();
}

class _AnimatedGroupAvatarState extends State<AnimatedGroupAvatar>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
    
    if (widget.isActive) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(AnimatedGroupAvatar oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (widget.isActive != oldWidget.isActive) {
      if (widget.isActive) {
        _pulseController.repeat(reverse: true);
      } else {
        _pulseController.stop();
        _pulseController.reset();
      }
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: widget.isActive ? _pulseAnimation.value : 1.0,
          child: Container(
            decoration: widget.isActive
                ? BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primaryGreen.withOpacity(0.4),
                        blurRadius: 12,
                        spreadRadius: 2,
                      ),
                    ],
                  )
                : null,
            child: GroupAvatar(
              group: widget.group,
              size: widget.size,
              showOnlineIndicator: widget.showOnlineIndicator,
            ),
          ),
        );
      },
    );
  }
}

// Group Avatar with Member Count
class GroupAvatarWithCount extends StatelessWidget {
  final MilitaryGroup group;
  final double size;
  final bool showMemberCount;
  final bool showOnlineCount;

  const GroupAvatarWithCount({
    super.key,
    required this.group,
    this.size = 48,
    this.showMemberCount = true,
    this.showOnlineCount = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GroupAvatar(
          group: group,
          size: size,
          showOnlineIndicator: showOnlineCount,
        ),
        if (showMemberCount) ...[
          const SizedBox(height: 4),
          Text(
            '${group.members.length} members',
            style: TextStyle(
              fontSize: size * 0.2,
              color: AppTheme.textMuted,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
        if (showOnlineCount && group.onlineCount > 0) ...[
          const SizedBox(height: 2),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: size * 0.15,
                height: size * 0.15,
                decoration: const BoxDecoration(
                  color: AppTheme.onlineIndicator,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                '${group.onlineCount} online',
                style: TextStyle(
                  fontSize: size * 0.18,
                  color: AppTheme.onlineIndicator,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

// Expandable Group Avatar for detailed view
class ExpandableGroupAvatar extends StatefulWidget {
  final MilitaryGroup group;
  final double size;

  const ExpandableGroupAvatar({
    super.key,
    required this.group,
    this.size = 48,
  });

  @override
  State<ExpandableGroupAvatar> createState() => _ExpandableGroupAvatarState();
}

class _ExpandableGroupAvatarState extends State<ExpandableGroupAvatar>
    with TickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _expandController;
  late Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();
    
    _expandController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _expandAnimation = CurvedAnimation(
      parent: _expandController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _expandController.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
    
    if (_isExpanded) {
      _expandController.forward();
    } else {
      _expandController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleExpanded,
      child: AnimatedBuilder(
        animation: _expandAnimation,
        builder: (context, child) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GroupAvatar(
                group: widget.group,
                size: widget.size,
              ),
              SizeTransition(
                sizeFactor: _expandAnimation,
                child: Container(
                  margin: const EdgeInsets.only(top: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.group.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.group.unit,
                        style: TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.people,
                            size: 16,
                            color: AppTheme.textMuted,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${widget.group.members.length}',
                            style: TextStyle(
                              color: AppTheme.textMuted,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: widget.group.onlineCount > 0 
                                  ? AppTheme.onlineIndicator 
                                  : AppTheme.textMuted,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${widget.group.onlineCount}',
                            style: TextStyle(
                              color: AppTheme.textMuted,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

