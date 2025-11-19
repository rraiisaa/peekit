import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:peekit_app/controllers/notification_controller.dart';
import 'package:peekit_app/models/news_articles.dart';
import 'package:peekit_app/services/news_services.dart';
import 'package:peekit_app/utils/app_colors.dart';
import 'package:peekit_app/utils/constants.dart';

class NewsController extends GetxController {
  final NewsServices _newsServices = NewsServices();

  // Observable variables
  final _isLoading = false.obs;
  final _articles = <NewsArticles>[].obs;
  final _hotArticles = <NewsArticles>[].obs; // 🔥 untuk berita hot
  final _selectedCategory = 'general'.obs;
  final _error = ''.obs;
  final RxList<NewsArticles> _allArticles =
      <NewsArticles>[].obs; // simpan semua berita asli

  // Getters
  bool get isLoading => _isLoading.value;
  List<NewsArticles> get articles => _articles;
  List<NewsArticles> get hotArticles => _hotArticles;
  String get selectedCategory => _selectedCategory.value;
  String get error => _error.value;
  List<String> get categories => Constants.categories;
  List<NewsArticles> get allArticles => _allArticles;

  // 🔹 Ambil semua berita utama (top-headlines)
  Future<void> fetchTopHeadlines({String? category}) async {
    try {
      _isLoading.value = true;
      _error.value = '';

      final response = await _newsServices.getTopHeadlines(
        category: category ?? _selectedCategory.value,
      );

      _articles.value = response.articles;
      _allArticles.value = response.articles;

      // 🔹 Tambahkan notifikasi kalau ada berita baru (24 jam terakhir)
      final notifController = Get.find<NotificationController>();
      final now = DateTime.now();

      for (final article in response.articles) {
        final date = DateTime.tryParse(article.publishedAt ?? '');
        if (date != null && now.difference(date).inHours <= 24) {
          notifController.addNotification(
            "New ${_selectedCategory.value.capitalizeFirst} News!",
            article.title ?? "There's a new update in your feed.",
          );
        }
      }
    } catch (e) {
      _error.value = e.toString();
      Get.snackbar(
        'Error',
        'Failed to load news: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  // 🔹 Ambil berita "Hot News" — urut dari yang terbaru
  Future<void> fetchHotNews() async {
    try {
      _isLoading.value = true;
      _error.value = '';

      final response = await _newsServices.getTopHeadlines(category: 'general');

      final sorted = response.articles
        ..sort((a, b) {
          final bDate =
              DateTime.tryParse(b.publishedAt?.toString() ?? '') ??
              DateTime.now();
          final aDate =
              DateTime.tryParse(a.publishedAt?.toString() ?? '') ??
              DateTime.now();
          return bDate.compareTo(aDate);
        });

      // ambil 5 berita teratas yang paling baru
      _hotArticles.value = sorted.take(5).toList();
    } catch (e) {
      _error.value = e.toString();
      Get.snackbar(
        'Error',
        'Failed to load hot news: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  // 🔹 Filter berita berdasarkan waktu (kemarin, minggu lalu, bulan lalu)
  Future<void> filterByTime(String filterType) async {
    try {
      final now = DateTime.now();
      DateTime? cutoffDate;

      // Reset to all if user picks "All"
      if (filterType == 'All') {
        _articles.assignAll(_allArticles);
        return;
      }

      if (filterType == 'Yesterday') {
        cutoffDate = now.subtract(const Duration(days: 1));
      } else if (filterType == '1 Week Ago') {
        cutoffDate = now.subtract(const Duration(days: 7));
      } else if (filterType == '1 Month Ago') {
        cutoffDate = now.subtract(const Duration(days: 30));
      } else if (filterType == '3 Months Ago') {
        cutoffDate = now.subtract(const Duration(days: 90));
      }

      // safety: if cutoffDate wasn't set (unknown filter), restore all
      if (cutoffDate == null) {
        _articles.assignAll(_allArticles);
        return;
      }

      // promote to non-null local so closures see non-null DateTime
      final cutoff = cutoffDate;

      final filtered = _allArticles.where((article) {
        final dateStr = article.publishedAt;
        if (dateStr == null || dateStr.isEmpty) return false;

        DateTime? date;
        try {
          date = DateTime.parse(dateStr);
        } catch (_) {
          return false; // can't parse -> skip
        }

        // use non-null 'cutoff' here
        return date.isAfter(cutoff);
      }).toList();

      _articles.value = filtered;

      if (filtered.isEmpty) {
        Get.snackbar(
          'No News Found',
          'No articles available from $filterType.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.primary,
          colorText: Colors.white,
          margin: EdgeInsets.all(12),
          borderRadius: 12,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to filter news: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        margin: EdgeInsets.all(12),
        borderRadius: 12,
      );
    }
  }

  // 🔹 Refresh semua berita
  Future<void> refreshNews() async {
    await fetchTopHeadlines();
    await fetchHotNews();
  }

  // 🔹 Pilih kategori
  void selectCategory(String category) {
    if (_selectedCategory.value != category) {
      _selectedCategory.value = category;
      fetchTopHeadlines(category: category);
      fetchHotNews(); // sekalian update hot news
    }
  }

  // 🔹 Fitur Search
  Future<void> searchNews(String query) async {
    if (query.isEmpty) return;

    try {
      _isLoading.value = true;
      _error.value = '';

      final response = await _newsServices.searchNews(query: query);
      _articles.value = response.articles;
    } catch (e) {
      _error.value = e.toString();
      Get.snackbar(
        'Error',
        'Failed to search news: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  // Save News
  void toggleSave(NewsArticles article) {
    // TODO: nanti bisa diisi fitur simpan/unsave berita
    print('Saved article: ${article.title}');
  }
}
