import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Unganisha Supabase
  await Supabase.initialize(
    url: 'https://ucgjevsyxkshmlwlceeb.supabase.co',
    anonKey: 'sb_publishable_nGjxHryRrbhydQTA3nRSA', // Weka ufunguo wako kamili
  );

  runApp(const MoviesApp());
}

class MoviesApp extends StatelessWidget {
  const MoviesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Movies TZ',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF121212),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1F1F1F),
          elevation: 0,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final supabase = Supabase.instance.client;

  // Makundi safi bila alama zozote
  final List<String> categories = [
    'ZOTE',
    'KIHINDI',
    'NIGERIA',
    'CARTOON',
    'SINGLE ZOTE',
    'Dj Mjukuu',
    'Dj ALLY',
    'Dj Babu',
    'Dj Black',
    'Dj BRYTON',
    'Dj Hero',
    'Dj M',
    'Dj MACK',
    'Dj Msati',
    'Dj murphy',
    'Dj Nasry',
    'Dj Ommy',
    'Dj Raja',
    'Dj Shizzol',
    'Dj Six 6',
    'Dj SKILLS',
    'Dj SMART',
    'Dj VASCO',
    'Ramso Dj',
  ];

  String selectedCategory = 'ZOTE';

  Future<List<Map<String, dynamic>>> fetchMovies() async {
    if (selectedCategory == 'ZOTE') {
      final data = await supabase
          .from('movies')
          .select()
          .order('created_at', ascending: false);
      return List<Map<String, dynamic>>.from(data);
    } else {
      final data = await supabase
          .from('movies')
          .select()
          .eq('category', selectedCategory)
          .order('created_at', ascending: false);
      return List<Map<String, dynamic>>.from(data);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movies TZ - Streaming'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            height: 55,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                final isSelected = category == selectedCategory;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6.0),
                  child: ChoiceChip(
                    label: Text(
                      category,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.grey[400],
                        fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    selected: isSelected,
                    selectedColor: Colors.redAccent,
                    backgroundColor: const Color(0xFF2C2C2C),
                    onSelected: (bool selected) {
                      if (selected) {
                        setState(() {
                          selectedCategory = category;
                        });
                      }
                    },
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: fetchMovies(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text('Hitilafu: ${snapshot.error}'),
                  );
                }

                final movies = snapshot.data ?? [];

                if (movies.isEmpty) {
                  return Center(
                    child: Text(
                      'Hakuna muvi zilizopatikana kwenye $selectedCategory',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  );
                }

                return GridView.builder(
                  padding: const EdgeInsets.all(12),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.68,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: movies.length,
                  itemBuilder: (context, index) {
                    final movie = movies[index];
                    return Card(
                      color: const Color(0xFF1E1E1E),
                      clipBehavior: Clip.antiAlias,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: movie['poster_url'] != null
                                ? Image.network(
                              movie['poster_url'],
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder:
                                  (context, error, stackTrace) =>
                              const Center(
                                child: Icon(Icons.broken_image, size: 50),
                              ),
                            )
                                : const Center(
                              child: Icon(Icons.movie, size: 50),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              movie['title'] ?? 'Bila Jina',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}