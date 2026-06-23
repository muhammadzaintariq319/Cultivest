import 'package:flutter/material.dart';
import 'package:cultivest_app/screens/marketplace/confirm_order_screen.dart';

class CartScreen extends StatefulWidget {
  final String productName;
  final double productPrice;

  const CartScreen({
    Key? key,
    this.productName = 'Product',
    this.productPrice = 0.0,
  }) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  Color get primaryGreen => Theme.of(context).primaryColor;

  // State variables for quantity selection
  int _selectedFertilizerQty = 1;
  final TextEditingController _qtyController = TextEditingController(text: '1');

  @override
  void initState() {
    super.initState();
    _qtyController.addListener(() {
      setState(() {
        _selectedFertilizerQty = int.tryParse(_qtyController.text) ?? 1;
        if (_selectedFertilizerQty < 1) _selectedFertilizerQty = 1;
      });
    });
  }

  @override
  void dispose() {
    _qtyController.dispose();
    super.dispose();
  }

  double get subtotal => widget.productPrice * _selectedFertilizerQty;
  double get deliveryFee => 4.0;
  double get totalAmount => subtotal + deliveryFee;

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
        title: const Text(
          'My Cart',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: Colors.white54,
            height: 1.0,
            margin: const EdgeInsets.symmetric(horizontal: 20),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Cart Items Section
              const Text(
                'Cart Items',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),
              _buildCartItemRow(
                Icons.shopping_cart_outlined,
                widget.productName,
                '\$${widget.productPrice.toStringAsFixed(2)}',
              ),
              _buildDivider(),
              const SizedBox(height: 20),

              // 2. Quantity Adjustment Section
              Text(
                'Quantity for ${widget.productName}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                'Adjust the quantity',
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
              const SizedBox(height: 20),

              // Quantity Input Field
              TextField(
                controller: _qtyController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white, fontSize: 16),
                decoration: InputDecoration(
                  hintText: 'Enter quantity',
                  hintStyle: const TextStyle(color: Colors.white54),
                  filled: true,
                  fillColor: Colors.white24,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 15,
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // 3. Summary Section
              const Text(
                'Summary',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),
              _buildSummaryRow(
                Icons.request_quote_outlined,
                'Subtotal',
                '\$${subtotal.toStringAsFixed(2)}',
              ),
              _buildDivider(),
              _buildSummaryRow(
                Icons.local_shipping_outlined,
                'Delivery Charges',
                '\$${deliveryFee.toStringAsFixed(2)}',
              ),
              _buildDivider(),
              _buildSummaryRow(
                Icons.payments_outlined,
                'Total Amount',
                '\$${totalAmount.toStringAsFixed(2)}',
                isBold: true,
              ),
              _buildDivider(),
              const SizedBox(height: 40),

              // 4. Proceed to Checkout Button
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ConfirmOrderScreen(
                          productName: widget.productName,
                          quantity: _selectedFertilizerQty,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: primaryGreen,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Proceed to Checkout',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // --- Modular UI Builders ---

  Widget _buildCartItemRow(IconData icon, String title, String price) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 24),
          const SizedBox(width: 15),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          Text(
            price,
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

  Widget _buildSummaryRow(
    IconData icon,
    String title,
    String amount, {
    bool isBold = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 20),
          const SizedBox(width: 15),
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
            ),
          ),
          const Spacer(),
          Text(
            amount,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
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
