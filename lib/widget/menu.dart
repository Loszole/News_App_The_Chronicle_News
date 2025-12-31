import 'package:flutter/material.dart';

import '../pages/menu.dart';

class MenuWidget extends StatelessWidget {
  const MenuWidget({super.key});

  void _openMenu(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const MenuScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _openMenu(context),
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white12,
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Center(
            child: Icon(Icons.apps, color: Colors.white, size: 24),
          ),
        ),
      ),
    );
  }
}