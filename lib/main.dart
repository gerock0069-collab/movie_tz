import 'package:flutter/material.dart';

void main() {
  runApp(const MoviesTzApp());
}

class MoviesTzApp extends StatefulWidget {
  const MoviesTzApp({super.key});

  @override
  State<MoviesTzApp> createState() => _MoviesTzAppState();
}

class _MoviesTzAppState extends State<MoviesTzApp> {
  ThemeMode _themeMode = ThemeMode.dark;

  void _toggleTheme() {
    setState(() {
      _themeMode =
      _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movies TZ',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.red,
        scaffoldBackgroundColor: Colors.grey[100],
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 1,
        ),
      ),
      darkTheme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF121212),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1E1E1E),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      home: MainNavigationScreen(
        onToggleTheme: _toggleTheme,
        isDarkMode: _themeMode == ThemeMode.dark,
      ),
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  final VoidCallback onToggleTheme;
  final bool isDarkMode;

  const MainNavigationScreen({
    super.key,
    required this.onToggleTheme,
    required this.isDarkMode,
  });

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      HomeScreen(
        onToggleTheme: widget.onToggleTheme,
        isDarkMode: widget.isDarkMode,
      ),
      const CategoryScreen(),
      const DownloadScreen(),
      const FavoriteScreen(),
      SettingsScreen(
        onToggleTheme: widget.onToggleTheme,
        isDarkMode: widget.isDarkMode,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.redAccent,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Nyumbani',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Kategoria',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.download),
            label: 'Vipakuliwa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Vipendwa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Mipangilio',
          ),
        ],
      ),
    );
  }
}

// 1. Skrini ya Nyumbani (Netflix UI + Orodha ya VIP/Bure)
class HomeScreen extends StatelessWidget {
  final VoidCallback onToggleTheme;
  final bool isDarkMode;

  const HomeScreen({
    super.key,
    required this.onToggleTheme,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'MOVIES TZ',
          style: TextStyle(
            color: Colors.redAccent,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            tooltip: 'Tafuta',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Utafutaji unafunguliwa...')),
              );
            },
          ),
          IconButton(
            icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
            tooltip: isDarkMode ? 'Weka Mwanga' : 'Weka Giza',
            onPressed: onToggleTheme,
          ),
          IconButton(
            icon: const Icon(Icons.share),
            tooltip: 'Shiriki',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Kushiriki kiungo cha app...')),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Featured Movie Poster (Banner ya Juu)
            Container(
              height: 220,
              width: double.infinity,
              margin: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: const DecorationImage(
                  image: NetworkImage(
                    'https://images.unsplash.com/photo-1536440136628-849c177e76a1?w=800',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                padding: const EdgeInsets.all(16),
                alignment: Alignment.bottomLeft,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withOpacity(0.85),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.play_arrow),
                      label: const Text('Tazama Sasa'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 10),
                    OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.add, color: Colors.white),
                      label: const Text('Orodha Yangu', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ),
            ),

            // Orodha ya Movies (Mlalo)
            _buildMovieSection('Zinazopendwa Zaidi'),
            _buildMovieSection('Mpya Zilizotoka'),

            // Orodha ya Vipindi (Episodes - Bure na VIP)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Text(
                'Vipindi vya Tamthilia',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: 15,
              itemBuilder: (context, index) {
                int epNum = index + 1;
                bool isFree = epNum >= 1 && epNum <= 10;

                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: isFree ? Colors.green : Colors.amber[800],
                      child: Icon(
                        isFree ? Icons.play_arrow : Icons.lock,
                        color: Colors.white,
                      ),
                    ),
                    title: Text(
                      'Sehemu ya $epNum (Episode $epNum)',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      isFree ? 'Bure Kuangalia' : 'Inahitaji Kulipia (VIP)',
                      style: TextStyle(
                        color: isFree ? Colors.green : Colors.amber[800],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing: Chip(
                      label: Text(
                        isFree ? 'BURE' : 'VIP',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      backgroundColor: isFree ? Colors.green : Colors.amber[800],
                    ),
                    onTap: () {
                      if (isFree) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Inacheza Sehemu ya $epNum...')),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Sehemu ya $epNum ni ya VIP. Tafadhali jiunge na kifurushi.',
                            ),
                            backgroundColor: Colors.redAccent,
                          ),
                        );
                      }
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMovieSection(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 150,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 5,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemBuilder: (context, index) {
              return Container(
                width: 105,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey[800],
                  image: DecorationImage(
                    image: NetworkImage(
                      'https://picsum.photos/200/300?random=${title.hashCode + index}',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// 2. Skrini ya Kategoria
class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = ['Mapigano (Action)', 'Vichekesho (Comedy)', 'Mapenzi (Romance)', 'Kutisha (Horror)', 'Uchunguzi (Crime)'];
    return Scaffold(
      appBar: AppBar(title: const Text('Kategoria')),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              leading: const Icon(Icons.movie_creation_outlined),
              title: Text(categories[index]),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {},
            ),
          );
        },
      ),
    );
  }
}

// 3. Skrini ya Vipakuliwa
class DownloadScreen extends StatelessWidget {
  const DownloadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Vipakuliwa')),
      body: const Center(
        child: Text('Hakuna faili zilizopakuliwa kwa sasa.'),
      ),
    );
  }
}

// 4. Skrini ya Vipendwa
class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Vipendwa Vyangu')),
      body: const Center(
        child: Text('Orodha yako ya vipendwa ipo wazi.'),
      ),
    );
  }
}

// 5. Skrini ya Mipangilio
class SettingsScreen extends StatelessWidget {
  final VoidCallback onToggleTheme;
  final bool isDarkMode;

  const SettingsScreen({
    super.key,
    required this.onToggleTheme,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mipangilio')),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.dark_mode),
            title: const Text('Mwonekano wa Giza (Dark Theme)'),
            trailing: Switch(
              value: isDarkMode,
              onChanged: (_) => onToggleTheme(),
              activeColor: Colors.redAccent,
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text('Lugha / Language'),
            subtitle: const Text('Kiswahili'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Arifa / Notifications'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.download_for_offline),
            title: const Text('Ubora wa Video (Video Quality)'),
            subtitle: const Text('Full HD (1080p)'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {},
          ),
          const Divider(),
          const ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('Kuhusu App'),
            subtitle: Text('Movies TZ v1.0.0'),
          ),
        ],
      ),
    );
  }
}