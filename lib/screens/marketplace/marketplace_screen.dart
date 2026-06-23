import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:cultivest_app/providers/product_provider.dart';
import 'package:cultivest_app/screens/marketplace/product_details_screen.dart';
import 'package:cultivest_app/screens/learning/learning_tools_screen.dart';
import 'package:cultivest_app/screens/community/community_screen.dart';
import 'package:cultivest_app/screens/profile/profile_screen.dart';

class MarketplaceScreen extends StatefulWidget {
  final bool showBottomNavBar;
  const MarketplaceScreen({super.key, this.showBottomNavBar = false});

  @override
  State<MarketplaceScreen> createState() => _MarketplaceScreenState();
}

class _MarketplaceScreenState extends State<MarketplaceScreen> {
  Color get primaryGreen => Theme.of(context).primaryColor;
  int _selectedCategoryIndex = 0; // State for category selection
  String _searchQuery = '';
  String _sortBy = 'Default'; // 'Default', 'low_to_high', 'high_to_low'
  final TextEditingController _searchController = TextEditingController();

  final List<String> _categories = ['All', 'Fertilizer', 'Crops', 'Equipment'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductProvider>(context, listen: false).fetchProducts();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> _getFilteredProducts(
    List<Map<String, dynamic>> allProducts,
  ) {
    List<Map<String, dynamic>> filtered = List.from(allProducts);

    // 1. Category Filter
    if (_selectedCategoryIndex > 0) {
      String category = _categories[_selectedCategoryIndex];
      filtered = filtered.where((p) {
        final cat = (p['category'] ?? '').toString().toLowerCase();
        return cat == category.toLowerCase();
      }).toList();
    }

    // 2. Search Query Filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((p) {
        final name = (p['name'] ?? '').toString().toLowerCase();
        final desc = (p['description'] ?? '').toString().toLowerCase();
        return name.contains(_searchQuery.toLowerCase()) ||
            desc.contains(_searchQuery.toLowerCase());
      }).toList();
    }

    // 3. Sorting
    if (_sortBy == 'low_to_high') {
      filtered.sort((a, b) {
        double priceA = double.tryParse(a['price'].toString()) ?? 0.0;
        double priceB = double.tryParse(b['price'].toString()) ?? 0.0;
        return priceA.compareTo(priceB);
      });
    } else if (_sortBy == 'high_to_low') {
      filtered.sort((a, b) {
        double priceA = double.tryParse(a['price'].toString()) ?? 0.0;
        double priceB = double.tryParse(b['price'].toString()) ?? 0.0;
        return priceB.compareTo(priceA);
      });
    }

    return filtered;
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Color(0xFF2C6330), // Premium Dark green matching the app
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 40,
                          height: 5,
                          decoration: BoxDecoration(
                            color: Colors.white54,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Filter & Sort Products',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Sort By Price',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Sort Options
                      _buildSortOption(
                        title: 'Default (Latest)',
                        value: 'Default',
                        setSheetState: setSheetState,
                      ),
                      _buildSortOption(
                        title: 'Price: Low to High',
                        value: 'low_to_high',
                        setSheetState: setSheetState,
                      ),
                      _buildSortOption(
                        title: 'Price: High to Low',
                        value: 'high_to_low',
                        setSheetState: setSheetState,
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          child: const Text(
                            'Apply Filters',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSortOption({
    required String title,
    required String value,
    required StateSetter setSheetState,
  }) {
    bool isSelected = _sortBy == value;
    return InkWell(
      onTap: () {
        setSheetState(() {
          _sortBy = value;
        });
        setState(() {}); // Refresh marketplace list
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.white70,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 16,
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle, color: Colors.white)
            else
              const Icon(Icons.radio_button_unchecked, color: Colors.white54),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryGreen,
      body: SafeArea(
        child: Column(
          children: [
            // --- TOP FIXED SECTION ---
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Title
                  const Text(
                    'Marketplace',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // 2. Search Bar & Filter
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          onChanged: (val) {
                            setState(() {
                              _searchQuery = val;
                            });
                          },
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'Search for Products',
                            hintStyle: const TextStyle(color: Colors.white70),
                            prefixIcon: const Icon(
                              Icons.search,
                              color: Colors.white,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 0,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: const BorderSide(
                                color: Colors.white,
                                width: 1.5,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: const BorderSide(
                                color: Colors.white,
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      // Filter Button
                      Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: IconButton(
                          icon: Icon(
                            Icons.tune,
                            color: Theme.of(context).primaryColor,
                          ),
                          onPressed: _showFilterBottomSheet,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),

                  // 3. Categories Header
                  const Text(
                    'Categories',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // 4. Categories Chips (Horizontal Scroll)
                  SizedBox(
                    height: 40,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _categories.length,
                      itemBuilder: (context, index) {
                        return _buildCategoryChip(index, _categories[index]);
                      },
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'Select a category',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),

            // --- SCROLLABLE PRODUCTS GRID SECTION ---
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    // 5. Available Products Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Available Products',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          height: 30,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: TextButton(
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 0,
                              ),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            onPressed: () {},
                            child: const Row(
                              children: [
                                Text(
                                  'Add to Cart ',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.white,
                                  size: 10,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),

                    // 6. Product Grid
                    Consumer<ProductProvider>(
                      builder: (context, productProvider, child) {
                        if (productProvider.isLoading) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          );
                        } else if (productProvider.errorMessage.isNotEmpty) {
                          return Center(
                            child: Text(
                              productProvider.errorMessage,
                              style: const TextStyle(
                                  color: Colors.redAccent,
                                  fontWeight: FontWeight.bold),
                            ),
                          );
                        } else if (productProvider.products.isEmpty) {
                          return const Center(
                            child: Text(
                              'No products available.',
                              style: TextStyle(color: Colors.white),
                            ),
                          );
                        }

                        final products =
                            _getFilteredProducts(productProvider.products);

                        if (products.isEmpty) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 40.0),
                              child: Text(
                                'No matching products found.',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          );
                        }

                        return GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.75,
                            crossAxisSpacing: 15,
                            mainAxisSpacing: 15,
                          ),
                          itemCount: products.length,
                          itemBuilder: (context, index) {
                            final product = products[index];
                            return _buildProductCard(
                              product['name'] ?? 'Product',
                              double.tryParse(product['price'].toString()) ?? 0.0,
                              product['image_data'],
                            );
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: widget.showBottomNavBar
          ? BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              backgroundColor: primaryGreen,
              selectedItemColor: Colors.white,
              unselectedItemColor: Colors.white70,
              currentIndex: 2, // Index 2 = Market Place
              selectedFontSize: 10,
              unselectedFontSize: 10,
              onTap: (index) {
                if (index == 0) {
                  Navigator.pop(context);
                } else if (index == 1) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LearningToolsScreen(),
                    ),
                  );
                } else if (index == 3) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const CommunityScreen()),
                  );
                } else if (index == 4) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const ProfileScreen()),
                  );
                }
              },
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined),
                  activeIcon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.menu_book_outlined),
                  activeIcon: Icon(Icons.menu_book),
                  label: 'Learning tools',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.insights),
                  activeIcon: Icon(Icons.insights),
                  label: 'Market Place',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.groups_outlined),
                  activeIcon: Icon(Icons.groups),
                  label: 'Community',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.account_circle_outlined),
                  activeIcon: Icon(Icons.account_circle),
                  label: 'Profile',
                ),
              ],
            )
          : null,
    );
  }

  // --- Modular UI Builders ---

  // Category Chip Builder
  Widget _buildCategoryChip(int index, String title) {
    bool isSelected = _selectedCategoryIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategoryIndex = index; // Selection state update
        });
      },
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.grey.shade300, // Light grey background like image
          borderRadius: BorderRadius.circular(8),
          border: isSelected
              ? Border.all(color: Colors.black, width: 1.5)
              : null, // Outline on selection
        ),
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  // Product Card Builder
  Widget _buildProductCard(String title, double price, String? base64Image) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailsScreen(
              productName: title,
              productPrice: price,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white, // Use white instead of grey for clean look
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                  image: base64Image != null
                      ? DecorationImage(
                          image: MemoryImage(base64Decode(base64Image)),
                          fit: BoxFit.contain, // Show the full image without clipping
                        )
                      : null,
                ),
                child: base64Image == null
                    ? const Center(
                        child: Icon(
                          Icons.image,
                          color: Colors.white70,
                          size: 40,
                        ),
                      )
                    : null,
              ),
            ),
            // Product Details
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(color: Colors.black, fontSize: 12),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '\$${price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
