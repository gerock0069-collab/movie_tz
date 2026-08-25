import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(const JKMoviesApp());
}

class AppState extends ChangeNotifier {
  bool isDarkMode = false;
  bool isSwahili = true;
  List<Map<String, dynamic>> favorites = [];
  List<Map<String, dynamic>> movies = [
    {
      'title': 'Aladdin: Mtalisikia Jina Langu',
      'category': 'SEASON ZOTE',
      'url': 'https://drive.google.com/drive/folders/1y5y-5_Pz0YyNWOxng1095L9R9YFp6htv',
      'image': 'https://picsum.photos/seed/aladdin/600/400',
      'approved': true,
      'source': 'Google Drive / Cloudflare'
    },
    {
      'title': 'Diary of a Night Watchman',
      'category': 'SINGLE ZOTE',
      'url': 'https://drive.google.com/drive/folders/1y5y-5_Pz0YyNWOxng1095L9R9YFp6htv',
      'image': 'https://picsum.photos/seed/watchman/600/400',
      'approved': true,
      'source': 'Google Drive'
    },
    {
      'title': 'Faith / Sin of Faith',
      'category': 'DJ ALLY',
      'url': 'https://drive.google.com/drive/folders/1y5y-5_Pz0YyNWOxng1095L9R9YFp6htv',
      'image': 'https://picsum.photos/seed/faith/600/400',
      'approved': true,
      'source': 'Cloudflare'
    },
    {
      'title': 'Porus: Bharat ke Pehle Rakshak',
      'category': 'DJ BLACK',
      'url': 'https://drive.google.com/drive/folders/1y5y-5_Pz0YyNWOxng1095L9R9YFp6htv',
      'image': 'https://picsum.photos/seed/porus/600/400',
      'approved': true,
      'source': 'Google Drive'
    },
  ];

  void toggleTheme() {
    isDarkMode = !isDarkMode;
    notifyListeners();
  }

  void toggleLanguage() {
    isSwahili = !isSwahili;
    notifyListeners();
  }

  void addMovie(Map<String, dynamic> movie) {
    movies.add(movie);
    notifyListeners();
  }

  void toggleFavorite(Map<String, dynamic> movie) {
    if (favorites.contains(movie)) {
      favorites.remove(movie);
    } else {
      favorites.add(movie);
    }
    notifyListeners();
  }

  bool isFavorite(Map<String, dynamic> movie) => favorites.contains(movie);
}

final appState = AppState();

class JKMoviesApp extends StatefulWidget {
  const JKMoviesApp({super.key});

  @override
  State<JKMoviesApp> createState() => _JKMoviesAppState();
}

class _JKMoviesAppState extends State<JKMoviesApp> {
  @override
  void initState() {
    super.initState();
    appState.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JK MOVIES tz',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.red,
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.red,
        scaffoldBackgroundColor: const Color(0xFF121212),
      ),
      themeMode: appState.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: const MainHomeScreen(),
    );
  }
}

class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({super.key});

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  int _currentIndex = 0;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<String> categories = [
    'ALL',
    'DJ ALLY', 'DJ BABU', 'DJ BLACK', 'DJ BRYTON', 'DJ HERO', 'DJ M',
    'DJ MACK', 'DJ MJUKUU', 'DJ MSATI', 'DJ MURPHY', 'DJ MECK', 'DJ NASRY',
    'DJ OMMY', 'DJ RAJA', 'DJ SHIZZOL', 'DJ SIX 6', 'DJ SKILLS', 'DJ SMART',
    'DJ VASCO', 'RAMSO DJ', 'SEASON ZOTE', 'SINGLE ZOTE'
  ];
  String selectedCategory = 'ALL';

  final List<String> bannerImages = [
    'https://picsum.photos/seed/banner1/800/400',
    'https://picsum.photos/seed/banner2/800/400',
    'https://picsum.photos/seed/banner3/800/400',
    'https://picsum.photos/seed/banner4/800/400',
  ];
  int _currentBannerIndex = 0;
  late Timer _bannerTimer;

  @override
  void initState() {
    super.initState();
    _bannerTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      setState(() {
        _currentBannerIndex = (_currentBannerIndex + 1) % bannerImages.length;
      });
    });
  }

  @override
  void dispose() {
    _bannerTimer.cancel();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      buildHomeTab(),
      buildCategoriesTab(),
      buildFavoritesTab(),
      buildSettingsTab(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(appState.isSwahili ? 'JK MOVIES tz - Nyumbani' : 'JK MOVIES tz - Home'),
        backgroundColor: Colors.red[800],
        actions: [
          IconButton(
            icon: const Icon(Icons.admin_panel_settings),
            tooltip: 'Admin Panel',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AdminPanelScreen()),
            ),
          )
        ],
      ),
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.red[800],
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (index) => setState(() => _currentIndex = index),
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: appState.isSwahili ? 'Nyumbani' : 'Home',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.category),
            label: appState.isSwahili ? 'Makundi' : 'Categories',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.favorite),
            label: appState.isSwahili ? 'Pendwa' : 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings),
            label: appState.isSwahili ? 'Mipangilio' : 'Settings',
          ),
        ],
      ),
    );
  }

  Widget buildHomeTab() {
    final filteredMovies = appState.movies.where((m) {
      final matchesSearch = m['title'].toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCat = selectedCategory == 'ALL' || m['category'] == selectedCategory;
      return matchesSearch && matchesCat && m['approved'] == true;
    }).toList();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Bar on Top
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _searchController,
              onChanged: (val) => setState(() => _searchQuery = val),
              decoration: InputDecoration(
                hintText: appState.isSwahili ? 'Tafuta movie yoyote...' : 'Search movies...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () => setState(() {
                    _searchController.clear();
                    _searchQuery = '';
                  }),
                )
                    : null,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                filled: true,
              ),
            ),
          ),

          // Dynamic Rotating Banner / Trailer Slider
          SizedBox(
            height: 200,
            child: Stack(
              children: [
                PageView.builder(
                  itemCount: bannerImages.length,
                  controller: PageController(initialPage: _currentBannerIndex),
                  onPageChanged: (idx) => setState(() => _currentBannerIndex = idx),
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        image: DecorationImage(
                          image: NetworkImage(bannerImages[index]),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          gradient: LinearGradient(
                            colors: [Colors.black.withOpacity(0.7), Colors.transparent],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                        alignment: Alignment.bottomLeft,
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          appState.isSwahili ? 'Trailer / Picha Zinazozunguka - JK MOVIES' : 'Rotating Trailer / Images',
                          style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Categories Horizontal Scroll
          SizedBox(
            height: 45,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final cat = categories[index];
                final isSelected = selectedCategory == cat;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ChoiceChip(
                    label: Text(cat),
                    selected: isSelected,
                    selectedColor: Colors.red[800],
                    labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black87),
                    onSelected: (selected) => setState(() => selectedCategory = cat),
                  ),
                );
              },
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(12.0),
            child: Text(
              'Movie Zilizoidhinishwa na Admin (Google Drive / Cloudflare)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),

          // Movie Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: filteredMovies.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemBuilder: (context, index) {
              final movie = filteredMovies[index];
              final isFav = appState.isFavorite(movie);
              return Card(
                elevation: 3,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                              image: DecorationImage(
                                image: NetworkImage(movie['image']),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: CircleAvatar(
                              backgroundColor: Colors.black45,
                              child: IconButton(
                                icon: Icon(isFav ? Icons.favorite : Icons.favorite_border, color: Colors.red),
                                onPressed: () => appState.toggleFavorite(movie),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(movie['title'], maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold)),
                          Text(movie['category'], style: TextStyle(color: Colors.red[800], fontSize: 12)),
                          const SizedBox(height: 4),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.red[800], minimumSize: const Size(double.infinity, 30)),
                            icon: const Icon(Icons.play_arrow, size: 16, color: Colors.white),
                            label: const Text('Tazama / Play', style: TextStyle(fontSize: 12, color: Colors.white)),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: Text(movie['title']),
                                  content: Text(appState.isSwahili
                                      ? 'Movie hii inapatikana kupitia Google Drive / Cloudflare:\n${movie['url']}\n\n[Ruhusa ya Admin Imekubaliwa]'
                                      : 'Hosted on Google Drive / Cloudflare:\n${movie['url']}'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(ctx),
                                      child: const Text('OK'),
                                    )
                                  ],
                                ),
                              );
                            },
                          )
                        ],
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget buildCategoriesTab() {
    return ListView.builder(
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final cat = categories[index];
        return ListTile(
          leading: const Icon(Icons.movie_filter, color: Colors.red),
          title: Text(cat, style: const TextStyle(fontWeight: FontWeight.bold)),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            setState(() {
              selectedCategory = cat;
              _currentIndex = 0;
            });
          },
        );
      },
    );
  }

  Widget buildFavoritesTab() {
    return appState.favorites.isEmpty
        ? const Center(child: Text('Hakuna Movie Pendwa Zilizochaguliwa'))
        : ListView.builder(
      itemCount: appState.favorites.length,
      itemBuilder: (context, index) {
        final movie = appState.favorites[index];
        return ListTile(
          leading: Image.network(movie['image'], width: 50, height: 50, fit: BoxFit.cover),
          title: Text(movie['title']),
          subtitle: Text(movie['category']),
          trailing: IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () => appState.toggleFavorite(movie),
          ),
        );
      },
    );
  }

  Widget buildSettingsTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        SwitchListTile(
          title: const Text('Dark Mode'),
          value: appState.isDarkMode,
          onChanged: (val) => appState.toggleTheme(),
        ),
        SwitchListTile(
          title: const Text('Lugha / Language (Kiswahili / English)'),
          subtitle: Text(appState.isSwahili ? 'Imewekwa Kiswahili' : 'Set to English'),
          value: appState.isSwahili,
          onChanged: (val) => appState.toggleLanguage(),
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.cloud, color: Colors.blue),
          title: const Text('Google Drive Admin Link'),
          subtitle: const Text('https://drive.google.com/drive/folders/1y5y-5_Pz0YyNWOxng1095L9R9YFp6htv'),
          onTap: () {},
        ),
        ListTile(
          leading: const Icon(Icons.video_library, color: Colors.red),
          title: const Text('YouTube Channel'),
          onTap: () {},
        ),
        ListTile(
          leading: const Icon(Icons.chat, color: Colors.green),
          title: const Text('WhatsApp Group & Support (0775 477047)'),
          subtitle: const Text('Lipa No: 19382338 | TZS 5,000 / mwezi kwa movie zote'),
          onTap: () {},
        ),
        ListTile(
          leading: const Icon(Icons.star, color: Colors.amber),
          title: const Text('Rate Us'),
          onTap: () {},
        ),
        ListTile(
          leading: const Icon(Icons.info, color: Colors.grey),
          title: const Text('About JK MOVIES tz'),
          subtitle: const Text('Imeandaliwa kwa Flutter na Admin Backend'),
          onTap: () {},
        ),
      ],
    );
  }
}

class AdminPanelScreen extends StatefulWidget {
  const AdminPanelScreen({super.key});

  @override
  State<AdminPanelScreen> createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen> {
  final _titleController = TextEditingController();
  final _urlController = TextEditingController();
  final _imageController = TextEditingController();
  String _selectedCat = 'DJ ALLY';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('JK MOVIES tz - Admin Control Panel'),
        backgroundColor: Colors.red[800],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text(
              'Weka Movie Mpya (Google Drive / Cloudflare)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Jina la Movie (Title)', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _urlController,
              decoration: const InputDecoration(labelText: 'Google Drive / Cloudflare Link', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _imageController,
              decoration: const InputDecoration(labelText: 'Poster Image URL', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _selectedCat,
              items: ['DJ ALLY', 'DJ BABU', 'DJ BLACK', 'DJ BRYTON', 'DJ HERO', 'DJ M', 'DJ MACK', 'DJ MJUKUU', 'DJ MSATI', 'DJ MURPHY', 'DJ MECK', 'DJ NASRY', 'DJ OMMY', 'DJ RAJA', 'DJ SHIZZOL', 'DJ SIX 6', 'DJ SKILLS', 'DJ SMART', 'DJ VASCO', 'RAMSO DJ', 'SEASON ZOTE', 'SINGLE ZOTE']
                  .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                  .toList(),
              onChanged: (val) => setState(() => _selectedCat = val!),
              decoration: const InputDecoration(labelText: 'Category', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red[800], padding: const EdgeInsets.all(14)),
              icon: const Icon(Icons.add_circle, color: Colors.white),
              label: const Text('Chapisha / Publish (Admin Approved)', style: TextStyle(color: Colors.white, fontSize: 16)),
              onPressed: () {
                if (_titleContentValid()) {
                  appState.addMovie({
                    'title': _titleController.text,
                    'category': _selectedCat,
                    'url': _urlController.text,
                    'image': _imageController.text.isNotEmpty ? _imageController.text : 'https://picsum.photos/seed/newmovie/600/400',
                    'approved': true,
                    'source': 'Admin Upload'
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Movie imewekwa na kuruhusiwa na Admin mafanikio!')),
                  );
                }
              },
            ),
            const Divider(height: 40),
            const Text(
              'Taarifa za Malipo & Kujiunga na Group:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const Text('Lipa No: 19382338 | Simu: 0775 477047 (TZS 5,000 / mwezi)'),
            const Text('Google Drive Link Kuu:\nhttps://drive.google.com/drive/folders/1y5y-5_Pz0YyNWOxng1095L9R9YFp6htv', style: TextStyle(color: Colors.blue)),
          ],
        ),
      ),
    );
  }

  bool _titleContentValid() {
    return _titleController.text.isNotEmpty && _urlController.text.isNotEmpty;
  }
}