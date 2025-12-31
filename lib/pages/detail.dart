import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../logic/bookmark_store.dart';
import 'package:provider/provider.dart';

class DetailScreen extends StatelessWidget {
  final dynamic article;
  const DetailScreen({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF6DC), // Light yellow
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top row: back, share, bookmark
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.black),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.ios_share, color: Colors.black),
                            onPressed: () {},
                          ),
                          IconButton(
                            icon: const Icon(Icons.bookmark_border, color: Colors.black),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Headline
                  Text(
                    article['title'] ?? '',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                        article['pubDate'] != null ? 'Updated ${article['pubDate']}' : 'Updated just now',
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 16),

                  // Subtitle: time, author, follow
                  Row(
                    children: [
                      // Text(
                      //   article['pubDate'] != null ? 'Updated ${article['pubDate']}' : 'Updated just now',
                      //   style: const TextStyle(
                      //     color: Colors.black54,
                      //     fontSize: 13,
                      //   ),
                      // ),
                      // const SizedBox(width: 16),
                      const CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 16,
                        child: Icon(Icons.person, color: Colors.grey, size: 20),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          article['source_name'] ??
                            (article['creator'] != null
                              ? (article['creator'] is List && article['creator'].isNotEmpty
                                  ? article['creator'][0]
                                  : article['creator'].toString())
                              : (article['author'] ?? 'Unknown')),
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 0),
                          minimumSize: const Size(0, 32),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          elevation: 0,
                        ),
                        onPressed: () {},
                        child: const Text('Follow', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Article text
                  Text(
                    article['description'] ?? article['content'] ?? '',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Article image (if available)
                  if (article['image_url'] != null && article['image_url'].toString().isNotEmpty)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(
                        article['image_url'],
                        height: 160,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
                      ),
                    ),
                  const SizedBox(height: 20),
                  // Extra details
                  Wrap(
                    spacing: 12,
                    runSpacing: 8,
                    children: [
                      if (article['category'] != null && article['category'] is List && article['category'].isNotEmpty)
                        Chip(
                          label: Text('Category: ${article['category'].join(', ')}'),
                          backgroundColor: Colors.orange[50],
                        ),
                      // if (article['keywords'] != null && article['keywords'] is List && article['keywords'].isNotEmpty)
                      //   Chip(
                      //     label: Text('Keywords: ${article['keywords'].join(', ')}'),
                      //     backgroundColor: Colors.blue[50],
                      //   ),
                      if (article['language'] != null)
                        Chip(
                          label: Text('Language: ${article['language']}'),
                          backgroundColor: Colors.green[50],
                        ),
                      if (article['country'] != null && article['country'] is List && article['country'].isNotEmpty)
                        Chip(
                          label: Text('Country: ${article['country'].join(', ')}'),
                          backgroundColor: Colors.purple[50],
                        ),
                      if (article['source_url'] != null)
                        ActionChip(
                          label: const Text('Visit Publisher'),
                          avatar: article['source_icon'] != null
                              ? CircleAvatar(
                                  backgroundImage: NetworkImage(article['source_icon']),
                                  backgroundColor: Colors.transparent,
                                )
                              : null,
                          onPressed: () async {
                            final url = article['source_url'];
                            if (url != null && await canLaunchUrl(Uri.parse(url))) {
                              await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Could not open publisher link.')),
                              );
                            }
                          },
                        ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            // Bottom action bar
            Positioned(
              left: 0,
              right: 0,
              bottom: 24,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(32),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.thumb_up_alt_outlined, color: Colors.white, size: 28),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const Icon(Icons.mode_comment_outlined, color: Colors.white, size: 28),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const Icon(Icons.bookmark_border, color: Colors.white, size: 28),
                        onPressed: () {
                          context.read<BookmarkStore>().add(article);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Article saved!')),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
