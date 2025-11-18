import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:peekit_app/models/news_articles.dart';
import 'package:timeago/timeago.dart' as timeago;

class NewsCard extends StatelessWidget {
  final NewsArticles article;
  final VoidCallback? onTap;

  const NewsCard({super.key, required this.article, this.onTap});

  @override
  Widget build(BuildContext context) {
    
    final theme = Theme.of(context);

    final cardColor = theme.cardColor;                        // <-- AUTO light/dark
    final textPrimary = theme.colorScheme.onSurface;          // Title
    final textSecondary = theme.colorScheme.onSurfaceVariant; // Subtitle

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      color: cardColor, // HERE — following theme
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            /// IMAGE
            if (article.urlToImage != null)
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: CachedNetworkImage(
                  imageUrl: article.urlToImage!,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => Container(
                    height: 200,
                    color: theme.dividerColor,
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                  errorWidget: (_, __, ___) => Container(
                    height: 200,
                    color: theme.dividerColor,
                    child: Icon(
                      Icons.broken_image,
                      color: textSecondary,
                      size: 48,
                    ),
                  ),
                ),
              ),

            /// CONTENT
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  /// SOURCE + TIME
                  Row(
                    children: [
                      if (article.source?.name != null) ...[
                        Expanded(
                          child: Text(
                            article.source!.name!,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.primary,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],

                      if (article.publishedAt != null)
                        Text(
                          timeago.format(DateTime.parse(article.publishedAt!)),
                          style: TextStyle(
                            color: textSecondary,
                            fontSize: 13,
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  /// TITLE
                  if (article.title != null)
                    Text(
                      article.title!,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: textPrimary,
                        height: 1.35,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),

                  const SizedBox(height: 8),

                  /// DESCRIPTION
                  if (article.description != null)
                    Text(
                      article.description!,
                      style: TextStyle(
                        fontSize: 15,
                        color: textSecondary,
                        height: 1.4,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
