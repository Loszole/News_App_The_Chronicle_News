import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../logic/bookmark_store.dart';
import '../logic/user_actions_store.dart';

class NewsCardWidget extends StatelessWidget {
  final Map<String, dynamic> article;
  final VoidCallback? onFollow;
  final VoidCallback? onLike;
  final VoidCallback? onShare;

  const NewsCardWidget({
    super.key,
    required this.article,
    this.onFollow,
    this.onLike,
    this.onShare,
  });

  // --- Logic Handlers ---
  void _handleFollow(BuildContext context) {
    final followStore = Provider.of<FollowStore>(context, listen: false);
    final publisherName = article['publisherName'] ?? 'Unknown';
    if (!followStore.isFollowed(publisherName)) {
      followStore.follow(publisherName);
    } else {
      followStore.unfollow(publisherName);
    }
  }

  void _handleLike(BuildContext context) {
    final likeStore = Provider.of<LikeStore>(context, listen: false);
    final articleUrl = article['url'] ?? '';
    if (!likeStore.isLiked(articleUrl)) {
      likeStore.like(articleUrl);
    } else {
      likeStore.unlike(articleUrl);
    }
  }

  @override
  Widget build(BuildContext context) {
    final articleUrl = article['url'] ?? '';
    final publisherName = article['publisherName'] ?? 'Unknown';

    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF8E9E9),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ... Title and Date sections remain the same ...

          // --- Publisher Row with Follow Button ---
          Row(
            children: [
              const CircleAvatar(radius: 16, child: Icon(Icons.person)),
              const SizedBox(width: 8),
              Expanded(child: Text('Published by $publisherName')),

              // Wrap only the button in a Consumer to detect changes
              Consumer<FollowStore>(
                builder: (context, followStore, child) {
                  final isFollowed = followStore.isFollowed(publisherName);
                  return ElevatedButton(
                    onPressed: () => _handleFollow(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isFollowed ? Colors.orange : Colors.black,
                    ),
                    child: Text(isFollowed ? 'Following' : 'Follow'),
                  );
                },
              ),
            ],
          ),

          const SizedBox(height: 16),
          Text(article['description'] ?? ''),
          const SizedBox(height: 18),

          // --- Action Icons Row ---
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // LIKE BUTTON
              Consumer<LikeStore>(
                builder: (context, likeStore, child) {
                  final isLiked = likeStore.isLiked(articleUrl);
                  return IconButton(
                    icon: Icon(
                      isLiked ? Icons.thumb_up : Icons.thumb_up_alt_outlined,
                      color: isLiked ? Colors.blue : Colors.black,
                    ),
                    onPressed: () => _handleLike(context),
                  );
                },
              ),

              // COMMENT BUTTON (Example)
              IconButton(
                icon: const Icon(Icons.comment_outlined),
                onPressed: () {
                   Provider.of<CommentStore>(context, listen: false)
                      .addComment(articleUrl, "New Comment");
                },
              ),

              // BOOKMARK BUTTON
              Consumer<BookmarkStore>(
                builder: (context, bookmarkStore, child) {
                  final isBookmarked = bookmarkStore.bookmarks.any((a) => a['url'] == articleUrl);
                  return IconButton(
                    icon: Icon(
                      isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                      color: isBookmarked ? Colors.orange : Colors.black,
                    ),
                    onPressed: () {
                      if (isBookmarked) {
                        bookmarkStore.remove(article);
                      } else {
                        bookmarkStore.add(article);
                      }
                    },
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class HorizontalScrollWidget extends StatelessWidget {
  const HorizontalScrollWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          // Your widgets here
        ],
      ),
    );
  }
}

class DetailScreen extends StatelessWidget {
  final Map<String, dynamic> article;
  const DetailScreen({Key? key, required this.article}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bookmarkStore = Provider.of<BookmarkStore>(context);
    final isBookmarked = bookmarkStore.bookmarks.any((a) => a['url'] == article['url']);
    return Scaffold(
      appBar: AppBar(
        title: Text(article['title'] ?? ''),
        actions: [
          IconButton(
            icon: isBookmarked ? const Icon(Icons.bookmark, color: Colors.orange) : const Icon(Icons.bookmark_border),
            onPressed: () {
              if (isBookmarked) {
                bookmarkStore.remove(article);
              } else {
                bookmarkStore.add(article);
              }
            },
            tooltip: isBookmarked ? 'Remove Bookmark' : 'Bookmark',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              article['title'] ?? '',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Source: ${article['source']?['name'] ?? 'Unknown'}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w500,
                  ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Article content
                    Text(
                      article['content'] ?? '',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
