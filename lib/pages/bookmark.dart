import 'package:flutter/material.dart';
import '../logic/bookmark_store.dart';
import 'detail.dart';
import 'package:provider/provider.dart';
import '../widget/menu.dart';

class BookmarkScreen extends StatelessWidget {
  const BookmarkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bookmarks = context.watch<BookmarkStore>().bookmarks;
    return Scaffold(
      backgroundColor: const Color(0xFF181A20),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
              child: Row(
                children: [
                  const Icon(Icons.bookmark, color: Colors.white, size: 32),
                  const SizedBox(width: 8),
                  const Text(
                    'Saved News',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  // Menu button
                  MenuWidget(),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: bookmarks.isEmpty
                  ? const Center(
                      child: Text('No saved articles.', style: TextStyle(color: Colors.white54)),
                    )
                  : ListView.builder(
                      itemCount: bookmarks.length,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      itemBuilder: (context, i) {
                        final article = bookmarks[i];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => DetailScreen(article: article),
                              ),
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(28),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.08),
                                  blurRadius: 16,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.redAccent,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Text('SAVED', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                                    ),
                                    const Spacer(),
                                    IconButton(
                                      icon: const Icon(Icons.delete, color: Colors.redAccent),
                                      onPressed: () => context.read<BookmarkStore>().remove(article),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  article['title'] ?? '',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'Saved locally.',
                                  style: TextStyle(color: Colors.grey[600], fontSize: 13),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: Colors.grey[200],
                                      radius: 16,
                                      child: const Icon(Icons.person, color: Colors.grey, size: 20),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        'Source: '
                                        '${article['source_name'] ?? article['author'] ?? article['source']?['name'] ?? 'Unknown'}',
                                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  article['description'] ?? '',
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 15, color: Colors.black87),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}