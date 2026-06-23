import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:cultivest_app/providers/product_provider.dart';
import 'package:cultivest_app/screens/seller/my_products_screen.dart';

class NewListingScreen extends StatefulWidget {
  const NewListingScreen({Key? key}) : super(key: key);

  @override
  State<NewListingScreen> createState() => _NewListingScreenState();
}

class _NewListingScreenState extends State<NewListingScreen> {
  Color get primaryGreen => Theme.of(context).primaryColor;
  
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _qtyController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  // Delivery toggle ke liye state variable
  bool isDeliveryAvailable = false;

  String? _base64Image;
  File? _imageFile;

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 25,
      maxWidth: 800,
      maxHeight: 800,
    );
    if (image != null) {
      final bytes = await image.readAsBytes();
      setState(() {
        _imageFile = File(image.path);
        _base64Image = base64Encode(bytes);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
          'New Listing',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Select Product Dropdown/Field
                _buildDropdownField('Category'),
                const SizedBox(height: 15),

                // 2. Product Name Field
                _buildTextField(
                  'Product Name', 
                  controller: _nameController,
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'Please enter a product name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),

                // 3. Description Field (Large Box)
                _buildTextField(
                  'Description',
                  controller: _descController,
                  maxLines: 5,
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'Please enter a product description';
                    }
                    if (val.length < 10) {
                      return 'Description should be at least 10 characters';
                    }
                    return null;
                  },
                ), // Blank label for large description box
                const SizedBox(height: 15),

                // 4. Price Field
                _buildTextField(
                  'Price', 
                  controller: _priceController, 
                  keyboardType: TextInputType.number,
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'Please enter a price';
                    }
                    final price = double.tryParse(val);
                    if (price == null || price <= 0) {
                      return 'Please enter a valid positive price';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),

                // 5. Quantity Field
                _buildTextField(
                  'Quantity in Stock',
                  controller: _qtyController,
                  keyboardType: TextInputType.number,
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'Please enter product quantity';
                    }
                    final qty = int.tryParse(val);
                    if (qty == null || qty < 0) {
                      return 'Please enter a valid positive quantity';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 25),

                // 6. Upload Images Section
                const Text(
                  'Upload Images',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),

                // Custom Upload Box
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 30),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.white,
                      width: 1.5,
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: Column(
                    children: [
                      if (_imageFile != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 15.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.file(
                              _imageFile!,
                              height: 100,
                              width: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      const Text(
                        'Add Images',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Upload images of your product from your\ngallery or take a new photo.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _pickImage,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: primaryGreen,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 10,
                          ),
                        ),
                        child: Text(
                          _imageFile == null ? 'Upload' : 'Change Image',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                // 7. Delivery Available Toggle
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Delivery Available',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    Transform.scale(
                      scale: 0.9,
                      child: Switch(
                        value: isDeliveryAvailable,
                        onChanged: (val) {
                          setState(() {
                            isDeliveryAvailable = val;
                          });
                        },
                        activeThumbColor: primaryGreen,
                        activeTrackColor: Colors.white,
                        inactiveThumbColor: Colors.grey.shade400,
                        inactiveTrackColor: Colors.white54,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // 8. Product Location Field
                _buildTextField(
                  'Product Location', 
                  controller: _locationController,
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'Please enter location';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 40),

                // 9. Action Buttons (Cancel & Submit)
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () =>
                            Navigator.pop(context), // Wapas Dashboard par
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: primaryGreen,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Consumer<ProductProvider>(
                        builder: (context, productProvider, child) {
                          return ElevatedButton(
                            onPressed: productProvider.isLoading
                                ? null
                                : () async {
                                    if (_formKey.currentState!.validate()) {
                                      bool success = await productProvider.addProduct({
                                        'category': _categoryController.text.isNotEmpty 
                                            ? _categoryController.text 
                                            : 'Other',
                                        'name': _nameController.text.trim(),
                                        'description': _descController.text.trim(),
                                        'price': double.tryParse(_priceController.text) ?? 0.0,
                                        'quantity': int.tryParse(_qtyController.text) ?? 0,
                                        'location': _locationController.text.trim(),
                                        'isDeliveryAvailable': isDeliveryAvailable ? 1 : 0,
                                        'image_data': _base64Image,
                                      });

                                      if (!mounted) return;
                                      
                                      if (success) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text('Product Listed Successfully!'),
                                          ),
                                        );
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(builder: (context) => const MyProductsScreen()),
                                        );
                                      } else {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              productProvider.errorMessage.isNotEmpty
                                                  ? productProvider.errorMessage
                                                  : 'Failed to list product. Please try again.'
                                            ),
                                          ),
                                        );
                                      }
                                    }
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: primaryGreen,
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                            child: productProvider.isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  )
                                : const Text(
                                    'Submit Listing',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                          );
                        }
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- Modular Dropdown Builder ---
  Widget _buildDropdownField(String hint) {
    return DropdownButtonFormField<String>(
      initialValue: _categoryController.text.isNotEmpty ? _categoryController.text : null,
      dropdownColor: const Color(0xFF2B5B2E), // Darker green for dropdown menu
      icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
      style: const TextStyle(color: Colors.white, fontSize: 14),
      hint: Text(
        hint,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select a category';
        }
        return null;
      },
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 18,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.white70, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.white, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.redAccent, width: 2),
        ),
      ),
      items: ['Seeds', 'Fertilizers', 'Pesticides', 'Machinery', 'Tools', 'Crops', 'Other']
          .map((String category) => DropdownMenuItem(
                value: category,
                child: Text(
                  category,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
              ))
          .toList(),
      onChanged: (value) {
        setState(() {
          _categoryController.text = value ?? '';
        });
      },
    );
  }

  // --- Modular TextField Builder ---
  Widget _buildTextField(
    String hint, {
    TextEditingController? controller,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    bool isDropdown = false,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      readOnly: isDropdown, // Agar dropdown hai toh type nahi karne dega
      style: const TextStyle(color: Colors.white, fontSize: 14),
      validator: validator,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          color: Colors.white70,
          fontSize: 14,
          height: 1.2,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 18,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.white70, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.white, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.redAccent, width: 2),
        ),
      ),
    );
  }
}

