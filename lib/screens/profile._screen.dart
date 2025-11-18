import 'package:flutter/material.dart';
import 'package:peekit_app/widgets/bottom_navbar.dart';
import 'package:peekit_app/routes/app_pages.dart';
import 'package:peekit_app/utils/app_colors.dart';
import 'package:peekit_app/main.dart'; // akses ThemeProvider

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Profile",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🔹 User Info Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage(
                      "assets/images/profile.png",
                    ), // ganti sesuai asset kamu
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "Raisa Amanda",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "raisaamanda@gmail.com",
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// 🔸 Account Section
            SectionTitle(title: "Account"),
            SettingsCard(
              items: [
                const SettingsItem(
                  icon: Icons.person_outline,
                  title: "Manage Profile",
                ),
                const SettingsItem(
                  icon: Icons.lock_outline,
                  title: "Password & Security",
                ),
                const SettingsItem(
                  icon: Icons.language,
                  title: "Language",
                  trailingText: "English",
                ),
              ],
            ),

            const SizedBox(height: 16),

            /// 🔹 Preferences Section
            SectionTitle(title: "Preferences"),
            SettingsCard(
              items: [
                const SettingsItem(icon: Icons.info_outline, title: "About Us"),
                const SettingsItem(
                  icon: Icons.brightness_6_outlined,
                  title: "Theme", // -> akan otomatis jadi Switch
                ),
                const SettingsItem(icon: Icons.bookmark_outline, title: "Saved"),
              ],
            ),

            const SizedBox(height: 16),

            /// 🧩 Support Section
            SectionTitle(title: "Support"),
            SettingsCard(
              items: [
                const SettingsItem(icon: Icons.help_outline, title: "Help Center"),
                const SettingsItem(icon: Icons.call_outlined, title: "Contact Us"),
              ],
            ),

            const SizedBox(height: 24),

            /// Delete Account Button
            Center(
              child: TextButton(
                onPressed: () {
                  // TODO: handle delete account
                },
                child: const Text(
                  "Delete Account",
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
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
            case 0:
              Navigator.pushNamed(context, Routes.HOME);
              break;
            case 1:
              Navigator.pushNamed(context, Routes.NEWS_SCREEN);
              break;
            case 2:
              Navigator.pushNamed(context, Routes.NOTIFICATION_SCREEN);
              break;
            case 3:
              break;
          }
        },
      ),
    );
  }
}

/// 🔹 Reusable Widgets
class SectionTitle extends StatelessWidget {
  final String title;
  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 4),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.black54,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class SettingsCard extends StatelessWidget {
  final List<SettingsItem> items;
  const SettingsCard({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: items
            .map(
              (item) => Column(
                children: [
                  ListTile(
                    leading: Icon(item.icon, color: Colors.black87),
                    title: Text(
                      item.title,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),

                    // <-- Jika item.title == "Theme", kita tampilkan Switch
                    trailing: _buildTrailing(context, item),

                    onTap: item.onTap,
                  ),
                  if (item != items.last)
                    Divider(height: 1, color: Colors.grey.shade200),
                ],
              ),
            )
            .toList(),
      ),
    );
  }

  Widget? _buildTrailing(BuildContext context, SettingsItem item) {
    // khusus: Theme -> tampilkan Switch yang terhubung ke ThemeProvider
    if (item.title == "Theme") {
      try {
        final provider = ThemeProvider.of(context);
        return ObxSwitch(
          isDark: provider.isDarkMode,
          onChanged: (val) => provider.toggleTheme(),
        );
      } catch (e) {
        // jika ThemeProvider tidak tersedia, fallback ke teks
        return const Text("Light", style: TextStyle(color: Colors.grey));
      }
    }

    if (item.trailingText != null) {
      return Text(
        item.trailingText!,
        style: const TextStyle(color: Colors.grey),
      );
    }

    return const Icon(Icons.arrow_forward_ios, size: 16);
  }
}

/// wrapper kecil agar Switch bisa rebuild dengan mudah
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
      onChanged: (v) {
        widget.onChanged(v);
        setState(() {}); // refresh UI lokal supaya switch langsung berubah
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
