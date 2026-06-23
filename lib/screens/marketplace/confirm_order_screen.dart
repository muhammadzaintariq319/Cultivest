import 'package:flutter/material.dart';
import 'package:cultivest_app/screens/marketplace/order_success_screen.dart';
import 'package:cultivest_app/core/database/database_helper.dart';

class ConfirmOrderScreen extends StatefulWidget {
  final String productName;
  final int quantity;

  const ConfirmOrderScreen({
    Key? key,
    this.productName = 'Product',
    this.quantity = 1,
  }) : super(key: key);

  @override
  State<ConfirmOrderScreen> createState() => _ConfirmOrderScreenState();
}

class _ConfirmOrderScreenState extends State<ConfirmOrderScreen> {
  final _formKey = GlobalKey<FormState>();
  Color get primaryGreen => Theme.of(context).primaryColor;

  // Controllers for input fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _postalController = TextEditingController();

  String? _selectedCity;
  final List<String> _cities = [
    'Lahore',
    'Karachi',
    'Islamabad',
    'Faisalabad',
    'Multan',
    'Peshawar',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _postalController.dispose();
    super.dispose();
  }

  void _submitOrder() async {
    if (_formKey.currentState!.validate()) {
      // Create a mock order using the inputted details
      await DatabaseHelper().insertOrder({
        'buyerName': _nameController.text,
        'productName': widget.productName, // Received from cart
        'quantity': widget.quantity.toString(), // Received from cart
      });

      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const OrderSuccessScreen()),
        );
      }
    }
  }

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
          'Confirm Order',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Heading
                const Center(
                  child: Text(
                    'Enter Details',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // 2. Full Name Field
                _buildLabel('Full Name*'),
                _buildTextField(
                  controller: _nameController,
                  hintText: 'Enter Full Name',
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter your name' : null,
                ),
                const SizedBox(height: 20),

                // 3. Phone Number Field (with +92 prefix)
                _buildLabel('Phone Number*'),
                _buildTextField(
                  controller: _phoneController,
                  hintText: '',
                  keyboardType: TextInputType.phone,
                  prefixText: '+92  ', // Country code prefix
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter phone number' : null,
                ),
                const SizedBox(height: 20),

                // 4. Select City Dropdown
                _buildLabel('Select City*'),
                DropdownButtonFormField<String>(
                  value: _selectedCity,
                  icon: const Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.white,
                  ),
                  dropdownColor: primaryGreen,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  hint: const Text(
                    'Choose Your City',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  decoration: _inputDecoration(''),
                  items: _cities.map((String city) {
                    return DropdownMenuItem<String>(
                      value: city,
                      child: Text(
                        city,
                        style: const TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedCity = newValue;
                    });
                  },
                  validator: (value) =>
                      value == null ? 'Please select a city' : null,
                ),
                const SizedBox(height: 20),

                // 5. Street Address Field
                _buildLabel('Street Address*'),
                _buildTextField(
                  controller: _addressController,
                  hintText: 'Enter street address',
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter your address' : null,
                ),
                const SizedBox(height: 20),

                // 6. Postal Code Field
                _buildLabel('Postal Code*'),
                _buildTextField(
                  controller: _postalController,
                  hintText: 'Enter postal code',
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter postal code' : null,
                ),
                const SizedBox(height: 40),

                // 7. Proceed Button
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: _submitOrder,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: primaryGreen,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          25,
                        ), // More rounded like the image
                      ),
                      elevation: 2,
                    ),
                    child: const Text(
                      'Proceed',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- Modular UI Builders ---

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 4.0),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    String? prefixText,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white, fontSize: 14),
      validator: validator,
      decoration: _inputDecoration(hintText).copyWith(
        prefixText: prefixText,
        prefixStyle: const TextStyle(color: Colors.white, fontSize: 14),
      ),
    );
  }

  // Common Input Decoration for both TextFields and Dropdown
  InputDecoration _inputDecoration(String hintText) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(color: Colors.white70, fontSize: 12),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25),
        borderSide: const BorderSide(color: Colors.white54, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25),
        borderSide: const BorderSide(color: Colors.white, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
      ),
    );
  }
}

