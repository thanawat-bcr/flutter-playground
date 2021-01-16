import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';

import 'product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  // var _showFavoritesOnly = false;

  List<Product> get items {
    // if (_showFavoritesOnly) {
    //   return _items.where((prod) => prod.isFavorite).toList();
    // }
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((prod) => prod.isFavorite).toList();
  }

  // void showFavoritesOnly() {
  //   _showFavoritesOnly = true;
  //   notifyListeners();
  // }

  // void showAll() {
  //   _showFavoritesOnly = false;
  //   notifyListeners();
  // }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  Future<void> fetchProducts() async {
    const url =
        'https://flutter-shoppy-c0de4-default-rtdb.firebaseio.com/products.json';
    try {
      final res = await http.get(url);
      final data = json.decode(res.body) as Map<String, dynamic>;
      if (data == null) return;
      final List<Product> loadedProducts = [];
      data.forEach((id, val) {
        loadedProducts.add(Product(
          id: id,
          title: val['title'],
          description: val['description'],
          price: val['price'],
          imageUrl: val['imageUrl'],
          isFavorite: val['isFavorite'],
        ));
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (err) {
      throw err;
    }
  }

  Future<void> addProduct(Product p) async {
    const url =
        'https://flutter-shoppy-c0de4-default-rtdb.firebaseio.com/products.json';
    try {
      final res = await http.post(
        url,
        body: json.encode({
          'title': p.title,
          'description': p.description,
          'imageUrl': p.imageUrl,
          'price': p.price,
          'isFavorite': p.isFavorite,
        }),
      );
      final newProduct = Product(
        id: json.decode(res.body)['name'],
        title: p.title,
        description: p.description,
        price: p.price,
        imageUrl: p.imageUrl,
      );
      _items.add(newProduct);
      notifyListeners();
    } catch (err) {
      throw err;
    }
  }

  Future<void> updateProduct(String id, Product p) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      final url =
          'https://flutter-shoppy-c0de4-default-rtdb.firebaseio.com/products/$id.json';
      await http.patch(url,
          body: json.encode({
            'title': p.title,
            'description': p.description,
            'imageUrl': p.imageUrl,
            'price': p.price,
          }));

      _items[prodIndex] = p;
      notifyListeners();
    }
  }

  Future<void> deleteProduct(String id) async {
    final url =
        'https://flutter-shoppy-c0de4-default-rtdb.firebaseio.com/products/$id.json';

    // Save product in memory for rollback when error
    final index = _items.indexWhere((prod) => prod.id == id);
    var product = _items[index];

    // Remove item
    _items.removeAt(index);
    notifyListeners();

    final res = await http.delete(url);
    // Error handler
    if (res.statusCode >= 400) {
      _items.insert(index, product);
      notifyListeners();
      throw HttpException('Error Occured');
    }
    // Free memory
    product = null;
  }
}
