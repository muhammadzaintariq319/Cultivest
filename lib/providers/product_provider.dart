import 'package:flutter/material.dart';
import 'package:cultivest_app/core/database/database_helper.dart';

class ProductProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _products = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<Map<String, dynamic>> get products => _products;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<void> fetchProducts() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      _products = await _dbHelper.getAllProducts();
    } catch (e) {
      _errorMessage = 'Failed to load products: ${e.toString()}';
      debugPrint("Error fetching products: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addProduct(Map<String, dynamic> product) async {
    _isLoading = true;
    notifyListeners();
    try {
      int id = await _dbHelper.insertProduct(product);
      if (id > 0) {
        await fetchProducts(); // Reload local list
        return true;
      }
      return false;
    } catch (e) {
      _errorMessage = 'Failed to add product: ${e.toString()}';
      debugPrint("Error adding product: $e");
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> removeProduct(int id) async {
    _isLoading = true;
    notifyListeners();
    try {
      int rows = await _dbHelper.deleteProduct(id);
      if (rows > 0) {
        await fetchProducts(); // Reload local list
        return true;
      }
      return false;
    } catch (e) {
      _errorMessage = 'Failed to delete product: ${e.toString()}';
      debugPrint("Error deleting product: $e");
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
