import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'category_screen.dart';
import '../services/api_service.dart';
import 'profile_screen.dart';
import 'sign_in_screen.dart';
import 'settings_screen.dart';
import 'detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isSorted = false;
  List<dynamic> _categories = [];
  List<dynamic> _searchResults = [];
  List<Map<String, String>> favoriteMeals = [];

  bool _isLoading = false;

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  // Fungsi untuk mengambil kategori
  void _fetchCategories() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final categories = await ApiService.getCategories();
      setState(() {
        _categories = categories;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print("Error fetching categories: $e");
    }
  }

  // Fungsi untuk melakukan pencarian berdasarkan kata kunci
  void _searchMeal(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await ApiService.searchMeal(query);
      setState(() {
        _searchResults = response;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print("Error searching meals: $e");
    }
  }

  // Fungsi untuk mengurutkan berdasarkan nama
  void _sortCategories() {
    setState(() {
      if (_isSorted) {
        // Jika sudah disort, kembalikan ke urutan awal
        _fetchCategories(); // Memanggil ulang fungsi untuk mengambil kategori tanpa pengurutan
      } else {
        // Jika belum disort, urutkan berdasarkan nama makanan secara ascending
        _categories
            .sort((a, b) => a['strCategory'].compareTo(b['strCategory']));
      }
      _isSorted = !_isSorted;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Easy to Cook Menu",
          style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromARGB(255, 255, 137, 210),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 255, 137, 210),
              ),
              child: Text(
                'Menu',
                style: GoogleFonts.poppins(fontSize: 24, color: Colors.white),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ProfileScreen()),
                );
              },
            ),
            // ListTile(
            //   leading: const Icon(Icons.favorite),
            //   title: const Text('Favorites'),
            //   onTap: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (context) => FavoritesScreen(favoriteMeals: favoriteMeals),
            //       ),
            //     );
            //   },
            // ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SettingsScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const SignInScreen()),
                );
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Search your perfect recipe",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged:
                  _searchMeal, // Panggil fungsi pencarian saat teks berubah
            ),
            const SizedBox(height: 20),
            Text(
              "Categories",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Wrap(
                  spacing: 10,
                  children: [
                    ChoiceChip(
                      label: Text(
                        "All",
                        style: GoogleFonts.poppins(fontSize: 12),
                      ),
                      selected: true,
                      onSelected: (selected) {},
                    ),
                    // ChoiceChip(
                    //   label: Text(
                    //     "Breakfast",
                    //     style: GoogleFonts.poppins(fontSize: 12),
                    //   ),
                    //   selected: false,
                    //   onSelected: (selected) {},
                    // ),
                    // ChoiceChip(
                    //   label: Text(
                    //     "Dessert",
                    //     style: GoogleFonts.poppins(fontSize: 12),
                    //   ),
                    //   selected: false,
                    //   onSelected: (selected) {},
                    // ),
                  ],
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed:
                      _sortCategories, // Memanggil fungsi _sortCategories saat tombol ditekan
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 255, 137, 210),
                  ),
                  child: Text(
                    _isSorted ? 'Sorted' : 'Sort by Name',
                    style: GoogleFonts.poppins(fontSize: 12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _searchResults.isNotEmpty
                  ? GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // Jumlah kolom
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: _searchResults.length,
                      itemBuilder: (context, index) {
                        final meal = _searchResults[index];
                        return GestureDetector(
                          onTap: () {
                            // Navigasi ke detail makanan
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    MealDetailScreen(mealId: meal['idMeal']),
                              ),
                            );
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                      meal['strMealThumb'],
                                      height: 120,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    meal['strMeal'],
                                    style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    )
                  : _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                          ),
                          itemCount: _categories.length,
                          itemBuilder: (context, index) {
                            final category = _categories[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CategoryScreen(
                                        category: category['strCategory']),
                                  ),
                                );
                              },
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.network(
                                          category['strCategoryThumb'],
                                          height: 120,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        category['strCategory'],
                                        style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
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
