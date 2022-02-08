import 'dart:convert';

import 'package:bms_project/modals/location.dart';
import 'package:bms_project/modals/user.dart';
import 'package:bms_project/utils/environment.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// import '../models/http_exception.dart';
// import './product.dart';

class Users with ChangeNotifier {
  late User user;
  Future<dynamic> signUpUser(User user) async {
    var url = '${Environment.apiUrl}/auth/register';
    final body = json.encode(user.toMap());
    try {
      http.Response response = await http.post(Uri.parse(url),
          body: body,
          headers: {
            'access-control-allow-origin': '*',
            'content-type': 'application/json'
          });
      var data = json.decode(response.body);
      notifyListeners();
      if (data['code'] == 409 || data['code'] == 500) {
        return {
          'success': false,
          'message': data['message'],
        };
      } else if (data['code'] == 201) {
        return {
          'success': true,
          'message': 'successfully registered',
        };
      } else {
        return {
          'success': false,
          'message': 'unknown number',
        };
      }
    } catch (error) {
      print("error");
      print(error);
      return [false, error];
    }
  }

  Future<dynamic> signInUser(Map<String, String> userInfo) async {
    var url = '${Environment.apiUrl}/auth/login';
    print("requesting in $url");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final body = json.encode(userInfo);
    print("Provider.signInUser():");
    print(body);
    try {
      print("yo");
      http.Response response = await http.post(Uri.parse(url),
          body: body,
          headers: {
            'access-control-allow-origin': '*',
            'content-type': 'application/json'
          });
      print("yo2");
      var data = json.decode(response.body);
      print(data);
      var code = data['code'];
      notifyListeners();
      if (code == 404 || code == 500) {
        return {
          'success': false,
          'message': data['message'],
        };
      } else if (code == 200) {
        prefs.setString('token', data['token']);
        return {
          'success': true,
          'message': data['message'],
        };
      } else {
        return {
          'success': false,
          'message': 'unknown error',
        };
      }
    } catch (error) {
      print("sign in user: error");
      print(error);
      return {
        'success': false,
        'message': error,
      };
    }
  }

  Future<dynamic> getUserData() async {
    // print("inside getUserData");
    var url = '${Environment.apiUrl}/user/me';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token") as String;
    try {
      http.Response response = await http.get(Uri.parse(url), headers: {
        'access-control-allow-origin': '*',
        'content-type': 'application/json',
        'authorization': token,
      });

      var code = json.decode(response.body)['code'];
      print(json.decode(response.body)['data']);

      notifyListeners();
      if (code == 404 || code == 500) {
        return [false, json.decode(response.body)['error']];
      } else if (code == 200) {
        var data = json.decode(response.body)['data'];
        user = User(
          name: data['NAME'],
          email: data['EMAIL'],
          phone: data['PHONE_NUMBER'],
          gender: data['GENDER'],
          bloodGroup: data['BLOOD_GROUP'],
          location: Location(
            description: data['LOCATION']['DESCRIPTION'],
            latitude: data['LOCATION']['LONGITUDE'],
            longitude: data['LOCATION']['LATITUDE'],
          ),
        );
        print("user init");
        print("user name : ${user.name}");
        print("ok");
        // print(user);
        return [true, data];
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
