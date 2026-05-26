import 'package:flutter/material.dart';

import 'navigation_config.dart';

class MainNavigationShell extends StatefulWidget {
  final List<NavigationItem> items;

  const MainNavigationShell({super.key, required this.items});

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: widget.items.map((item) => item.page).toList(),
      ),

      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF151821),
          border: Border(top: BorderSide(color: Color(0xFF22252F), width: 1)),
        ),

        child: BottomNavigationBar(
          currentIndex: currentIndex,

          onTap: (index) {
            setState(() {
              currentIndex = index;
            });
          },

          type: BottomNavigationBarType.fixed,

          backgroundColor: const Color(0xFF151821),

          elevation: 0,

          selectedItemColor: Colors.white,

          unselectedItemColor: Colors.grey,

          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),

          unselectedLabelStyle: const TextStyle(fontSize: 12),

          items: widget.items.map((item) {
            return BottomNavigationBarItem(
              icon: Icon(item.icon),
              label: item.label,
            );
          }).toList(),
        ),
      ),
    );
  }
}
