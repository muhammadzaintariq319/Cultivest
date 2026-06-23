import 'package:flutter/material.dart';
import 'package:cultivest_app/core/database/database_helper.dart';

class IncomingOrdersScreen extends StatelessWidget {
  const IncomingOrdersScreen({Key? key}) : super(key: key);

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
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Incoming Orders',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: DatabaseHelper().getAllOrders(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator(color: Colors.white));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No orders yet.', style: TextStyle(color: Colors.white)));
            }

            final orders = snapshot.data!;

            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return OrderItemTile(
                  quantity: '${order['quantity']} Packs',
                  buyer: order['buyerName'] ?? 'Unknown',
                  product: order['productName'] ?? 'Product',
                );
              },
            );
          },
        ),
      ),
    );
  }
}

// --- Stateful Widget har individual order ke liye ---
// Yeh widget isliye banaya hai taake har button apni state (Accept/Approved) khud handle kare
class OrderItemTile extends StatefulWidget {
  final String quantity;
  final String buyer;
  final String product;

  const OrderItemTile({
    Key? key,
    required this.quantity,
    required this.buyer,
    required this.product,
  }) : super(key: key);

  @override
  State<OrderItemTile> createState() => _OrderItemTileState();
}

class _OrderItemTileState extends State<OrderItemTile> {
  bool isAccepted = false; // Initial state

  @override
  Widget build(BuildContext context) {
    final primaryGreen = Theme.of(context).primaryColor;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 1. Box Icon
          Container(
            width: 55,
            height: 55,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              // Isometric box icon matching your design
              child: Icon(
                Icons.view_in_ar_outlined,
                color: Colors.black87,
                size: 28,
              ),
            ),
          ),
          const SizedBox(width: 15),

          // 2. Order Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Quantity: ${widget.quantity} | Total:',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Buyer: ${widget.buyer}',
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
                Text(
                  '| Product: ${widget.product}',
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),

          // 3. Accept / Approved Button
          ElevatedButton(
            // Agar pehle se accept ho chuka hai toh button ko disable (null) kar dein
            onPressed: isAccepted
                ? null
                : () {
                    setState(() {
                      isAccepted = true; // State change kar di
                    });

                    // Optional: Chota sa message show kar dein
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Order from ${widget.buyer} approved!'),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
            style: ElevatedButton.styleFrom(
              // Agar accepted hai toh background transparent kar dein, warna white
              backgroundColor: isAccepted ? Colors.transparent : Colors.white,
              foregroundColor: isAccepted ? Colors.white : primaryGreen,
              disabledBackgroundColor:
                  Colors.transparent, // Disable hone par background
              disabledForegroundColor:
                  Colors.white70, // Disable hone par text color
              elevation: isAccepted ? 0 : 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                // Agar accepted hai toh halka sa border laga dein taake pata chale
                side: BorderSide(
                  color: isAccepted ? Colors.white54 : Colors.transparent,
                  width: 1,
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
            ),
            child: Text(
              isAccepted ? 'Approved' : 'Accept',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

