import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'tabs/matches_tab.dart';
import 'tabs/favorites_tab.dart';
import 'tabs/profile_tab.dart';

class MainNavigationScreen extends StatefulWidget {
  final int initialIndex;
  const MainNavigationScreen({super.key, this.initialIndex = 0});
  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  late int _currentIndex;
  final List<Widget> _tabs = const [
    MatchesTab(),
    FavoritesTab(),
    ProfileTab(),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: IndexedStack(
          index: _currentIndex,
          children: _tabs,
        ),
      ),
      bottomNavigationBar: Container(
        color: AppTheme.darkNav,
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (i) => setState(() => _currentIndex = i),
          backgroundColor: AppTheme.darkNav,
          selectedItemColor: AppTheme.primary,
          unselectedItemColor: AppTheme.textSecondary,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.sports_soccer_rounded), label: 'Matchs'),
            BottomNavigationBarItem(icon: Icon(Icons.star_rounded), label: 'Favoris'),
            BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: 'Mon espace'),
          ],
        ),
      ),
    );
  }
}
