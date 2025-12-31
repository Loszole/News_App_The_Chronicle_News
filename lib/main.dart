import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'logic/bookmark_store.dart';
// import 'pages/master.dart';
import 'pages/onboarding.dart';


void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => BookmarkStore(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const OnboardingScreen(),
    );
  }
}