import 'package:flutter/material.dart';
import 'home.dart';
import 'search.dart';
import 'bookmark.dart';
// import 'detail.dart';
import '../widget/navi.dart';

class MasterScreen extends StatefulWidget {
  const MasterScreen({super.key});

  @override
  State<MasterScreen> createState() => _MasterScreenState();
}

class _MasterScreenState extends State<MasterScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomeScreen(),
    const SearchScreen(),
    const BookmarkScreen(),
  ];

  void _onNavTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // Main page content
            Positioned.fill(
              child: _pages[_selectedIndex],
            ),
            // Custom navigation bar
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: NavigationBarWidget(
                key: const ValueKey('customNav'),
                // Pass correct parameter name
                currentIndex: _selectedIndex,
                onTap: _onNavTap,
              ),
            ),
          ],
        ),
      ),
    );
  }
}