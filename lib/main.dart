import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

// 1. ORODHA YA MA-DJ NA MOVIES ZAO (Weka links zako hapa)
List<Map<String, dynamic>> localMovies = [
  {
    'id': 1,
    'title': 'Kisasi cha Damu',
    'dj': 'DJ Afro',
    'category': 'Action',
    'image_url': 'https://images.unsplash.com/photo-1536440136628-849c177e76a1?w=500',
    'video_url': 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
    'description': 'Filamu ya kusisimua iliyotafsiriwa na DJ Afro.',
    'is_trending': true,
  },
  {
    'id': 2,
    'title': 'Vita vya Majeshi',
    'dj': 'DJ Afro',
    'category': 'Action',
    'image_url': 'https://images.unsplash.com/photo-1518791841217-8f162f1e1131?w=500',
    'video_url': 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
    'description': 'Mapigano makali ya jeshi na uokoaji.',
    'is_trending': false,
  },
  {
    'id': 3,
    'title': 'Penzi la Siri',
    'dj': 'DJ Mack',
    'category': 'Mapenzi',
    'image_url': 'https://images.unsplash.com/photo-1485846234645-a62644f84728?w=500',
    'video_url': 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
    'description': 'Tamthilia ya mapenzi ya DJ Mack.',
    'is_trending': true,
  },
  {
    'id': 4,
    'title': 'Kipigo cha Mtaani',
    'dj': 'DJ Smith',
    'category': 'Action',
    'image_url': 'https://images.unsplash.com/photo-1517604931442-7e0c8ed2963c?w=500',
    'video_url': 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/TearsOfSteel.mp4',
    'description': 'Mapigano ya mtaani na mikakati mikubwa.',
    'is_trending': false,
  },
  {
    'id': 5,
    'title': 'Safari ya Hatari',
    'dj': 'DJ Murphy',
    'category': 'Adventure',
    'image_url': 'https://images.unsplash.com/photo-1478760329108-5c3ed9d495a0?w=500',
    'video_url': 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/Sintel.mp4',
    'description': 'Ujasiri na ugunduzi msituni.',
    'is_trending': true,
  },
];

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MoviesApp());
}

class MoviesApp extends StatelessWidget {
  const MoviesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movies TZ',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF121212),
        primaryColor: Colors.redAccent,
      ),
      home: const MainNavigationScreen(),
    );
  }
}

// Navigation Bar ya Chini
class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomeScreen(),
    const CategoriesScreen(),
    const Center(child: Text('Hakuna Vipakuliwa kwa sasa')),
    const Center(child: Text('Hakuna Vipendwa kwa sasa')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.black,
        selectedItemColor: Colors.redAccent,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Nyumbani'),
          BottomNavigationBarItem(icon: Icon(Icons.category), label: 'Ma-DJ / Kategoria'),
          BottomNavigationBarItem(icon: Icon(Icons.download), label: 'Vipakuliwa'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: 'Vipendwa'),
        ],
      ),
    );
  }
}

// 2. UKURASA WA NYUMBANI (HOME)
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedDj = 'WOTE';
  final List<String> djList = ['WOTE', 'DJ Afro', 'DJ Mack', 'DJ Smith', 'DJ Murphy', 'DJ Black'];

  List<Map<String, dynamic>> get filteredMovies {
    if (selectedDj == 'WOTE') return localMovies;
    return localMovies.where((m) => m['dj'] == selectedDj).toList();
  }

  @override
  Widget build(BuildContext context) {
    final featured = localMovies.firstWhere(
          (m) => m['is_trending'] == true,
      orElse: () => localMovies.first,
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          'MOVIES TZ',
          style: TextStyle(
            color: Colors.redAccent,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          IconButton(icon: const Icon(Icons.share), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Featured Movie Banner
            Stack(
              children: [
                Container(
                  height: 220,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(featured['image_url']),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  height: 220,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.8),
                        const Color(0xFF121212),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 16,
                  left: 16,
                  right: 16,
                  child: Row(
                    children: [
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PlayerScreen(
                                title: featured['title'],
                                videoUrl: featured['video_url'],
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.play_arrow),
                        label: const Text('Tazama Sasa'),
                      ),
                      const SizedBox(width: 12),
                      OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Colors.white70),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: () {},
                        icon: const Icon(Icons.add),
                        label: const Text('Orodha Yangu'),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Chagua DJ Wako',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 8),

            // Orodha ya Ma-DJ (Horizontal Scroll Buttons)
            SizedBox(
              height: 45,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: djList.length,
                itemBuilder: (context, index) {
                  final dj = djList[index];
                  final isSelected = selectedDj == dj;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ChoiceChip(
                      label: Text(dj),
                      selected: isSelected,
                      selectedColor: Colors.redAccent,
                      backgroundColor: Colors.grey[900],
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : Colors.grey[300],
                        fontWeight: FontWeight.bold,
                      ),
                      onSelected: (val) {
                        setState(() {
                          selectedDj = dj;
                        });
                      },
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Filamu za $selectedDj',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 12),

            // Orodha ya Movies
            SizedBox(
              height: 200,
              child: filteredMovies.isEmpty
                  ? const Center(child: Text('Hakuna filamu ya DJ huyu kwa sasa'))
                  : ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: filteredMovies.length,
                itemBuilder: (context, index) {
                  final movie = filteredMovies[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PlayerScreen(
                            title: movie['title'],
                            videoUrl: movie['video_url'],
                          ),
                        ),
                      );
                    },
                    child: Container(
                      width: 125,
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              movie['image_url'],
                              height: 150,
                              width: 125,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                    height: 150,
                                    width: 125,
                                    color: Colors.grey[850],
                                    child: const Icon(Icons.movie, color: Colors.white54),
                                  ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            movie['title'],
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                          ),
                          Text(
                            movie['dj'],
                            style: const TextStyle(fontSize: 11, color: Colors.redAccent),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 3. UKURASA MAALUM WA KATEGORIA / MA-DJ (CATEGORIES TAB)
class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  final List<String> djs = const [
    'DJ Afro',
    'DJ Mack',
    'DJ Smith',
    'DJ Murphy',
    'DJ Black',
    'DJ Sky',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orodha ya Ma-DJ'),
        backgroundColor: Colors.black,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.3,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: djs.length,
        itemBuilder: (context, index) {
          final djName = djs[index];
          final count = localMovies.where((m) => m['dj'] == djName).length;

          return InkWell(
            onTap: () {
              // Fungua list ya movies za DJ huyo
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DjMoviesScreen(djName: djName),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.redAccent.withOpacity(0.4)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.mic, color: Colors.redAccent, size: 36),
                  const SizedBox(height: 8),
                  Text(
                    djName,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '$count Movies',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// Ukurasa unaoonyesha movies zote za DJ uliyemchagua kwenye kategoria
class DjMoviesScreen extends StatelessWidget {
  final String djName;
  const DjMoviesScreen({super.key, required this.djName});

  @override
  Widget build(BuildContext context) {
    final djMovies = localMovies.where((m) => m['dj'] == djName).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Filamu za $djName'),
        backgroundColor: Colors.black,
      ),
      body: djMovies.isEmpty
          ? const Center(child: Text('Hakuna filamu zilizopakiwa za DJ huyu bado.'))
          : GridView.builder(
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.65,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: djMovies.length,
        itemBuilder: (context, index) {
          final movie = djMovies[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PlayerScreen(
                    title: movie['title'],
                    videoUrl: movie['video_url'],
                  ),
                ),
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      movie['image_url'],
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          Container(color: Colors.grey[850]),
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  movie['title'],
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// 4. SCREEN YA KUCHEZA VIDEO (PLAYER)
class PlayerScreen extends StatefulWidget {
  final String title;
  final String videoUrl;

  const PlayerScreen({super.key, required this.title, required this.videoUrl});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
      ..initialize().then((_) {
        setState(() {
          _isInitialized = true;
        });
        _controller.play();
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: _isInitialized
            ? AspectRatio(
          aspectRatio: _controller.value.aspectRatio,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              VideoPlayer(_controller),
              VideoProgressIndicator(_controller, allowScrubbing: true),
              Center(
                child: IconButton(
                  iconSize: 55,
                  icon: Icon(
                    _controller.value.isPlaying
                        ? Icons.pause_circle
                        : Icons.play_circle,
                    color: Colors.white.withOpacity(0.85),
                  ),
                  onPressed: () {
                    setState(() {
                      _controller.value.isPlaying
                          ? _controller.pause()
                          : _controller.play();
                    });
                  },
                ),
              ),
            ],
          ),
        )
            : const CircularProgressIndicator(color: Colors.redAccent),
      ),
    );
  }
}