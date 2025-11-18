import 'package:flutter/material.dart';
import 'package:peekit_app/utils/app_colors.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final bool hasUnreadNotification; // ⬅️ tambah properti ini

  const BottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
    this.hasUnreadNotification = false, // default false
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: Colors.grey,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      items: [
        const BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: ''),
        const BottomNavigationBarItem(icon: Icon(Icons.newspaper), label: ''),
        BottomNavigationBarItem(
          icon: Stack(
            children: [
              const Icon(Icons.notifications),
              if (hasUnreadNotification) ...[
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ]
            ],
          ),
          label: '',
        ),
        const BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
      ],
    );
  }
}
