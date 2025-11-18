import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:peekit_app/controllers/news_controller.dart';
import 'package:peekit_app/routes/app_pages.dart';
import 'package:peekit_app/utils/app_colors.dart';
import 'package:peekit_app/widgets/category_chip.dart';
import 'package:peekit_app/widgets/loading_shimmer.dart';
import 'package:peekit_app/widgets/news_card.dart';
import 'package:peekit_app/widgets/bottom_navbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final NewsController controller = Get.find<NewsController>();
  bool _showGreeting = false;

  @override
  void initState() {
    super.initState();
    _checkFirstTimeUser();
  }

  Future<void> _checkFirstTimeUser() async {
    final prefs = await SharedPreferences.getInstance();
    final hasSeenGreeting = prefs.getBool('hasSeenGreeting') ?? false;

    if (!hasSeenGreeting) {
      Future.delayed(const Duration(milliseconds: 600), () {
        setState(() => _showGreeting = true);
      });
      await prefs.setBool('hasSeenGreeting', true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final PageController pageController = PageController(viewportFraction: 0.9);
    final RxInt currentPage = 0.obs;

    return Stack(
      children: [
        Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          bottomNavigationBar: BottomNavBar(
            currentIndex: 0,
            onTap: (index) {
              switch (index) {
                case 0:
                  break;
                case 1:
                  Navigator.pushNamed(context, Routes.NEWS_SCREEN);
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
                // 🔍 Search bar + filter
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 7,
                        child: GestureDetector(
                          onTap: () => Get.toNamed(Routes.SEARCH_SCREEN),
                          child: Container(
                            height: 45,
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                const SizedBox(width: 16),
                                Icon(Icons.search,
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.color
                                        ?.withOpacity(0.6)),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    'Search News',
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.color
                                          ?.withOpacity(0.6),
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
                      Container(
                        height: 45,
                        width: 45,
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
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
                          icon: Icon(Icons.tune_rounded,
                              color: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.color
                                  ?.withOpacity(0.6)),
                          onPressed: () => _showFilterBottomSheet(context),
                        ),
                      ),
                    ],
                  ),
                ),

                // 🔥 Hot News
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: Text(
                    'Hot News',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                  ),
                ),

                // 📰 Hot News Carousel
                SizedBox(
                  height: 200,
                  child: Obx(() {
                    if (controller.isLoading) return LoadingShimmer();
                    final trending = controller.hotArticles;
                    if (trending.isEmpty) {
                      return Center(
                        child: Text(
                          "No hot news available 📰",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color:
                                Theme.of(context).textTheme.bodyMedium?.color,
                          ),
                        ),
                      );
                    }

                    return Column(
                      children: [
                        Expanded(
                          child: PageView.builder(
                            controller: pageController,
                            itemCount: trending.length,
                            onPageChanged: (index) => currentPage.value = index,
                            itemBuilder: (context, index) {
                              final article = trending[index];
                              return GestureDetector(
                                onTap: () => Get.toNamed(
                                  Routes.NEWS_DETAIL,
                                  arguments: article,
                                ),
                                child: Container(
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    image: DecorationImage(
                                      image: NetworkImage(
                                        article.urlToImage ??
                                            'https://via.placeholder.com/400x200?text=No+Image',
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      gradient: LinearGradient(
                                        begin: Alignment.bottomCenter,
                                        end: Alignment.topCenter,
                                        colors: [
                                          AppColors.primary.withOpacity(0.8),
                                          Colors.transparent,
                                        ],
                                      ),
                                    ),
                                    padding: const EdgeInsets.all(12),
                                    alignment: Alignment.bottomLeft,
                                    child: Text(
                                      article.title ?? '',
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 8),
                        Obx(() {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              trending.length,
                              (index) => AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                width: currentPage.value == index ? 10 : 8,
                                height: currentPage.value == index ? 10 : 8,
                                decoration: BoxDecoration(
                                  color: currentPage.value == index
                                      ? AppColors.primary
                                      : Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.color
                                          ?.withOpacity(0.3),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          );
                        }),
                      ],
                    );
                  }),
                ),
                const SizedBox(height: 10),

                // 🧭 Category chips
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
                        padding: const EdgeInsets.all(16),
                        itemCount: controller.articles.length,
                        itemBuilder: (context, index) {
                          final article = controller.articles[index];
                          return NewsCard(
                            article: article,
                            onTap: () => Get.toNamed(
                              Routes.NEWS_DETAIL,
                              arguments: article,
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
        ),

        // 🎉 Greeting popup
        if (_showGreeting)
          GestureDetector(
            onTap: () => setState(() => _showGreeting = false),
            child: Container(
              color: Colors.black.withOpacity(0.3),
              alignment: Alignment.center,
              child: Container(
                width: 280,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset('assets/images/greeting_popup.png',
                        height: 120),
                    const SizedBox(height: 16),
                    Text(
                      'Welcome to Peekit! 👋',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "You're about to see the world — one peek at a time.\nStay curious, scroll smart, and let AI do summarized for you.",
                      style: TextStyle(
                        color: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.color
                            ?.withOpacity(0.7),
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  // ⚠️ Empty & Error
  Widget _buildEmptyWidget() => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/peek_no_news.png',
                width: 120, height: 120),
            const SizedBox(height: 16),
            Text(
              'No News available',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Please try again later',
              style: TextStyle(
                  color: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.color
                      ?.withOpacity(0.7)),
            ),
          ],
        ),
      );

  Widget _buildErrorWidget() => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.redAccent),
            const SizedBox(height: 16),
            Text(
              'Something went wrong',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Please check your internet connection',
              style: TextStyle(
                  color: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.color
                      ?.withOpacity(0.7)),
            ),
          ],
        ),
      );

  // 📅 Filter
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
              Text(
                'Filter by Time',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).textTheme.bodyLarge?.color),
              ),
              const SizedBox(height: 12),
              ...filters.map(
                (filter) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    filter,
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                  ),
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
