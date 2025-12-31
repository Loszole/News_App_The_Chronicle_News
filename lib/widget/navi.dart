import 'package:flutter/material.dart';

// Define the icons for navigation
const List<IconData> _icons = [
  Icons.home,
  Icons.search,
  Icons.bookmark,
];

class NavigationBarWidget extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const NavigationBarWidget({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(32),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(_icons.length, (index) {
              final bool isSelected = currentIndex == index;
              return GestureDetector(
                onTap: () {
                  onTap(index);
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.white : Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                  width: 40,
                  height: 40,
                  child: Icon(
                    _icons[index],
                    color: isSelected ? Colors.black : Colors.white,
                    size: 24,
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}