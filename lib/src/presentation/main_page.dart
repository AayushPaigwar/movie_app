import 'package:flutter/material.dart';
import 'package:movie_stream_app/src/presentation/favorites/ui/enhanced_favorites_screen.dart';
import 'package:movie_stream_app/src/presentation/home/ui/home_screen.dart';
import 'package:movie_stream_app/src/presentation/profile/ui/profile_screen.dart';
import 'package:movie_stream_app/src/presentation/search/ui/search_screen.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _index = 0;

  final _pages = [
    const HomeScreen(),
    const SearchScreen(),
    const EnhancedFavoritesScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: _pages[_index],
      bottomNavigationBar: NavigationBar(
        height: 68,
        elevation: 0,
        indicatorColor: colorScheme.primary.withValues(alpha: 0.18),
        backgroundColor: Colors.black.withValues(alpha: 0.2),
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.search_rounded),
            label: 'Search',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_outline_rounded),
            selectedIcon: Icon(Icons.favorite_rounded),
            label: 'Favorites',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
