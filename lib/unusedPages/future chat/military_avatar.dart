import 'package:flutter/material.dart';
import '../models/military_contact.dart';
import '../utils/app_theme.dart';

class MilitaryAvatar extends StatelessWidget {
  final MilitaryContact contact;
  final double size;
  final bool showOnlineIndicator;
  final bool showRankBadge;

  const MilitaryAvatar({
    super.key,
    required this.contact,
    this.size = 40,
    this.showOnlineIndicator = false,
    this.showRankBadge = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Main Avatar
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppTheme.getRankColor(contact.rank),
                AppTheme.getRankColor(contact.rank).withOpacity(0.8),
              ],
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppTheme.getRankColor(contact.rank).withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: Text(
              contact.avatar,
              style: TextStyle(
                color: Colors.white,
                fontSize: size * 0.35,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        
        // Online Indicator
        if (showOnlineIndicator && contact.isOnline)
          Positioned(
            bottom: size * 0.05,
            right: size * 0.05,
            child: Container(
              width: size * 0.25,
              height: size * 0.25,
              decoration: BoxDecoration(
                color: AppTheme.onlineIndicator,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: size * 0.04,
                ),
              ),
            ),
          ),
        
        // Rank Badge
        if (showRankBadge)
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: size * 0.1,
                vertical: size * 0.05,
              ),
              decoration: BoxDecoration(
                color: AppTheme.getRankColor(contact.rank),
                borderRadius: BorderRadius.circular(size * 0.1),
                border: Border.all(color: Colors.white, width: 1),
              ),
              child: Text(
                contact.rank,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: size * 0.15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

// Group Avatar for multiple participants
class GroupMilitaryAvatar extends StatelessWidget {
  final List<MilitaryContact> contacts;
  final double size;
  final int maxVisible;

  const GroupMilitaryAvatar({
    super.key,
    required this.contacts,
    this.size = 45,
    this.maxVisible = 3,
  });

  @override
  Widget build(BuildContext context) {
    final visibleContacts = contacts.take(maxVisible).toList();
    final remainingCount = contacts.length - maxVisible;
    
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        children: [
          // Background circle
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppTheme.primaryGreen, AppTheme.lightGreen],
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
          ),
          
          // Stacked avatars
          ...visibleContacts.asMap().entries.map((entry) {
            final index = entry.key;
            final contact = entry.value;
            final avatarSize = size * 0.6;
            
            return Positioned(
              top: _getAvatarPosition(index, visibleContacts.length).dy * size,
              left: _getAvatarPosition(index, visibleContacts.length).dx * size,
              child: Container(
                width: avatarSize,
                height: avatarSize,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.getRankColor(contact.rank),
                      AppTheme.getRankColor(contact.rank).withOpacity(0.8),
                    ],
                  ),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: Center(
                  child: Text(
                    contact.avatar.substring(0, 1),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: avatarSize * 0.4,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
          
          // Remaining count indicator
          if (remainingCount > 0)
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                decoration: BoxDecoration(
                  color: AppTheme.textMuted,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.white, width: 1),
                ),
                child: Text(
                  '+$remainingCount',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: size * 0.2,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Offset _getAvatarPosition(int index, int total) {
    switch (total) {
      case 1:
        return const Offset(0.2, 0.2);
      case 2:
        return index == 0 
            ? const Offset(0.1, 0.1) 
            : const Offset(0.3, 0.3);
      case 3:
      default:
        switch (index) {
          case 0:
            return const Offset(0.2, 0.05);
          case 1:
            return const Offset(0.05, 0.35);
          case 2:
            return const Offset(0.35, 0.35);
          default:
            return const Offset(0.2, 0.2);
        }
    }
  }
}

// Avatar with call capabilities indicator
class CallCapableAvatar extends StatelessWidget {
  final MilitaryContact contact;
  final double size;
  final VoidCallback? onCallTap;
  final VoidCallback? onVideoCallTap;

  const CallCapableAvatar({
    super.key,
    required this.contact,
    this.size = 40,
    this.onCallTap,
    this.onVideoCallTap,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        MilitaryAvatar(
          contact: contact,
          size: size,
          showOnlineIndicator: true,
        ),
        
        // Call capability indicators
        if (contact.hasCallCapability || contact.hasVideoCallCapability)
          Positioned(
            top: 0,
            left: 0,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (contact.hasCallCapability)
                  GestureDetector(
                    onTap: onCallTap,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryGreen,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 1),
                      ),
                      child: Icon(
                        Icons.call,
                        size: size * 0.2,
                        color: Colors.white,
                      ),
                    ),
                  ),
                
                if (contact.hasVideoCallCapability)
                  GestureDetector(
                    onTap: onVideoCallTap,
                    child: Container(
                      margin: const EdgeInsets.only(left: 2),
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: AppTheme.lightGreen,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 1),
                      ),
                      child: Icon(
                        Icons.videocam,
                        size: size * 0.2,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}