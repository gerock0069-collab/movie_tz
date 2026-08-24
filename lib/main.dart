import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:marquee/marquee.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const DJMovieApp());
}

// -------------------------------------------------------------
// 1. MODEL & GOOGLE DRIVE SERVICE
// -------------------------------------------------------------
class DriveItem {
  final String id;
  final String name;
  final String mimeType;
  final bool isFolder;

  DriveItem({
    required this.id,
    required this.name,
    required this.mimeType,
    required this.isFolder,
  });

  factory DriveItem.fromJson(Map<String, dynamic> json) {
    return DriveItem(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      mimeType: json['mimeType'] ?? '',
      isFolder: json['mimeType'] == 'application/vnd.google-apps.folder',
    );
  }

  String get downloadUrl => 'https://drive.google.com/uc?export=download&id=$id';
}

class GoogleDriveService {
  static const String apiKey = 'WEKA_API_KEY_YAKO_HAPA';

  static Future<List<DriveItem>> fetchFolderContents(String folderId) async {
    final String url =
        'https://www.googleapis.com/drive/v3/files?q=%27$folderId%27+in+parents+and+trashed=false&fields=files(id,name,mimeType)&key=$apiKey';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List files = data['files'];
        return files.map((file) => DriveItem.fromJson(file)).toList();
      }
    } catch (e) {
      debugPrint('Drive fetch error: $e');
    }
    return [];
  }
}

// -------------------------------------------------------------
// 2. MAIN APPLICATION ROOT (THEME & STATE)
// -------------------------------------------------------------
class DJMovieApp extends StatefulWidget {
  const DJMovieApp({super.key});

  @override
  State<DJMovieApp> createState() => _DJMovieAppState();
}

class _DJMovieAppState extends State<DJMovieApp> {
  ThemeMode _themeMode = ThemeMode.dark;
  String _language = 'Kiswahili';

  void toggleTheme(bool isDark) {
    setState(() {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    });
  }

  void changeLanguage(String lang) {
    setState(() {
      _language = lang;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DJ Movies Tanzania',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF3F4F6),
        primaryColor: Colors.deepPurple,
        cardColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF111115),
        cardColor: const Color(0xFF1E1E24),
        primaryColor: Colors.deepPurpleAccent,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF111115),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      home: MainNavigation(
        currentLanguage: _language,
        onThemeChanged: toggleTheme,
        onLangChanged: changeLanguage,
      ),
    );
  }
}

// -------------------------------------------------------------
// 3. BOTTOM NAVIGATION BAR CONTROLLER
// -------------------------------------------------------------
class MainNavigation extends StatefulWidget {
  final String currentLanguage;
  final Function(bool) onThemeChanged;
  final Function(String) onLangChanged;

  const MainNavigation({
    super.key,
    required this.currentLanguage,
    required this.onThemeChanged,
    required this.onLangChanged,
  });

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      HomeScreen(lang: widget.currentLanguage),
      const CategoryScreen(),
      FavoriteScreen(lang: widget.currentLanguage),
      SettingScreen(
        lang: widget.currentLanguage,
        onThemeChanged: widget.onThemeChanged,
        onLangChanged: widget.onLangChanged,
      ),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) => setState(() => _currentIndex = index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.folder_outlined),
            selectedIcon: Icon(Icons.folder),
            label: 'Category',
          ),
          NavigationDestination(
            icon: Icon(Icons.star_border),
            selectedIcon: Icon(Icons.star),
            label: 'Favorites',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

// -------------------------------------------------------------
// 4. SCREEN 1: HOME (MARQUEE, PAYMENTS & RELEASES)
// -------------------------------------------------------------
class HomeScreen extends StatelessWidget {
  final String lang;
  const HomeScreen({super.key, required this.lang});

  void _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isSwahili = lang == 'Kiswahili';

    return Scaffold(
      appBar: AppBar(
        title: Text(isSwahili ? 'DJ Movies Tanzania' : 'DJ Movies Hub'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tangazo Linalotembea (Marquee)
            Container(
              height: 35,
              color: Colors.deepPurple.withOpacity(0.15),
              child: Marquee(
                text: isSwahili
                    ? '🔥 Karibu! Muvi mpya za Dj Mjukuu, Dj Ally, Dj Mack, Dj Murphy zimeongezwa! Ep 1 hadi 8 ni Bure! Kujiunga VIP Lipia kupitia namba ya malipo hapa chini 🔥'
                    : '🔥 Welcome! New movies updated. Ep 1 to 8 are Free! Check payment details below for VIP Access 🔥',
                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.orangeAccent),
                scrollAxis: Axis.horizontal,
                velocity: 45.0,
                blankSpace: 35.0,
              ),
            ),

            // Kadi ya Malipo / VIP
            Container(
              margin: const EdgeInsets.all(12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.purple, Colors.deepPurpleAccent],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.verified, color: Colors.amber),
                      const SizedBox(width: 8),
                      Text(
                        isSwahili ? 'Jinsi ya Kulipia VIP' : 'How to Pay for VIP',
                        style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    isSwahili
                        ? '1. Lipia kupitia M-Pesa / TigoPesa / Airtel Money\n2. Lipa Namba: 5522334 (DJ Movies Tanzania)\n3. Tuma Screenshot WhatsApp (07XXXXXXXX) ili ufunguliwe Season nzima bila kikomo.'
                        : '1. Pay via Mobile Money (Till: 5522334)\n2. Send verification screenshot to WhatsApp to unlock all VIP episodes.',
                    style: const TextStyle(color: Colors.white70, fontSize: 13, height: 1.4),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.deepPurple,
                    ),
                    icon: const Icon(Icons.chat),
                    label: Text(isSwahili ? 'Tuma Muamala WhatsApp' : 'Verify Payment'),
                    onPressed: () => _openUrl('https://wa.me/255700000000'),
                  )
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              child: Text(
                isSwahili ? 'Muvi Mpya Zilizotoka' : 'Latest Releases',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),

            // Grid ya Movies
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: 4,
              itemBuilder: (context, index) {
                return Card(
                  clipBehavior: Clip.antiAlias,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Container(
                          color: Colors.grey.shade900,
                          child: const Center(child: Icon(Icons.movie_creation_outlined, size: 48, color: Colors.grey)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Season Part ${index + 1}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                            const SizedBox(height: 2),
                            const Text('DJ Ally • Kiswahili Audio', style: TextStyle(fontSize: 11, color: Colors.grey)),
                          ],
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

// -------------------------------------------------------------
// 5. SCREEN 2: CATEGORY (MPANGILIO WA MA-DJ TOKA KWENYE PICHA)
// -------------------------------------------------------------
class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  final List<Map<String, dynamic>> djCategories = const [
    {"name": ",,,+SINGLE ZOTE", "color": Colors.blueGrey, "date": "Modified 7:31 PM"},
    {"name": ",,Dj Mjukuu", "color": Colors.lightGreen, "date": "Modified Aug 2"},
    {"name": "\"Dj ALLY", "color": Colors.green, "date": "Modified Aug 13"},
    {"name": "\"Dj Babu", "color": Colors.deepOrange, "date": "Modified Aug 13"},
    {"name": "\"Dj Black", "color": Colors.purple, "date": "Modified Aug 13"},
    {"name": "\"Dj BRYTON", "color": Colors.teal, "date": "Modified Aug 13"},
    {"name": "\"Dj Hero", "color": Colors.blue, "date": "Modified Aug 13"},
    {"name": "\"Dj M", "color": Colors.amber, "date": "Modified Aug 13"},
    {"name": "*Dj MACK", "color": Colors.orange, "date": "Modified Aug 13"},
    {"name": "*Dj Msati", "color": Colors.redAccent, "date": "Modified Aug 13"},
    {"name": "*Dj murphy", "color": Colors.purpleAccent, "date": "Modified Aug 13"},
    {"name": "*Dj Nasry", "color": Colors.indigo, "date": "Modified Aug 13"},
    {"name": "*Dj Ommy", "color": Colors.brown, "date": "Modified Aug 13"},
    {"name": "*Dj Raja", "color": Colors.lime, "date": "Modified Aug 13"},
    {"name": "*Dj Shizzol", "color": Colors.deepOrangeAccent, "date": "Modified Aug 13"},
    {"name": "*Dj Six 6", "color": Colors.blueGrey, "date": "Modified Aug 13"},
    {"name": "*Dj SKILLS", "color": Colors.greenAccent, "date": "Modified Aug 13"},
    {"name": "*Dj SMART", "color": Colors.grey, "date": "Modified Aug 13"},
    {"name": "*Dj VASCO", "color": Colors.brown, "date": "Modified Aug 13"},
    {"name": "*Ramso Dj", "color": Colors.lightBlue, "date": "Modified Aug 13"},
    {"name": "ZOTE?", "color": Colors.grey, "date": "Modified Aug 13"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SEASON ZOTE', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        actions: [
          IconButton(icon: const Icon(Icons.auto_awesome), onPressed: () {}),
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
        ],
      ),
      body: ListView.separated(
        itemCount: djCategories.length,
        separatorBuilder: (context, index) => const Divider(height: 1, color: Colors.white10),
        itemBuilder: (context, index) {
          final item = djCategories[index];
          return ListTile(
            leading: Stack(
              alignment: Alignment.center,
              children: [
                Icon(Icons.folder, color: item["color"] as Color, size: 40),
                const Positioned(
                  bottom: 10,
                  child: Icon(Icons.person, size: 14, color: Colors.white70),
                )
              ],
            ),
            title: Text(item["name"], style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
            subtitle: Text(item["date"], style: const TextStyle(fontSize: 11, color: Colors.grey)),
            trailing: const Icon(Icons.more_vert, size: 18, color: Colors.grey),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EpisodesListScreen(categoryName: item["name"]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// -------------------------------------------------------------
// 6. SCREEN: EPISODES VIEW (EP 1-8 BURE + DOWNLOAD BUTTON)
// -------------------------------------------------------------
class EpisodesListScreen extends StatelessWidget {
  final String categoryName;
  const EpisodesListScreen({super.key, required this.categoryName});

  void _handleAction(BuildContext context, int epNumber, String url) async {
    if (epNumber > 8) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('VIP Access Only 🔒'),
          content: const Text('Episode 1 hadi 8 ni BURE. Kuanzia Episode 9 kuendelea zimefungwa kwa wanachama wa VIP. Tafadhali wasiliana nasi WhatsApp au sehemu ya Home ili kulipia.'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Sawa')),
          ],
        ),
      );
      return;
    }

    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(categoryName)),
      body: ListView.builder(
        itemCount: 20,
        itemBuilder: (context, index) {
          int ep = index + 1;
          bool isFree = ep <= 8;

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: isFree ? Colors.green.shade700 : Colors.red.shade900,
                child: Text('$ep', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
              title: Text('$categoryName - Ep $ep', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
              subtitle: Text(
                isFree ? 'BURE (Free Episode)' : 'VIP ONLY 🔒',
                style: TextStyle(color: isFree ? Colors.green : Colors.redAccent, fontSize: 12),
              ),
              trailing: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isFree ? Colors.deepPurple : Colors.grey.shade800,
                  foregroundColor: Colors.white,
                ),
                icon: Icon(isFree ? Icons.download : Icons.lock, size: 16),
                label: Text(isFree ? 'Download' : 'Locked'),
                onPressed: () {
                  _handleAction(context, ep, 'https://drive.google.com/drive/folders/1y5y-5_Pz0YyNWOxng1095L9R9YFp6htv');
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

// -------------------------------------------------------------
// 7. SCREEN 3: FAVORITES
// -------------------------------------------------------------
class FavoriteScreen extends StatelessWidget {
  final String lang;
  const FavoriteScreen({super.key, required this.lang});

  @override
  Widget build(BuildContext context) {
    bool isSwahili = lang == 'Kiswahili';

    return Scaffold(
      appBar: AppBar(title: Text(isSwahili ? 'Vipendwa Vyangu' : 'My Favorites')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.star_border, size: 64, color: Colors.grey),
            const SizedBox(height: 10),
            Text(
              isSwahili ? 'Hakuna movie zilizohifadhiwa hapa bado.' : 'No favorite movies added yet.',
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

// -------------------------------------------------------------
// 8. SCREEN 4: SETTINGS (DARK MODE, LANGUAGE, LINKS)
// -------------------------------------------------------------
class SettingScreen extends StatefulWidget {
  final String lang;
  final Function(bool) onThemeChanged;
  final Function(String) onLangChanged;

  const SettingScreen({
    super.key,
    required this.lang,
    required this.onThemeChanged,
    required this.onLangChanged,
  });

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool _isDark = true;

  void _launchUrl(String urlString) async {
    final uri = Uri.parse(urlString);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isSwahili = widget.lang == 'Kiswahili';

    return Scaffold(
      appBar: AppBar(title: Text(isSwahili ? 'Mipangilio' : 'Settings')),
      body: ListView(
        children: [
          // Theme Switch
          SwitchListTile(
            secondary: const Icon(Icons.dark_mode),
            title: Text(isSwahili ? 'Muonekano wa Giza (Dark Mode)' : 'Dark Mode'),
            value: _isDark,
            onChanged: (val) {
              setState(() => _isDark = val);
              widget.onThemeChanged(val);
            },
          ),

          // Lugha
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(isSwahili ? 'Lugha / Language' : 'Language'),
            subtitle: Text(widget.lang),
            trailing: DropdownButton<String>(
              value: widget.lang,
              underline: const SizedBox(),
              items: const [
                DropdownMenuItem(value: 'Kiswahili', child: Text('Kiswahili')),
                DropdownMenuItem(value: 'English', child: Text('English')),
              ],
              onChanged: (value) {
                if (value != null) widget.onLangChanged(value);
              },
            ),
          ),
          const Divider(),

          // Viunganishi vya Nje
          ListTile(
            leading: const Icon(Icons.cloud_download, color: Colors.blueAccent),
            title: const Text('Google Drive Hub'),
            subtitle: const Text('Fungua folder la Google Drive moja kwa moja'),
            onTap: () => _launchUrl('https://drive.google.com/drive/folders/1y5y-5_Pz0YyNWOxng1095L9R9YFp6htv'),
          ),
          ListTile(
            leading: const Icon(Icons.video_library, color: Colors.redAccent),
            title: const Text('YouTube Channel'),
            subtitle: const Text('Angalia video mpya na matangazo'),
            onTap: () => _launchUrl('https://youtube.com'),
          ),
          ListTile(
            leading: const Icon(Icons.chat, color: Colors.green),
            title: const Text('WhatsApp / Mawasiliano'),
            subtitle: const Text('Msaada, maoni na kuwezeshwa VIP'),
            onTap: () => _launchUrl('https://wa.me/255700000000'),
          ),
          const Divider(),

          // About & Rating
          ListTile(
            leading: const Icon(Icons.star_rate, color: Colors.amber),
            title: Text(isSwahili ? 'Tukadirie (Rate Us)' : 'Rate Us'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text(isSwahili ? 'Kuhusu App (About)' : 'About App'),
            subtitle: const Text('Version 1.0.0 • DJ Tanzanian Hub'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}