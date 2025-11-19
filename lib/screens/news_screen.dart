import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:peekit_app/controllers/news_controller.dart';
import 'package:peekit_app/routes/app_pages.dart';
import 'package:peekit_app/utils/app_colors.dart';
import 'package:peekit_app/widgets/category_chip.dart';
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
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bgColor = isDark
        ? Color(0xFF121212)
        : Color(0xfff9f9f9);
    final Color cardColor = isDark ? Color(0xFF1E1E1E) : Colors.white;
    final Color textPrimary = isDark ? Colors.white : Colors.black87;
    final Color textSecondary = isDark ? Colors.white70 : Colors.black54;
    final Color timeText = isDark ? Colors.white60 : Colors.grey;

    return Scaffold(
      backgroundColor: bgColor,
      bottomNavigationBar: BottomNavBar(
        currentIndex: 1,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushNamed(context, Routes.HOME);
              break;
            case 1:
              break;
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
            // 🔍 Search + Filter
            Padding(
              padding:EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Expanded(
                    flex: 7,
                    child: Container(
                      height: 45,
                      decoration: BoxDecoration(
                        color: isDark ?Color(0xFF1E1E1E) : Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: isDark
                            ? []
                            : [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 6,
                                  offset: Offset(0, 2),
                                ),
                              ],
                      ),
                      child: InkWell(
                        onTap: () => Get.toNamed(Routes.SEARCH_SCREEN),
                        borderRadius: BorderRadius.circular(24),
                        child: Row(
                          children: [
                            SizedBox(width: 16),
                            Icon(
                              Icons.search,
                              color: isDark ? Colors.white70 : Colors.grey,
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Search News',
                                style: TextStyle(
                                  color: isDark ? Colors.white54 : Colors.grey,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  SizedBox(width: 12),

                  Container(
                    height: 45,
                    width: 45,
                    decoration: BoxDecoration(
                      color: isDark ? Color(0xFF1E1E1E) : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: isDark
                          ? []
                          : [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 6,
                                offset: Offset(0, 2),
                              ),
                            ],
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.tune_rounded,
                        color: isDark ? Colors.white70 : Colors.grey,
                      ),
                      onPressed: () => _showFilterBottomSheet(context),
                    ),
                  ),
                ],
              ),
            ),

            // 🔖 Category chip list
            SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 16),
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

            SizedBox(height: 8),

            // 📰 News list
            Expanded(
              child: Obx(() {
                if (controller.isLoading) return LoadingShimmer();
                if (controller.error.isNotEmpty)
                  return _buildErrorWidget(isDark);
                if (controller.articles.isEmpty)
                  return _buildEmptyWidget(isDark);

                return RefreshIndicator(
                  onRefresh: controller.refreshNews,
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(
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
                          margin: EdgeInsets.only(bottom: 14),
                          decoration: BoxDecoration(
                            color: cardColor,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: SizedBox(
                            height: 120, // <-- FIXED CARD HEIGHT
                            child: Row(
                              children: [
                                // IMAGE
                                ClipRRect(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(16),
                                    bottomLeft: Radius.circular(16),
                                  ),
                                  child: SizedBox(
                                    width: 120,
                                    height: 120,
                                    child: Image.network(
                                      article.urlToImage ?? '',
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              Container(
                                                color: Colors.grey[800],
                                                child: Icon(
                                                  Icons.image_not_supported,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                    ),
                                  ),
                                ),

                                // TEXT AREA
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(
                                      12,
                                      10,
                                      12,
                                      10,
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // TITLE
                                        Text(
                                          article.title ?? 'No Title',
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: textPrimary,
                                          ),
                                        ),

                                        // DESCRIPTION
                                        Expanded(
                                          child: Text(
                                            article.description ?? '',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: textSecondary,
                                              height: 1.3,
                                            ),
                                          ),
                                        ),

                                        // TIME + BOOKMARK
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
                                              style: TextStyle(
                                                fontSize: 11,
                                                color: timeText,
                                              ),
                                            ),

                                            Container(
                                              padding: EdgeInsets.all(6),
                                              decoration: BoxDecoration(
                                                color: AppColors.primary,
                                                shape: BoxShape.circle,
                                              ),
                                              child: Icon(
                                                Icons.bookmark_outline,
                                                color: Colors.white,
                                                size: 18,
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

  // EMPTY STATE
  Widget _buildEmptyWidget(bool isDark) => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.newspaper,
          size: 64,
          color: isDark ? Colors.white30 : Colors.grey,
        ),
        SizedBox(height: 16),
        Text(
          'No News available',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Please try again later',
          style: TextStyle(color: isDark ? Colors.white54 : Colors.grey),
        ),
      ],
    ),
  );

  // ERROR STATE
  Widget _buildErrorWidget(bool isDark) => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.error_outline,
          size: 64,
          color: isDark ? Colors.redAccent : Colors.redAccent,
        ),
        SizedBox(height: 16),
        Text(
          'Something went wrong',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Please check your internet connection',
          style: TextStyle(color: isDark ? Colors.white54 : Colors.grey),
        ),
        SizedBox(height: 24),
        ElevatedButton(
          onPressed: Get.find<NewsController>().refreshNews,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: Text('Retry', style: TextStyle(color: Colors.white)),
        ),
      ],
    ),
  );

  // FILTER BOTTOM SHEET
  void _showFilterBottomSheet(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? Color(0xFF1E1E1E) : Colors.white,
      shape: RoundedRectangleBorder(
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
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Filter by Time',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              SizedBox(height: 12),
              ...filters.map(
                (filter) => ListTile(
                  title: Text(
                    filter,
                    style: TextStyle(
                      fontSize: 16,
                      color: isDark ? Colors.white70 : Colors.black,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Get.find<NewsController>().filterByTime(filter);

                    Get.snackbar(
                      'Filter Applied',
                      'Showing news from $filter',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: AppColors.primary,
                      colorText: Colors.white,
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
