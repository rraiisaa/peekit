import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:peekit_app/controllers/news_controller.dart';
import 'package:peekit_app/routes/app_pages.dart';
import 'package:peekit_app/utils/app_colors.dart';
import 'package:peekit_app/widgets/category_chip.dart';
import 'package:peekit_app/widgets/news_card.dart';
import 'package:peekit_app/widgets/loading_shimmer.dart';
import 'package:peekit_app/widgets/bottom_navbar.dart';
import 'package:timeago/timeago.dart' as timeago;

class NewsScreen extends StatefulWidget {
  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  final NewsController controller = Get.find<NewsController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff9f9f9),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 1, // 1 = News
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushNamed(context, Routes.HOME);
              break;
            case 1:
              break; // udah di News
            case 2:
              Navigator.pushNamed(context, Routes.NOTIFICATION_SCREEN);
              break;
            case 3:
              Navigator.pushNamed(context, Routes.PROFILE_SCREEN);
              break;
          }
        },
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔍 Search bar + filter
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Search bar
                  Expanded(
                    flex: 7,
                    child: Container(
                      height: 45,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: InkWell(
                        onTap: () => Get.toNamed(Routes.SEARCH_SCREEN),
                        borderRadius: BorderRadius.circular(24),
                        child: Row(
                          children: [
                            const SizedBox(width: 16),
                            const Icon(Icons.search, color: Colors.grey),
                            const SizedBox(width: 10),
                            const Expanded(
                              child: Text(
                                'Search News',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Filter icon
                  Container(
                    height: 45,
                    width: 45,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.tune_rounded, color: Colors.grey),
                      onPressed: () => _showFilterBottomSheet(context),
                    ),
                  ),
                ],
              ),
            ),

            // 📰 Category list
            SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: controller.categories.length,
                itemBuilder: (context, index) {
                  final category = controller.categories[index];
                  return Obx(
                    () => CategoryChip(
                      label: category.capitalize ?? category,
                      isSelected: controller.selectedCategory == category,
                      onTap: () => controller.selectCategory(category),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 8),

            // 📰 News List
            Expanded(
              child: Obx(() {
                if (controller.isLoading) return LoadingShimmer();
                if (controller.error.isNotEmpty) return _buildErrorWidget();
                if (controller.articles.isEmpty) return _buildEmptyWidget();

                return RefreshIndicator(
                  onRefresh: controller.refreshNews,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    itemCount: controller.articles.length,
                    itemBuilder: (context, index) {
                      final article = controller.articles[index];
                      return GestureDetector(
                        onTap: () =>
                            Get.toNamed(Routes.NEWS_DETAIL, arguments: article),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // 🖼️ Gambar
                              ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(16),
                                  bottomLeft: Radius.circular(16),
                                ),
                                child: Image.network(
                                  article.urlToImage ?? '',
                                  width: 110,
                                  height: 100,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Container(
                                        width: 110,
                                        height: 100,
                                        color: Colors.grey[200],
                                        child: const Icon(
                                          Icons.image_not_supported,
                                          color: Colors.grey,
                                        ),
                                      ),
                                ),
                              ),

                              // 📄 Teks
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                    12,
                                    8,
                                    8,
                                    8,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        article.title ?? 'No Title',
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        article.description ?? '',
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.black54,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            article.publishedAt != null
                                                ? timeago.format(
                                                    DateTime.parse(
                                                      article.publishedAt!,
                                                    ).toLocal(),
                                                    locale: 'en',
                                                  )
                                                : '',
                                            style: const TextStyle(
                                              fontSize: 11,
                                              color: Colors.grey,
                                            ),
                                          ),

                                          GestureDetector(
                                            onTap: () {
                                              // toggle saved
                                              controller.toggleSave(article);
                                              Get.snackbar(
                                                'Saved',
                                                'News added to your saved list',
                                                snackPosition:
                                                    SnackPosition.BOTTOM,
                                                backgroundColor:
                                                    AppColors.primary,
                                                colorText: Colors.white,
                                                margin: const EdgeInsets.all(
                                                  12,
                                                ),
                                                borderRadius: 12,
                                              );
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.all(6),
                                              decoration: BoxDecoration(
                                                color: AppColors.primary,
                                                shape: BoxShape.circle,
                                              ),
                                              child: const Icon(
                                                Icons.bookmark_outline,
                                                color: Colors.white,
                                                size: 18,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  // ⚠️ Empty & Error Widgets
  Widget _buildEmptyWidget() => const Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.newspaper, size: 64, color: Colors.grey),
        SizedBox(height: 16),
        Text(
          'No News available',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 8),
        Text('Please try again later', style: TextStyle(color: Colors.grey)),
      ],
    ),
  );

  Widget _buildErrorWidget() => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.error_outline, size: 64, color: Colors.redAccent),
        const SizedBox(height: 16),
        const Text(
          'Something went wrong',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Please check your internet connection',
          style: TextStyle(color: Colors.grey),
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: Get.find<NewsController>().refreshNews,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: const Text('Retry'),
        ),
      ],
    ),
  );

  // 📅 Filter bottom sheet
  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final filters = [
          'All',
          'Yesterday',
          '1 Week Ago',
          '1 Month Ago',
          '3 Months Ago',
        ];
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Filter by Time',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              ...filters.map(
                (filter) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(filter, style: const TextStyle(fontSize: 16)),
                  onTap: () {
                    Navigator.of(context).pop();
                    Get.find<NewsController>().filterByTime(filter);

                    Get.snackbar(
                      'Filter Applied',
                      'Showing news from $filter',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: AppColors.primary,
                      colorText: Colors.white,
                      margin: const EdgeInsets.all(12),
                      borderRadius: 12,
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
