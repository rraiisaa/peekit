import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:peekit_app/controllers/news_controller.dart';
import 'package:peekit_app/routes/app_pages.dart';
import 'package:peekit_app/utils/app_colors.dart';
import 'package:peekit_app/widgets/news_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final NewsController controller = Get.find<NewsController>();
  final TextEditingController _searchController = TextEditingController();

  final List<String> _recentSearches = [];
  final List<String> _trendingSearches = [
    'Artificial Intelligence',
    'Climate Change',
    'Elections 2025',
    'Tech Startups',
    'Global Economy',
  ];

  bool _hasSearched = false;
  final RxBool _isSearching = false.obs;

  Future<void> _onSearch(String query) async {
    if (query.trim().isEmpty) return;

    final q = query.trim();

    if (!_recentSearches.contains(q)) {
      setState(() {
        _recentSearches.insert(0, q);
        if (_recentSearches.length > 10) _recentSearches.removeLast();
      });
    }

    setState(() => _hasSearched = true);

    _isSearching.value = true;
    await controller.searchNews(q);
    _isSearching.value = false;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                  onPressed: () => Get.back(),
                ),
                Expanded(
                  child: Container(
                    height: 45,
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.grey.shade900
                          : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        if (!isDark)
                          BoxShadow(
                            color: Colors.black12.withOpacity(0.05),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 12),
                        Icon(Icons.search,
                            color: isDark ? Colors.grey[400] : Colors.grey),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            autofocus: true,
                            style: TextStyle(
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                            textInputAction: TextInputAction.search,
                            onSubmitted: _onSearch,
                            decoration: InputDecoration(
                              hintText: 'Search news...',
                              hintStyle: TextStyle(
                                color: isDark
                                    ? Colors.grey[500]
                                    : Colors.grey,
                              ),
                              border: InputBorder.none,
                            ),
                            onChanged: (_) => setState(() {}),
                          ),
                        ),
                        if (_searchController.text.isNotEmpty)
                          IconButton(
                            icon: Icon(
                              Icons.clear,
                              color: isDark ? Colors.grey[400] : Colors.grey,
                            ),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _hasSearched = false);
                            },
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Obx(() {
        if (_isSearching.value) {
          return const Center(child: CircularProgressIndicator());
        }

        // ===== DEFAULT: TRENDING & RECENT =====
        if (!_hasSearched) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Trending Searches',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 12),

                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _trendingSearches.map((term) {
                    return GestureDetector(
                      onTap: () {
                        _searchController.text = term;
                        _onSearch(term);
                      },
                      child: Chip(
                        label: Text(term),
                        backgroundColor:
                            isDark ? Colors.black : Colors.white,
                        labelStyle: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(
                            color: AppColors.primary,
                            width: 1,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 24),

                if (_recentSearches.isNotEmpty)
                  Text(
                    'Recent Searches',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),

                const SizedBox(height: 12),

                Column(
                  children: _recentSearches.map((query) {
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(
                        Icons.history,
                        color: isDark ? Colors.grey[400] : Colors.grey,
                      ),
                      title: Text(
                        query,
                        style: TextStyle(
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                      onTap: () {
                        _searchController.text = query;
                        _onSearch(query);
                      },
                      trailing: IconButton(
                        icon: Icon(
                          Icons.close,
                          color: isDark ? Colors.grey[400] : Colors.grey,
                        ),
                        onPressed: () {
                          setState(() => _recentSearches.remove(query));
                        },
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          );
        }

        // ===== SEARCH RESULTS =====
        if (controller.articles.isNotEmpty) {
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.articles.length,
            itemBuilder: (context, index) {
              final article = controller.articles[index];
              return NewsCard(
                article: article,
                onTap: () =>
                    Get.toNamed(Routes.NEWS_DETAIL, arguments: article),
              );
            },
          );
        }

        return Center(
          child: Text(
            'No results found',
            style: TextStyle(
              color: isDark ? Colors.grey[400] : Colors.grey,
              fontSize: 16,
            ),
          ),
        );
      }),
    );
  }
}
