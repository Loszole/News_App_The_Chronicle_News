import 'package:flutter/material.dart';

class BookmarkStore extends ChangeNotifier {
  final List<Map> _bookmarks = [];

  List<Map> get bookmarks => _bookmarks;

  void add(Map article) {
    if (!_bookmarks.any((a) => a['url'] == article['url'])) {
      _bookmarks.add(article);
      notifyListeners();
    }
  }

  void remove(Map article) {
    _bookmarks.removeWhere((a) => a['url'] == article['url']);
    notifyListeners();
  }
}