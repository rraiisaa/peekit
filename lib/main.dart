import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:peekit_app/bindings/app_bindings.dart';
import 'package:peekit_app/routes/app_pages.dart';
import 'package:peekit_app/utils/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');

  // Load saved theme before running app
  final prefs = await SharedPreferences.getInstance();
  final isDarkMode = prefs.getBool('isDarkMode') ?? false;

  runApp(PeekitApp(isDarkMode: isDarkMode));
}

class PeekitApp extends StatefulWidget {
  final bool isDarkMode;
  const PeekitApp({super.key, required this.isDarkMode});

  @override
  State<PeekitApp> createState() => _PeekitAppState();
}

class _PeekitAppState extends State<PeekitApp> {
  late bool isDarkMode;

  @override
  void initState() {
    super.initState();
    isDarkMode = widget.isDarkMode;
  }

  void toggleTheme() async {
    setState(() => isDarkMode = !isDarkMode);
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkMode', isDarkMode);
  }

  @override
  Widget build(BuildContext context) {
    return ThemeProvider(
      isDarkMode: isDarkMode,
      toggleTheme: toggleTheme,
      child: GetMaterialApp(
        title: 'Peekit',
        theme: ThemeData(
          fontFamily: 'Plus Jakarta Sans',
          brightness: Brightness.light,
          primarySwatch: Colors.blue,
          primaryColor: AppColors.primary,
          scaffoldBackgroundColor: AppColors.background,
          appBarTheme: AppBarTheme(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            elevation: 0,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
          ),
        ),
        darkTheme: ThemeData(
          fontFamily: 'Plus Jakarta Sans',
          brightness: Brightness.dark,
          primaryColor: Colors.white,
          scaffoldBackgroundColor: const Color(0xFF121212),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF1E1E1E),
            foregroundColor: Colors.white,
            elevation: 0,
          ),
          textTheme: const TextTheme(
            // Judul berita / headline utama
            bodyLarge: TextStyle(color: Colors.white),
            bodyMedium: TextStyle(color: Colors.white),
            // Text kecil seperti "a day ago"
            bodySmall: TextStyle(color: Colors.grey),
          ),
          chipTheme: ChipThemeData(
            backgroundColor: const Color(0xFF2A2A2A), // chip default
            selectedColor: Colors.blueAccent, // chip aktif
            labelStyle: const TextStyle(color: Colors.white),
            secondaryLabelStyle: const TextStyle(color: Colors.white),
            brightness: Brightness.dark,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
            ),
          ),
          colorScheme: const ColorScheme.dark(
            primary:
                Colors.blueAccent, // warna utama (misal icon atau highlight)
            secondary: Colors.blueAccent,
            surface: Color(0xFF1E1E1E),
            onSurface: Colors.white,
          ),
        ),

        themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
        initialRoute: AppPages.INITIAL,
        getPages: AppPages.routes,
        initialBinding: AppBindings(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

/// Provider sederhana supaya halaman lain (seperti ProfileScreen) bisa akses toggleTheme
class ThemeProvider extends InheritedWidget {
  final bool isDarkMode;
  final VoidCallback toggleTheme;

  const ThemeProvider({
    required this.isDarkMode,
    required this.toggleTheme,
    required super.child,
    super.key,
  });

  static ThemeProvider of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ThemeProvider>()!;
  }

  @override
  bool updateShouldNotify(ThemeProvider oldWidget) =>
      isDarkMode != oldWidget.isDarkMode;
}
