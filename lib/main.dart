import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const BongoFlixApp());
}

class BongoFlixApp extends StatefulWidget {
  const BongoFlixApp({super.key});

  @override
  State<BongoFlixApp> createState() => _BongoFlixAppState();
}

class _BongoFlixAppState extends State<BongoFlixApp> {
  ThemeMode _themeMode = ThemeMode.dark;
  String _language = 'sw';

  void _toggleTheme(bool isDark) {
    setState(() {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    });
  }

  void _changeLanguage(String lang) {
    setState(() {
      _language = lang;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BongoFlix',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: const Color(0xFFE50914),
        scaffoldBackgroundColor: const Color(0xFFF3F4F6),
        appBarTheme: const AppBarTheme(backgroundColor: Colors.white, foregroundColor: Colors.black),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFFE50914),
        scaffoldBackgroundColor: const Color(0xFF141414),
        cardColor: const Color(0xFF1F1F1F),
        appBarTheme: const AppBarTheme(backgroundColor: Color(0xFF141414), foregroundColor: Colors.white),
      ),
      home: MainNavigation(
        themeMode: _themeMode,
        language: _language,
        onToggleTheme: _toggleTheme,
        onChangeLanguage: _changeLanguage,
      ),
    );
  }
}

class MovieModel {
  final int id;
  final String title;
  final String category;
  final String rating;
  final String year;
  final String poster;
  final String description;
  final int totalEpisodes;
  final String driveFolder;

  MovieModel({
    required this.id,
    required this.title,
    required this.category,
    required this.rating,
    required this.year,
    required this.poster,
    required this.description,
    required this.totalEpisodes,
    required this.driveFolder,
  });
}

final List<MovieModel> sampleMovies = [
  MovieModel(
    id: 1,
    title: "Sultan: Ushindi wa Damu",
    category: "Series za Kihindi",
    rating: "8.9",
    year: "2024",
    poster: "https://images.unsplash.com/photo-1536440136628-849c177e76a1?auto=format&fit=crop&w=500&q=80",
    description: "Hadithi ya mfalme Sultan aliyepigania haki ya taifa lake dhidi ya maadui.",
    totalEpisodes: 16,
    driveFolder: "https://drive.google.com/drive/folders/1y5y-5_Pz0YyNWOxng1095L9R9YFp6htv",
  ),
  MovieModel(
    id: 2,
    title: "Kijiji Cha Mauti",
    category: "Bongo Movie",
    rating: "9.2",
    year: "2025",
    poster: "https://images.unsplash.com/photo-1518709268805-4e9042af9f23?auto=format&fit=crop&w=500&q=80",
    description: "Bongo movie ya kusisimua inayohusu siri nzito iliyofichika kijijini.",
    totalEpisodes: 12,
    driveFolder: "https://drive.google.com/drive/folders/1y5y-5_Pz0YyNWOxng1095L9R9YFp6htv",
  ),
  MovieModel(
    id: 3,
    title: "Black Shadow: Revenge",
    category: "Action",
    rating: "8.5",
    year: "2024",
    poster: "https://images.unsplash.com/photo-1509198397868-475647b2a1e5?auto=format&fit=crop&w=500&q=80",
    description: "Kikosi maalum cha makomando kinachorudi kulipiza kisasi.",
    totalEpisodes: 10,
    driveFolder: "https://drive.google.com/drive/folders/1y5y-5_Pz0YyNWOxng1095L9R9YFp6htv",
  ),
];

class MainNavigation extends StatefulWidget {
  final ThemeMode themeMode;
  final String language;
  final Function(bool) onToggleTheme;
  final Function(String) onChangeLanguage;

  const MainNavigation({
    super.key,
    required this.themeMode,
    required this.language,
    required this.onToggleTheme,
    required this.onChangeLanguage,
  });

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;
  final Set<int> _favorites = {1};
  String _selectedCategory = 'All';

  void _toggleFavorite(int id) {
    setState(() {
      if (_favorites.contains(id)) {
        _favorites.remove(id);
      } else {
        _favorites.add(id);
      }
    });
  }

  void _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _showVipDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.workspace_premium, color: Colors.amber),
            SizedBox(width: 8),
            Text('LIPA VIP ACCESS'),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Ep 1 - 8 ni BURE. Kutazama Ep 9 hadi mwisho:'),
            SizedBox(height: 8),
            Text('• Wiki: TZS 3,000\n• Mwezi: TZS 8,000', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('Lipa Namba: 0755 000 000 (M-Pesa / Tigo)'),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Funga')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            onPressed: () => _openUrl('https://wa.me/255755000000?text=Habari%20nataka%20kujiunga%20VIP'),
            child: const Text('Thibitisha WhatsApp', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isSw = widget.language == 'sw';

    final pages = [
      _buildHome(isSw),
      _buildCategory(isSw),
      _buildFavorites(isSw),
      _buildSettings(isSw),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('BONGO FLIX', style: TextStyle(color: Color(0xFFE50914), fontWeight: FontWeight.bold)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE50914),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
              onPressed: _showVipDialog,
              icon: const Icon(Icons.workspace_premium, color: Colors.amber, size: 16),
              label: Text(isSw ? 'Lipa VIP' : 'VIP Access', style: const TextStyle(fontSize: 12, color: Colors.white)),
            ),
          )
        ],
      ),
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFFE50914),
        items: [
          BottomNavigationBarItem(icon: const Icon(Icons.home), label: isSw ? 'Home' : 'Home'),
          BottomNavigationBarItem(icon: const Icon(Icons.category), label: isSw ? 'Category' : 'Category'),
          BottomNavigationBarItem(icon: const Icon(Icons.bookmark), label: isSw ? 'Favorite' : 'Favorite'),
          BottomNavigationBarItem(icon: const Icon(Icons.settings), label: isSw ? 'Setting' : 'Setting'),
        ],
      ),
    );
  }

  Widget _buildHome(bool isSw) {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        // Marquee Ticker banner
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(color: const Color(0xFFE50914).withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
          child: Row(
            children: [
              const Icon(Icons.campaign, color: Color(0xFFE50914), size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  isSw ? '🔥 Muvi mpya zimeingia: Kijiji Cha Mauti, Sultan Season 3! Lipa TZS 3,000 kwa wiki.' : '🔥 New Movies: Check out latest releases!',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFFE50914)),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(isSw ? 'Muvi Zinazopendwa' : 'Trending Movies', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: sampleMovies.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.65, crossAxisSpacing: 10, mainAxisSpacing: 10),
          itemBuilder: (ctx, i) => _buildMovieCard(sampleMovies[i]),
        ),
        const SizedBox(height: 20),
        // Payment & Contact Section
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(12)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Jinsi Ya Kulipia & Mawasiliano', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFFE50914))),
              const SizedBox(height: 8),
              const Text('M-Pesa / Tigo / Airtel: 0755 000 000 (BONGO FLIX)', style: TextStyle(fontSize: 12)),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                onPressed: () => _openUrl('https://wa.me/255755000000?text=Habari%20nimefanya%20malipo'),
                icon: const Icon(Icons.chat, color: Colors.white),
                label: const Text('Wasiliana WhatsApp', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMovieCard(MovieModel movie) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (ctx) => DetailPage(movie: movie, onVipClick: _showVipDialog, onOpenUrl: _openUrl))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(movie.poster, fit: BoxFit.cover),
                  Positioned(
                    top: 6,
                    right: 6,
                    child: CircleAvatar(
                      backgroundColor: Colors.black54,
                      radius: 16,
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        icon: Icon(_favorites.contains(movie.id) ? Icons.bookmark : Icons.bookmark_border, color: const Color(0xFFE50914), size: 18),
                        onPressed: () => _toggleFavorite(movie.id),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(movie.category, style: const TextStyle(fontSize: 10, color: Colors.grey)),
                  Text(movie.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategory(bool isSw) {
    final categories = ['All', 'Action', 'Bongo Movie', 'Series za Kihindi', 'Series za Kifilipino'];
    final filtered = _selectedCategory == 'All'
        ? sampleMovies
        : sampleMovies.where((m) => m.category.toLowerCase() == _selectedCategory.toLowerCase()).toList();

    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        Text(isSw ? 'Makundi ya Muvi' : 'Categories', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        SizedBox(
          height: 40,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: categories.map((cat) => Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text(cat),
                selected: _selectedCategory == cat,
                selectedColor: const Color(0xFFE50914),
                onSelected: (bool selected) {
                  setState(() => _selectedCategory = cat);
                },
              ),
            )).toList(),
          ),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: filtered.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.65, crossAxisSpacing: 10, mainAxisSpacing: 10),
          itemBuilder: (ctx, i) => _buildMovieCard(filtered[i]),
        ),
      ],
    );
  }

  Widget _buildFavorites(bool isSw) {
    final favList = sampleMovies.where((m) => _favorites.contains(m.id)).toList();
    if (favList.isEmpty) {
      return Center(child: Text(isSw ? 'Huna muvi ulizohifadhi bado.' : 'No saved movies yet.'));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: favList.length,
      itemBuilder: (ctx, i) => ListTile(
        leading: Image.network(favList[i].poster, width: 45, fit: BoxFit.cover),
        title: Text(favList[i].title),
        subtitle: Text(favList[i].category),
        trailing: IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => _toggleFavorite(favList[i].id)),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (ctx) => DetailPage(movie: favList[i], onVipClick: _showVipDialog, onOpenUrl: _openUrl))),
      ),
    );
  }

  Widget _buildSettings(bool isSw) {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        SwitchListTile(
          secondary: const Icon(Icons.dark_mode, color: Color(0xFFE50914)),
          title: Text(isSw ? 'Dark Mode' : 'Dark Theme'),
          value: widget.themeMode == ThemeMode.dark,
          onChanged: widget.onToggleTheme,
        ),
        ListTile(
          leading: const Icon(Icons.language, color: Color(0xFFE50914)),
          title: Text(isSw ? 'Lugha (Language)' : 'Language'),
          trailing: DropdownButton<String>(
            value: widget.language,
            underline: const SizedBox(),
            items: const [
              DropdownMenuItem(value: 'sw', child: Text('Kiswahili')),
              DropdownMenuItem(value: 'en', child: Text('English')),
            ],
            onChanged: (val) => widget.onChangeLanguage(val ?? 'sw'),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.cloud, color: Colors.blue),
          title: const Text('Google Drive Folder'),
          onTap: () => _openUrl('https://drive.google.com/drive/folders/1y5y-5_Pz0YyNWOxng1095L9R9YFp6htv'),
        ),
        ListTile(
          leading: const Icon(Icons.video_library, color: Colors.red),
          title: const Text('YouTube Channel'),
          onTap: () => _openUrl('https://youtube.com'),
        ),
        ListTile(
          leading: const Icon(Icons.star, color: Colors.amber),
          title: Text(isSw ? 'Tupigie Kura (Rate Us)' : 'Rate Us'),
          onTap: () => _openUrl('https://play.google.com'),
        ),
      ],
    );
  }
}

class DetailPage extends StatelessWidget {
  final MovieModel movie;
  final VoidCallback onVipClick;
  final Function(String) onOpenUrl;

  const DetailPage({super.key, required this.movie, required this.onVipClick, required this.onOpenUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(movie.title)),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(movie.poster, height: 220, width: double.infinity, fit: BoxFit.cover),
          ),
          const SizedBox(height: 12),
          Text(movie.title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Text('${movie.category} • Rating: ${movie.rating}', style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 8),
          Text(movie.description),
          const SizedBox(height: 16),
          const Text('Episodes & Downloads', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: movie.totalEpisodes,
            itemBuilder: (ctx, idx) {
              final ep = idx + 1;
              final isFree = ep <= 8;
              return Card(
                child: ListTile(
                  leading: CircleAvatar(backgroundColor: isFree ? Colors.green.withOpacity(0.2) : Colors.amber.withOpacity(0.2), child: Text('$ep')),
                  title: Text('Episode $ep'),
                  subtitle: Text(isFree ? 'BURE (Free)' : 'VIP ONLY (Lipia)', style: TextStyle(color: isFree ? Colors.green : Colors.amber, fontWeight: FontWeight.bold)),
                  trailing: isFree
                      ? ElevatedButton(
                    onPressed: () => onOpenUrl(movie.driveFolder),
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFE50914)),
                    child: const Text('Download', style: TextStyle(color: Colors.white, fontSize: 12)),
                  )
                      : OutlinedButton(
                    onPressed: onVipClick,
                    child: const Text('Fungua', style: TextStyle(fontSize: 12)),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}