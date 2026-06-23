import 'package:flutter/material.dart';
import 'package:cultivest_app/screens/marketplace/cart_screen.dart';

class ProductDetailsScreen extends StatefulWidget {
  final String productName;
  final double productPrice;

  const ProductDetailsScreen({
    Key? key, 
    this.productName = 'Product',
    this.productPrice = 0.0,
  }) : super(key: key);

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  Color get primaryGreen => Theme.of(context).primaryColor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryGreen,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.productName,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Search Bar & Filter (Reused from Marketplace)
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Search for Products',
                        hintStyle: const TextStyle(color: Colors.white70),
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Colors.white,
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 0),
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
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      icon: Icon(Icons.tune, color: Theme.of(context).primaryColor),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25),

              // 2. Available Products Header
              const Text(
                'Available Products',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),

              // 3. Horizontal Products List
              SizedBox(
                height: 210,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _buildHorizontalProductCard(
                      'MOP FFC',
                      '\$35',
                      'assets/mop_ffc.png',
                    ),
                    _buildHorizontalProductCard(
                      'Sona DAP FFC',
                      '\$40',
                      'assets/sona_dap.png',
                      hasGreenBanner: true,
                    ),
                    _buildHorizontalProductCard(
                      'Urea',
                      '\$30',
                      'assets/urea.png',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // 4. Product Details Section
              const Text(
                'Product Details',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),

              // Details List
              _buildDetailRow(
                Icons.monetization_on,
                Colors.orangeAccent,
                'Price',
                '\$${widget.productPrice.toStringAsFixed(2)}',
              ),
              _buildDivider(),
              _buildDetailRow(
                Icons.star,
                Colors.amber,
                'Average Rating',
                '4.5',
              ),
              _buildDivider(),
              _buildDetailRow(
                Icons.access_time,
                Colors.white70,
                'Delivery Time',
                '3-5 days',
              ),
              _buildDivider(),
              _buildDetailRow(
                Icons.loop,
                Colors.blueAccent,
                'Return Policy',
                '20 days',
              ),
              _buildDivider(),
              _buildDetailRow(
                Icons.inventory_2,
                Colors.brown.shade300,
                'Availability',
                'In Stock',
              ),
              const SizedBox(height: 30),

              // 5. Add to Cart Button
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Item added to cart!')),
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CartScreen(
                          productName: widget.productName,
                          productPrice: widget.productPrice,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: primaryGreen,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: const Text(
                    'Add to Cart',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: primaryGreen,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        currentIndex: 2, // Market Place is selected
        selectedFontSize: 10,
        unselectedFontSize: 10,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book_outlined),
            label: 'Learning tools',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.insights),
            label: 'Market Place',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.groups_outlined),
            label: 'Community',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_outlined),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  // --- Modular UI Builders ---

  Widget _buildHorizontalProductCard(
    String title,
    String price,
    String imagePath, {
    bool hasGreenBanner = false,
  }) {
    String imgUrl = 'https://images.unsplash.com/photo-1581092160562-40aa08e78837?auto=format&fit=crop&w=500&q=60';
    return Container(
      width: 150,
      margin: const EdgeInsets.only(right: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Area
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
              ),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                    child: Image.network(imgUrl, fit: BoxFit.cover, width: double.infinity, height: double.infinity),
                  ),
                  if (hasGreenBanner)
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        color: Theme.of(context).primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: const Text(
                          'اصلی معیار کی پہچان', // Urdu text from your image
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white, fontSize: 10),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          // Text Details
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(color: Colors.black87, fontSize: 12),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 5),
                Text(
                  price,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(
    IconData icon,
    Color iconColor,
    String title,
    String value,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 20),
          const SizedBox(width: 15),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(color: Colors.white54, thickness: 1, height: 10);
  }
}

