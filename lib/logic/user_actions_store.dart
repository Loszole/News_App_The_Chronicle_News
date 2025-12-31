import 'package:flutter/material.dart';

class FollowStore extends ChangeNotifier {
  final Set<String> _followedPublishers = {};

  Set<String> get followedPublishers => _followedPublishers;

  void follow(String publisherName) {
    _followedPublishers.add(publisherName);
    notifyListeners();
  }

  void unfollow(String publisherName) {
    _followedPublishers.remove(publisherName);
    notifyListeners();
  }

  bool isFollowed(String publisherName) {
    return _followedPublishers.contains(publisherName);
  }
}

class LikeStore extends ChangeNotifier {
  final Set<String> _likedArticles = {};

  Set<String> get likedArticles => _likedArticles;

  void like(String articleUrl) {
    _likedArticles.add(articleUrl);
    notifyListeners();
  }

  void unlike(String articleUrl) {
    _likedArticles.remove(articleUrl);
    notifyListeners();
  }

  bool isLiked(String articleUrl) {
    return _likedArticles.contains(articleUrl);
  }
}

class CommentStore extends ChangeNotifier {
  final Map<String, List<String>> _comments = {};

  Map<String, List<String>> get comments => _comments;

  void addComment(String articleUrl, String comment) {
    _comments.putIfAbsent(articleUrl, () => []).add(comment);
    notifyListeners();
  }

  List<String> getComments(String articleUrl) {
    return _comments[articleUrl] ?? [];
  }
}

class ShareStore extends ChangeNotifier {
  final Set<String> _sharedArticles = {};

  Set<String> get sharedArticles => _sharedArticles;

  void share(String articleUrl) {
    _sharedArticles.add(articleUrl);
    notifyListeners();
  }

  bool isShared(String articleUrl) {
    return _sharedArticles.contains(articleUrl);
  }
}
