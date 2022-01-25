import 'dart:convert';

import 'package:bms_project/modals/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// import '../models/http_exception.dart';
// import './product.dart';

class Users with ChangeNotifier {
  // List<Product> get items {
  //   // if (_showFavoritesOnly) {
  //   //   return _items.where((prodItem) => prodItem.isFavorite).toList();
  //   // }
  //   return [..._items];
  // }

  // List<Product> get favoriteItems {
  //   return _items.where((prodItem) => prodItem.isFavorite).toList();
  // }

  // Product findById(String id) {
  //   return _items.firstWhere((prod) => prod.id == id);
  // }

  // // void showFavoritesOnly() {
  // //   _showFavoritesOnly = true;
  // //   notifyListeners();
  // // }

  // // void showAll() {
  // //   _showFavoritesOnly = false;
  // //   notifyListeners();
  // // }

  // Future<void> fetchAndSetProducts() async {
  //   final url = Uri.https('flutter-update.firebaseio.com', '/products.json');
  //   try {
  //     final response = await http.get(url);
  //     final extractedData = json.decode(response.body) as Map<String, dynamic>;
  //     if (extractedData == null) {
  //       return;
  //     }
  //     final List<Product> loadedProducts = [];
  //     extractedData.forEach((prodId, prodData) {
  //       loadedProducts.add(Product(
  //         id: prodId,
  //         title: prodData['title'],
  //         description: prodData['description'],
  //         price: prodData['price'],
  //         isFavorite: prodData['isFavorite'],
  //         imageUrl: prodData['imageUrl'],
  //       ));
  //     });
  //     _items = loadedProducts;
  //     notifyListeners();
  //   } catch (error) {
  //     throw (error);
  //   }
  // }
  Future<dynamic> signUpUser(User user) async {
    var url = 'http://localhost:8080/api/auth/register';
    final body = json.encode(user.toMap());
    try {
      http.Response response = await http.post(Uri.parse(url),
          body: body,
          headers: {
            'access-control-allow-origin': '*',
            'content-type': 'application/json'
          });

      var code = json.decode(response.body)['code'];
      notifyListeners();
      print(code);
      if (code == 409 || code == 500) {
        return [false, json.decode(response.body)['message']];
      } else if (code == 201) {
        return [true];
      } else {
        return [false, "unknown error"];
      }
    } catch (error) {
      print("error");
      print(error);
      return [false, error];
    }
  }

  Future<dynamic> signInUser(Map<String, String> userInfo) async {
    var url = 'http://localhost:8080/api/auth/login';
    final body = json.encode(userInfo);
    try {
      http.Response response = await http.post(Uri.parse(url),
          body: body,
          headers: {
            'access-control-allow-origin': '*',
            'content-type': 'application/json'
          });

      var code = json.decode(response.body)['code'];
      notifyListeners();
      print(code);
      if (code == 404 || code == 500) {
        return [false, json.decode(response.body)['error']];
      } else if (code == 200) {
        return [true, json.decode(response.body)['message']];
      } else {
        return [false, "unknown error"];
      }
    } catch (error) {
      print("error");
      print(error);
      return [false, error];
    }
  }

  // Future<void> addProduct(Product product) async {
  //   final url = Uri.https('flutter-update.firebaseio.com', '/products.json');
  //   try {
  //     final response = await http.post(
  //       url,
  //       body: json.encode({
  //         'title': product.title,
  //         'description': product.description,
  //         'imageUrl': product.imageUrl,
  //         'price': product.price,
  //         'isFavorite': product.isFavorite,
  //       }),
  //     );
  //     final newProduct = Product(
  //       title: product.title,
  //       description: product.description,
  //       price: product.price,
  //       imageUrl: product.imageUrl,
  //       id: json.decode(response.body)['name'],
  //     );
  //     _items.add(newProduct);
  //     // _items.insert(0, newProduct); // at the start of the list
  //     notifyListeners();
  //   } catch (error) {
  //     print(error);
  //     throw error;
  //   }
  // }

  // Future<void> updateProduct(String id, Product newProduct) async {
  //   final prodIndex = _items.indexWhere((prod) => prod.id == id);
  //   if (prodIndex >= 0) {
  //     final url =
  //         Uri.https('flutter-update.firebaseio.com', '/products/$id.json');
  //     await http.patch(url,
  //         body: json.encode({
  //           'title': newProduct.title,
  //           'description': newProduct.description,
  //           'imageUrl': newProduct.imageUrl,
  //           'price': newProduct.price
  //         }));
  //     _items[prodIndex] = newProduct;
  //     notifyListeners();
  //   } else {
  //     print('...');
  //   }
  // }

  // Future<void> deleteProduct(String id) async {
  //   final url =
  //       Uri.https('flutter-update.firebaseio.com', '/products/$id.json');
  //   final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
  //   var existingProduct = _items[existingProductIndex];
  //   _items.removeAt(existingProductIndex);
  //   notifyListeners();
  //   final response = await http.delete(url);
  //   if (response.statusCode >= 400) {
  //     _items.insert(existingProductIndex, existingProduct);
  //     notifyListeners();
  //     throw HttpException('Could not delete product.');
  //   }
  //   existingProduct = null;
  // }
}
