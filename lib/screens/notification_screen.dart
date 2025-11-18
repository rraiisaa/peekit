import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:peekit_app/controllers/notification_controller.dart';
import 'package:peekit_app/widgets/bottom_navbar.dart';
import 'package:peekit_app/routes/app_pages.dart';
import 'package:peekit_app/utils/app_colors.dart';

class NotificationScreen extends StatefulWidget {
  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final NotificationController controller = Get.find<NotificationController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff9f9f9),
      appBar: AppBar(
        title: Obx(() {
          final selectedCount = controller.notifications
              .where((n) => n.isSelected)
              .length;
          return Text(
            selectedCount > 0 ? "$selectedCount selected" : "Notifications",
            style: const TextStyle(color: Colors.black),
          );
        }),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Obx(() {
          final hasSelected = controller.notifications.any((n) => n.isSelected);
          if (!hasSelected) return const SizedBox();
          return IconButton(
            icon: const Icon(Icons.close, color: Colors.black),
            onPressed: () => controller.clearSelection(),
          );
        }),
        actions: [
          Obx(() {
            final hasSelected = controller.notifications.any(
              (n) => n.isSelected,
            );
            if (!hasSelected) return const SizedBox();
            return IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: () => _showDeleteConfirmDialog(context),
            );
          }),
        ],
      ),

      bottomNavigationBar: BottomNavBar(
        currentIndex: 2,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushNamed(context, Routes.HOME);
              break;
            case 1:
              Navigator.pushNamed(context, Routes.NEWS_SCREEN);
              break;
            case 2:
              break;
            case 3:
              Navigator.pushNamed(context, Routes.PROFILE_SCREEN);
              break;
          }
        },
      ),
      body: Obx(() {
        if (controller.notifications.isEmpty) {
          return const Center(child: Text('No notifications yet'));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: controller.notifications.length,
          itemBuilder: (context, index) {
            final notif = controller.notifications[index];

            return GestureDetector(
              onLongPress: () {
                controller.toggleSelection(notif.id);
              },
              onTap: () {
                if (controller.hasSelected) {
                  controller.toggleSelection(notif.id);
                } else {
                  controller.markAsRead(notif.id);
                  if (notif.newsUrl != null) {
                    Get.toNamed(
                      '/newsDetail',
                      arguments: {'url': notif.newsUrl},
                    );
                  }
                }
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.symmetric(vertical: 6),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: notif.isSelected
                      ? Colors.blue[700]
                      : notif.isRead
                      ? Colors.grey[200]
                      : Colors.blue[50],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      notif.isRead
                          ? Icons.notifications_none
                          : Icons.notifications_active,
                      color: notif.isSelected
                          ? Colors.white
                          : notif.isRead
                          ? Colors.grey
                          : AppColors.primary,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            notif.title,
                            style: TextStyle(
                              color: notif.isSelected
                                  ? Colors.white
                                  : Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            notif.message,
                            style: TextStyle(
                              color: notif.isSelected
                                  ? Colors.white70
                                  : Colors.black54,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "${notif.time.hour}:${notif.time.minute.toString().padLeft(2, '0')}",
                            style: TextStyle(
                              fontSize: 11,
                              color: notif.isSelected
                                  ? Colors.white70
                                  : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }

  void _showDeleteConfirmDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Are you sure want to delete selected notifications?",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[300],
                      foregroundColor: Colors.black,
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Cancel"),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    onPressed: () {
                      controller.deleteSelected();
                      Navigator.pop(context);

                      Get.snackbar(
                        'Deleted',
                        'Selected notifications deleted',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: AppColors.primary,
                        colorText: Colors.white,
                        margin: const EdgeInsets.all(12),
                        borderRadius: 12,
                      );
                    },
                    child: const Text("Yes"),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
