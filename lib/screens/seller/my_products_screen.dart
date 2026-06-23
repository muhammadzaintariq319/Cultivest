import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:cultivest_app/screens/seller/new_listing_screen.dart'; // Add Product button ke liye
import 'package:cultivest_app/core/database/database_helper.dart';

class MyProductsScreen extends StatefulWidget {
  const MyProductsScreen({Key? key}) : super(key: key);

  @override
  State<MyProductsScreen> createState() => _MyProductsScreenState();
}

class _MyProductsScreenState extends State<MyProductsScreen> {
  @override
  Widget build(BuildContext context) {
    final primaryGreen = Theme.of(context).primaryColor;

    return Scaffold(
      backgroundColor: primaryGreen,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            // Wapas Dashboard par jane ke liye
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'My Products',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: DatabaseHelper().getAllProducts(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator(color: Colors.white));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No products listed yet.', style: TextStyle(color: Colors.white)));
            }

            final products = snapshot.data!;

            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              itemCount: products.length + 1, // +1 for the bottom padding space
              itemBuilder: (context, index) {
                if (index == products.length) {
                  return const SizedBox(height: 80); // Taa ke aakhri item button ke peechay na chupe
                }
                
                final product = products[index];
                return _buildProductItem(
                  product['id'],
                  product['name'] ?? 'Unknown',
                  '\$${product['price']}',
                  'Active',
                  product['image_data'],
                );
              },
            );
          },
        ),
      ),

      // Floating Action Button (+ Add Product)
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Add Product par click karne se New Listing screen open hogi
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NewListingScreen()),
          );
        },
        backgroundColor: Colors.white,
        icon: const Icon(Icons.add, color: Colors.black87),
        label: const Text(
          'Add Product',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  // --- Modular UI Builder for Product Items ---
  Widget _buildProductItem(
    int id,
    String title,
    String price,
    String status,
    String? base64Image,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          // 1. Product Image
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.orange.shade300, // Placeholder background color
              borderRadius: BorderRadius.circular(10),
              image: base64Image != null
                  ? DecorationImage(
                      image: MemoryImage(base64Decode(base64Image)),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: base64Image == null
                ? const Center(
                    child: Icon(Icons.image, color: Colors.white70),
                  )
                : null,
          ),
          const SizedBox(width: 15),

          // 2. Title and Status
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  status,
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),

          // 3. Price and Actions
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                price,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                onPressed: () async {
                  await DatabaseHelper().deleteProduct(id);
                  if (mounted) {
                    setState(() {});
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

