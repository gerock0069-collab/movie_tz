import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const JKMoviesApp());
}

class JKMoviesApp extends StatefulWidget {
  const JKMoviesApp({super.key});

  @override
  State<JKMoviesApp> createState() => _JKMoviesAppState();
}

class _JKMoviesAppState extends State<JKMoviesApp> {
  ThemeMode _themeMode = ThemeMode.dark;
  String _language = 'SW'; // 'SW' au 'EN'

  void toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    });
  }

  void toggleLanguage() {
    setState(() {
      _language = _language == 'SW' ? 'EN' : 'SW';
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JK MOVIES tz',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      theme: ThemeData(brightness: Brightness.light, primaryColor: Colors.redAccent),
      darkTheme: ThemeData(brightness: Brightness.dark, primaryColor: Colors.redAccent, scaffoldBackgroundColor: const Color(0xFF121212)),
      home: HomeScreen(
        onToggleTheme: toggleTheme,
        onToggleLang: toggleLanguage,
        language: _language,
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  final VoidCallback onToggleTheme;
  final VoidCallback onToggleLang;
  final String language;

  const HomeScreen({super.key, required this.onToggleTheme, required this.onToggleLang, required this.language});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<String> categories = [
    "DJ ALLY", "DJ BABU", "DJ BLACK", "DJ BRYTON", "DJ HERO", "DJ M",
    "DJ MACK", "DJ MJUKUU", "DJ MSATI", "DJ MURPHY", "DJ MECK", "DJ NASRY",
    "DJ OMMY", "DJ RAJA", "DJ SHIZZOL", "DJ SIX 6", "DJ SKILLS", "DJ SMART",
    "DJ VASCO", "RAMSO DJ", "SEASON ZOTE", "SINGLE ZOTE"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('JK MOVIES tz', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.redAccent)),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          IconButton(
            icon: const Icon(Icons.admin_panel_settings, color: Colors.amber),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AdminLoginScreen())),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => _openSettingsModal(context),
          ),
        ],
      ),
      body: _currentIndex == 0 ? _buildHomeTab() : _buildFavoritesTab(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.redAccent,
        onTap: (index) => setState(() => _currentIndex = index),
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.movie),
            label: widget.language == 'SW' ? 'Mwanzo' : 'Home',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.favorite),
            label: widget.language == 'SW' ? 'Vipendwa' : 'Favorites',
          ),
        ],
      ),
    );
  }

  Widget _buildHomeTab() {
    return ListView(
      children: [
        // Trailer / Banner Section
        Container(
          height: 180,
          margin: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            image: const DecorationImage(
              image: NetworkImage('https://picsum.photos/800/400'),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            alignment: Alignment.bottomLeft,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: const LinearGradient(begin: Alignment.bottomCenter, end: Alignment.topCenter, colors: [Colors.black87, Colors.transparent]),
            ),
            child: const Text('🔥 Latest Trailer & Updates', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ),

        // Malipo Banner
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: Colors.redAccent.withOpacity(0.2), borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.redAccent)),
          child: const Text(
            "VIP: Kujiunga Group TZS 5,000/= Mwezi Mzima.\nLipa Namba: 19382338 | Simu: 0775 477047",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),

        // Categories Grid
        const Padding(
          padding: EdgeInsets.all(12.0),
          child: Text('Ma-DJ & Categories', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 0.9,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            return Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              elevation: 4,
              child: InkWell(
                onTap: () {},
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.folder, size: 36, color: Colors.redAccent),
                    const SizedBox(height: 8),
                    Text(categories[index], textAlign: TextAlign.center, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildFavoritesTab() {
    return const Center(child: Text('Hakuna vipendwa vilivyohifadhiwa bado.'));
  }

  void _openSettingsModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(16),
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.brightness_6),
              title: Text(widget.language == 'SW' ? 'Badili Mandhari (Dark/Light)' : 'Toggle Dark Mode'),
              onTap: widget.onToggleTheme,
            ),
            ListTile(
              leading: const Icon(Icons.language),
              title: Text(widget.language == 'SW' ? 'Language: Kiswahili (Badili)' : 'Language: English (Switch)'),
              onTap: widget.onToggleLang,
            ),
            ListTile(
              leading: const Icon(Icons.cloud, color: Colors.blue),
              title: const Text('Google Drive / Cloudflare Storage'),
              onTap: () => launchUrl(Uri.parse('https://drive.google.com')),
            ),
            ListTile(
              leading: const Icon(Icons.video_library, color: Colors.red),
              title: const Text('YouTube Channel'),
              onTap: () => launchUrl(Uri.parse('https://youtube.com')),
            ),
            ListTile(
              leading: const Icon(Icons.chat, color: Colors.green),
              title: const Text('WhatsApp Admin (0775 477047)'),
              onTap: () => launchUrl(Uri.parse('https://wa.me/255775477047')),
            ),
          ],
        ),
      ),
    );
  }
}

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final TextEditingController _emailController = TextEditingController(text: 'gerock0069@gmail.com');
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Panel Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _emailController, decoration: const InputDecoration(labelText: 'Admin Email', border: OutlineInputBorder())),
            const SizedBox(height: 12),
            TextField(controller: _passwordController, obscureText: true, decoration: const InputDecoration(labelText: 'Password', border: OutlineInputBorder())),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
              onPressed: () {
                // Hapa unaweka Firebase Auth au validation
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const AdminDashboard()));
              },
              child: const Text('Ingia Admin Dashboard', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Movie Upload')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const TextField(decoration: InputDecoration(labelText: 'Jina la Movie', border: OutlineInputBorder())),
          const SizedBox(height: 12),
          const TextField(decoration: InputDecoration(labelText: 'Link ya Cloudflare / Direct Download', border: OutlineInputBorder())),
          const SizedBox(height: 12),
          const TextField(decoration: InputDecoration(labelText: 'Link ya Google Drive', border: OutlineInputBorder())),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            icon: const Icon(Icons.file_upload),
            label: const Text('Weka Movie Mkondoni'),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Movie imeongezwa kikamilifu!')));
            },
          ),
        ],
      ),
    );
  }
}