import 'package:flutter/material.dart';
import 'package:peekit_app/widgets/bottom_navbar.dart';
import 'package:peekit_app/routes/app_pages.dart';
import 'package:peekit_app/utils/app_colors.dart';
import 'package:peekit_app/main.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeProvider.of(context).isDarkMode;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : Colors.grey[100],
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Profile",
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🔹 User Info
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage("assets/images/profile.png"),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Raisa Amanda",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "raisaamanda@gmail.com",
                        style: TextStyle(
                          color: isDark ? Colors.grey[400] : Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// Account
            SectionTitle(title: "Account", isDark: isDark),
            SettingsCard(
              isDark: isDark,
              items: [
                const SettingsItem(icon: Icons.person_outline, title: "Manage Profile"),
                const SettingsItem(icon: Icons.lock_outline, title: "Password & Security"),
                const SettingsItem(
                  icon: Icons.language,
                  title: "Language",
                  trailingText: "English",
                ),
              ],
            ),

            const SizedBox(height: 16),

            /// Preferences
            SectionTitle(title: "Preferences", isDark: isDark),
            SettingsCard(
              isDark: isDark,
              items: [
                const SettingsItem(icon: Icons.info_outline, title: "About Us"),
                const SettingsItem(icon: Icons.brightness_6_outlined, title: "Theme"),
                const SettingsItem(icon: Icons.bookmark_outline, title: "Saved"),
              ],
            ),

            const SizedBox(height: 16),

            /// Support
            SectionTitle(title: "Support", isDark: isDark),
            SettingsCard(
              isDark: isDark,
              items: [
                const SettingsItem(icon: Icons.help_outline, title: "Help Center"),
                const SettingsItem(icon: Icons.call_outlined, title: "Contact Us"),
              ],
            ),

            SizedBox(height: 24),

            /// Delete Account
           /// Delete Account (Card Version)
Container(
  decoration: BoxDecoration(
    color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      if (!isDark)
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 6,
          offset: const Offset(0, 2),
        ),
    ],
  ),
  margin: const EdgeInsets.only(bottom: 24),
  child: TextButton(
    style: TextButton.styleFrom(
      padding: const EdgeInsets.symmetric(vertical: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    onPressed: () {},
    child: const Center(
      child: Text(
        "Delete Account",
        style: TextStyle(
          color: Colors.red,
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
    ),
  ),
),

          ],
        ),
      ),

      bottomNavigationBar: BottomNavBar(
        currentIndex: 3,
        onTap: (index) {
          switch (index) {
            case 0: Navigator.pushNamed(context, Routes.HOME); break;
            case 1: Navigator.pushNamed(context, Routes.NEWS_SCREEN); break;
            case 2: Navigator.pushNamed(context, Routes.NOTIFICATION_SCREEN); break;
            case 3: break;
          }
        },
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;
  final bool isDark;
  const SectionTitle({super.key, required this.title, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 4),
      child: Text(
        title,
        style: TextStyle(
          color: isDark ? Colors.grey[400] : Colors.black54,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class SettingsCard extends StatelessWidget {
  final List<SettingsItem> items;
  final bool isDark;
  const SettingsCard({super.key, required this.items, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: items
            .map((item) => Column(
                  children: [
                    ListTile(
                      leading: Icon(item.icon,
                          color: isDark ? Colors.white : Colors.black87),
                      title: Text(
                        item.title,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                      trailing: _buildTrailing(context, item),
                      onTap: item.onTap,
                    ),
                    if (item != items.last)
                      Divider(
                        height: 1,
                        color: isDark ? Colors.grey[800] : Colors.grey.shade200,
                      ),
                  ],
                ))
            .toList(),
      ),
    );
  }

  Widget? _buildTrailing(BuildContext context, SettingsItem item) {
    if (item.title == "Theme") {
      final provider = ThemeProvider.of(context);
      return ObxSwitch(
        isDark: provider.isDarkMode,
        onChanged: (val) => provider.toggleTheme(),
      );
    }

    if (item.trailingText != null) {
      return Text(
        item.trailingText!,
        style: TextStyle(color: isDark ? Colors.grey[300] : Colors.grey),
      );
    }

    return Icon(
      Icons.arrow_forward_ios,
      size: 16,
      color: isDark ? Colors.grey[300] : Colors.black54,
    );
  }
}

class ObxSwitch extends StatefulWidget {
  final bool isDark;
  final ValueChanged<bool> onChanged;
  const ObxSwitch({super.key, required this.isDark, required this.onChanged});

  @override
  State<ObxSwitch> createState() => _ObxSwitchState();
}

class _ObxSwitchState extends State<ObxSwitch> {
  @override
  Widget build(BuildContext context) {
    return Switch(
      value: widget.isDark,
      activeColor: AppColors.primary,
      onChanged: (v) {
        widget.onChanged(v);
        setState(() {});
      },
    );
  }
}

class SettingsItem {
  final IconData icon;
  final String title;
  final String? trailingText;
  final VoidCallback? onTap;

  const SettingsItem({
    required this.icon,
    required this.title,
    this.trailingText,
    this.onTap,
  });
}
