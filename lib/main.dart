import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const JKMoviesApp());
}

class JKMoviesApp extends StatefulWidget {
  const JKMoviesApp({super.key});

  @override
  State<JKMoviesApp> createState() => _JKMoviesAppState();
}

class _JKMoviesAppState extends State<JKMoviesApp> {
  ThemeMode _themeMode = ThemeMode.dark;
  Locale _locale = const Locale('sw');

  void _toggleTheme(bool isDark) {
    setState(() {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    });
  }

  void _changeLanguage(String langCode) {
    setState(() {
      _locale = Locale(langCode);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JK MOVIES tz',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.red,
        scaffoldBackgroundColor: Colors.white,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.red,
        scaffoldBackgroundColor: const Color(0xFF121212),
      ),
      locale: _locale,
      home: MainScreen(
        onToggleTheme: _toggleTheme,
        onChangeLanguage: _changeLanguage,
        isDark: _themeMode == ThemeMode.dark,
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  final Function(bool) onToggleTheme;
  final Function(String) onChangeLanguage;
  final bool isDark;

  const MainScreen({
    super.key,
    required this.onToggleTheme,
    required this.onChangeLanguage,
    required this.isDark,
  });

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  final String adminEmail = "gerock0069@gmail.com";

  final List<String> categories = [
    "DJ ALLY", "DJ BABU", "DJ BLACK", "DJ BRYTON", "DJ HERO",
    "DJ M", "DJ MACK", "DJ MJUKUU", "DJ MSATI", "DJ MURPHY",
    "DJ MECK", "DJ NASRY", "DJ OMMY", "DJ RAJA", "DJ SHIZZOL",
    "DJ SIX 6", "DJ SKILLS", "DJ SMART", "DJ VASCO", "RAMSO DJ",
    "SEASON ZOTE", "SINGLE ZOTE"
  ];

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      HomeScreen(categories: categories),
      CategoriesScreen(categories: categories),
      const FavoritesScreen(),
      SettingsScreen(
        onToggleTheme: widget.onToggleTheme,
        onChangeLanguage: widget.onChangeLanguage,
        isDark: widget.isDark,
        adminEmail: adminEmail,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('JK MOVIES tz', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.redAccent)),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => showSearch(context: context, delegate: MovieSearchDelegate()),
          ),
          IconButton(
            icon: const Icon(Icons.admin_panel_settings),
            onPressed: () => _handleAdminLogin(context),
          ),
        ],
      ),
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.redAccent,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.category), label: 'Category'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorite'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }

  void _handleAdminLogin(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && user.email == adminEmail) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => AdminPanel(categories: categories)));
    } else {
      _showLoginDialog(context);
    }
  }

  void _showLoginDialog(BuildContext context) {
    final emailController = TextEditingController(text: adminEmail);
    final passController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Admin Login'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: emailController, decoration: const InputDecoration(labelText: 'Email')),
            TextField(controller: passController, decoration: const InputDecoration(labelText: 'Password'), obscureText: true),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Ghairi')),
          ElevatedButton(
            onPressed: () async {
              try {
                await FirebaseAuth.instance.signInWithEmailAndPassword(
                  email: emailController.text.trim(),
                  password: passController.text.trim(),
                );
                Navigator.pop(ctx);
                if (emailController.text.trim() == adminEmail) {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => AdminPanel(categories: categories)));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Huna ruhusa ya Admin!')));
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Hitilafu: ${e.toString()}')));
              }
            },
            child: const Text('Ingia'),
          ),
        ],
      ),
    );
  }
}

// ----------------- HOME SCREEN -----------------
class HomeScreen extends StatelessWidget {
  final List<String> categories;
  const HomeScreen({super.key, required this.categories});

  Future<void> _downloadMovie(BuildContext context, String url, String title) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final savePath = "${dir.path}/$title.mp4";

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Inaanza kupakua $title...')),
      );

      await Dio().download(url, savePath);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Imekamilika kuhifadhi: $savePath')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Imeshindikana kupakua: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        // Trailer / Banner Carousel (Inabadilika badika kwa mtindo wa bango)
        Container(
          height: 200,
          margin: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.grey[900],
            image: const DecorationImage(
              image: NetworkImage('https://via.placeholder.com/600x300.png?text=JK+MOVIES+TZ+TRAILER'),
              fit: BoxFit.cover,
            ),
          ),
          child: const Center(
            child: Icon(Icons.play_circle_fill, size: 60, color: Colors.redAccent),
          ),
        ),

        // Quick Categories Bar
        SizedBox(
          height: 45,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (ctx, i) => Container(
              margin: const EdgeInsets.symmetric(horizontal: 6),
              child: Chip(
                label: Text(categories[i], style: const TextStyle(fontSize: 12)),
                backgroundColor: Colors.redAccent.withOpacity(0.2),
              ),
            ),
          ),
        ),

        const Padding(
          padding: EdgeInsets.all(12.0),
          child: Text('Movies Mpya', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),

        // Movie List
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('movies').orderBy('createdAt', descending: true).snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
            final docs = snapshot.data!.docs;

            if (docs.isEmpty) {
              const Center(child: Padding(padding: EdgeInsets.all(20.0), child: Text('Hakuna movies kwa sasa.')));
            }

            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: docs.length,
              itemBuilder: (ctx, i) {
                final movie = docs[i].data() as Map<String, dynamic>;
                final bool isVip = movie['isVip'] ?? false;

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    leading: Container(
                      width: 50,
                      height: 70,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: Colors.grey[800],
                        image: movie['posterUrl'] != null && movie['posterUrl'].isNotEmpty
                            ? DecorationImage(image: NetworkImage(movie['posterUrl']), fit: BoxFit.cover)
                            : null,
                      ),
                      child: movie['posterUrl'] == null || movie['posterUrl'].isEmpty
                          ? const Icon(Icons.movie, color: Colors.white70)
                          : null,
                    ),
                    title: Text(movie['title'] ?? 'No Title', style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Row(
                      children: [
                        Text(movie['category'] ?? ''),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: isVip ? Colors.amber : Colors.green,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            isVip ? 'VIP (Drive/Cloudflare)' : 'BURE (My Files)',
                            style: const TextStyle(fontSize: 9, color: Colors.black, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.play_arrow, color: Colors.redAccent),
                          onPressed: () {
                            // Angalia kama ni VIP ili udhibiti ufikiaji
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Inafungua: ${movie['title']}')),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.file_download, color: Colors.white70),
                          onPressed: () => _downloadMovie(context, movie['downloadUrl'] ?? '', movie['title'] ?? 'Movie'),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}

// ----------------- CATEGORIES SCREEN -----------------
class CategoriesScreen extends StatelessWidget {
  final List<String> categories;
  const CategoriesScreen({super.key, required this.categories});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.9,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: categories.length,
      itemBuilder: (ctx, i) {
        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 24,
                backgroundColor: Colors.redAccent,
                child: Icon(Icons.movie_filter, color: Colors.white, size: 24),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Text(
                  categories[i],
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ----------------- ADMIN PANEL -----------------
class AdminPanel extends StatefulWidget {
  final List<String> categories;
  const AdminPanel({super.key, required this.categories});

  @override
  State<AdminPanel> createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  final _titleController = TextEditingController();
  final _posterController = TextEditingController();
  final _streamUrlController = TextEditingController();
  final _downloadUrlController = TextEditingController();
  final _userEmailController = TextEditingController();

  late String _selectedCategory;
  bool _isVip = false;

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.categories.first;
  }

  void _uploadMovie() async {
    if (_titleController.text.isEmpty || _streamUrlController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Jaza jina na URL ya movie!')));
      return;
    }

    await FirebaseFirestore.instance.collection('movies').add({
      'title': _titleController.text.trim(),
      'category': _selectedCategory,
      'posterUrl': _posterController.text.trim(),
      'streamUrl': _streamUrlController.text.trim(),
      'downloadUrl': _downloadUrlController.text.trim(),
      'isVip': _isVip, // true = Google Drive/Cloudflare (VIP), false = My Files (Bure)
      'createdAt': FieldValue.serverTimestamp(),
    });

    _titleController.clear();
    _posterController.clear();
    _streamUrlController.clear();
    _downloadUrlController.clear();

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Movie imewekwa kikamilifu!')));
  }

  void _approveUserVip() async {
    if (_userEmailController.text.isEmpty) return;

    final query = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: _userEmailController.text.trim())
        .get();

    for (var doc in query.docs) {
      await doc.reference.update({'isVip': true});
    }

    _userEmailController.clear();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('VIP imewashwa kwa mtumiaji huyu!')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('JK Movies Admin Dashboard')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Ongeza Movie Mpya', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.redAccent)),
            const SizedBox(height: 10),
            TextField(controller: _titleController, decoration: const InputDecoration(labelText: 'Jina la Movie')),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: const InputDecoration(labelText: 'Category'),
              items: widget.categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
              onChanged: (val) => setState(() => _selectedCategory = val!),
            ),
            TextField(controller: _posterController, decoration: const InputDecoration(labelText: 'Poster Image URL')),
            TextField(controller: _streamUrlController, decoration: const InputDecoration(labelText: 'Stream URL (Google Drive / Cloudflare / My Files)')),
            TextField(controller: _downloadUrlController, decoration: const InputDecoration(labelText: 'Download Link (Inayoonekana na Download Button)')),
            SwitchListTile(
              title: const Text('Weka kama VIP (Google Drive / Cloudflare)'),
              subtitle: const Text('Zima ikiwa ni ya BURE (My Files)'),
              value: _isVip,
              onChanged: (v) => setState(() => _isVip = v),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
              onPressed: _uploadMovie,
              child: const Text('Pakia Movie (Upload)'),
            ),
            const Divider(height: 40),
            const Text('Ruhusu Aliyelipia (VIP Access)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green)),
            const SizedBox(height: 10),
            TextField(controller: _userEmailController, decoration: const InputDecoration(labelText: 'Weka Email ya Mtumiaji')),
            const SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              onPressed: _approveUserVip,
              child: const Text('Washa VIP ya Mwezi (5,000 Tsh)'),
            ),
          ],
        ),
      ),
    );
  }
}

// ----------------- SETTINGS & OTHER SCREENS -----------------
class SettingsScreen extends StatelessWidget {
  final Function(bool) onToggleTheme;
  final Function(String) onChangeLanguage;
  final bool isDark;
  final String adminEmail;

  const SettingsScreen({
    super.key,
    required this.onToggleTheme,
    required this.onChangeLanguage,
    required this.isDark,
    required this.adminEmail,
  });

  void _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        // Sehemu ya Malipo na Group
        Card(
          color: Colors.redAccent.withOpacity(0.1),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: const Padding(
            padding: EdgeInsets.all(14.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'JIUNGE NA VIP GROUP (MOVIES 5000+ MWEZI)',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 6),
                Text(
                  '• Gharama: Tsh 5,000 / Mwezi',
                  style: TextStyle(fontSize: 14),
                ),
                Text(
                  '• Lipa Namba: 19382338',
                  style: TextStyle(fontSize: 14),
                ),
                Text(
                  '• Namba ya Simu: 0775 477047',
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        SwitchListTile(
          title: const Text('Dark Mode / Light Mode'),
          value: isDark,
          onChanged: onToggleTheme,
        ),
        ListTile(
          leading: const Icon(Icons.language),
          title: const Text('Lugha (Language)'),
          trailing: DropdownButton<String>(
            value: 'sw',
            underline: const SizedBox(),
            items: const [
              DropdownMenuItem(value: 'sw', child: Text('Kiswahili')),
              DropdownMenuItem(value: 'en', child: Text('English')),
            ],
            onChanged: (val) {
              // Hapa unaweza kuweka logic ya kubadili lugha
            },
          ),
        ),
        ListTile(
          leading: const Icon(Icons.chat, color: Colors.green),
          title: const Text('WhatsApp Group / Support'),
          onTap: () => _launchUrl('https://wa.me/255775477047'),
        ),
        ListTile(
          leading: const Icon(Icons.video_library, color: Colors.red),
          title: const Text('YouTube Channel'),
          onTap: () => _launchUrl('https://youtube.com'),
        ),
        ListTile(
          leading: const Icon(Icons.star, color: Colors.amber),
          title: const Text('Rate Us'),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Asante kwa kukadiria app yetu!')));
          },
        ),
        ListTile(
          leading: const Icon(Icons.info_outline),
          title: const Text('About App'),
          subtitle: const Text('JK MOVIES tz v1.0.0 - Created for VIP & Free Movies'),
          onTap: () {},
        ),
      ],
    );
  }
}

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Orodha ya Movies Zilizopendwa (Favorites)', style: TextStyle(fontSize: 16)),
    );
  }
}

class MovieSearchDelegate extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) => [
    IconButton(icon: const Icon(Icons.clear), onPressed: () => query = ''),
  ];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
    icon: const Icon(Icons.arrow_back),
    onPressed: () => close(context, null),
  );

  @override
  Widget buildResults(BuildContext context) => _searchQuery();

  @override
  Widget buildSuggestions(BuildContext context) => _searchQuery();

  Widget _searchQuery() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('movies').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
        final results = snapshot.data!.docs.where((doc) {
          final title = doc['title'].toString().toLowerCase();
          return title.contains(query.toLowerCase());
        }).toList();

        return ListView.builder(
          itemCount: results.length,
          itemBuilder: (ctx, i) {
            final movie = results[i].data() as Map<String, dynamic>;
            return ListTile(
              title: Text(movie['title'] ?? ''),
              subtitle: Text(movie['category'] ?? ''),
              trailing: const Icon(Icons.play_arrow, color: Colors.redAccent),
            );
          },
        );
      },
    );
  }
}