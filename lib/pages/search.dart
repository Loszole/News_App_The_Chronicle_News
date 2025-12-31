import 'package:flutter/material.dart';
import '../logic/fitch_news.dart';
import 'detail.dart';
import '../widget/menu.dart';



class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  String _query = '';
  List<dynamic> articles = [];
  bool isLoading = true;
  String error = '';
  final List<String> categories = [
    'Trending', 'Health', 'Sports', 'Finance', 'Technology', 'Politics', 'Business', 'Fashion', 'Education', 'E-commerce'
  ];
  String selectedCategory = 'Trending';

  @override
  void initState() {
    super.initState();
    fetchAndSetNews();
  }

  Future<void> fetchAndSetNews() async {
    setState(() {
      isLoading = true;
      error = '';
    });
    try {
      final news = await fetchNews(
        query: _query.isNotEmpty ? _query : null,
        categories: selectedCategory != 'Trending' ? [selectedCategory.toLowerCase()] : null,
      );
      setState(() {
        articles = news;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = 'Error: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  const Icon(Icons.search, color: Colors.white, size: 32),
                  const SizedBox(width: 8),
                  const Text(
                    'Search',
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
            // Category tabs
            SizedBox(
              height: 40,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: categories.length,
                separatorBuilder: (_, _) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final cat = categories[index];
                  final selected = cat == selectedCategory;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedCategory = cat;
                      });
                      fetchAndSetNews();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                      decoration: BoxDecoration(
                        color: selected ? Colors.white : Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white24),
                      ),
                      child: Text(
                        cat,
                        style: TextStyle(
                          color: selected ? Colors.black : Colors.white,
                          fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            // Search bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: TextField(
                controller: _controller,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Search articles...',
                  hintStyle: const TextStyle(color: Colors.white54),
                  prefixIcon: const Icon(Icons.search, color: Colors.white54),
                  filled: true,
                  fillColor: Colors.white12,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _query = value;
                  });
                  fetchAndSetNews();
                },
              ),
            ),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : error.isNotEmpty
                      ? Center(child: Text(error, style: const TextStyle(color: Colors.red)))
                      : articles.isEmpty
                          ? const Center(child: Text('No news found.', style: TextStyle(color: Colors.white54)))
                          : ListView.builder(
                              itemCount: articles.length,
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                              itemBuilder: (context, i) {
                                final article = articles[i];
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
                                              child: const Text('LIVE', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                                            ),
                                            const Spacer(),
                                            const Icon(Icons.more_horiz, color: Colors.black45),
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
                                          'Updated just now.',
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
                                                'Published by ${article['source_name'] ?? article['author'] ?? 'Unknown'}',
                                                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
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
                                        const SizedBox(height: 12),
                                        Text(
                                          article['description'] ?? '',
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(fontSize: 15, color: Colors.black87),
                                        ),
                                        const SizedBox(height: 12),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            IconButton(
                                              icon: const Icon(Icons.thumb_up_alt_outlined, color: Colors.black45),
                                              onPressed: () {},
                                            ),
                                            IconButton(
                                              icon: const Icon(Icons.mode_comment_outlined, color: Colors.black45),
                                              onPressed: () {},
                                            ),
                                            IconButton(
                                              icon: const Icon(Icons.ios_share, color: Colors.black45),
                                              onPressed: () {},
                                            ),
                                          ],
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