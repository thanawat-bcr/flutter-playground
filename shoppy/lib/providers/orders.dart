import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchOrders() async {
    final url =
        'https://flutter-shoppy-c0de4-default-rtdb.firebaseio.com/orders.json';
    final res = await http.get(url);
    final data = json.decode(res.body) as Map<String, dynamic>;
    if (data == null) return;
    final List<OrderItem> loadedOrders = [];
    data.forEach((id, value) {
      loadedOrders.add(OrderItem(
        id: id,
        amount: value['amount'],
        dateTime: DateTime.parse(value['dateTime']),
        products: (value['products'] as List<dynamic>)
            .map(
              (item) => CartItem(
                id: item['id'],
                title: item['title'],
                quantity: item['quantity'],
                price: item['price'],
              ),
            )
            .toList(),
      ));
    });
    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> cart, double total) async {
    final timestamp = DateTime.now();
    final url =
        'https://flutter-shoppy-c0de4-default-rtdb.firebaseio.com/orders.json';
    final res = await http.post(url,
        body: json.encode({
          'amount': total,
          'dateTime': timestamp.toIso8601String(),
          'products': cart
              .map((cp) => {
                    'id': cp.id,
                    'title': cp.title,
                    'quantity': cp.quantity,
                    'price': cp.price,
                  })
              .toList()
        }));
    _orders.insert(
        0,
        OrderItem(
            id: json.decode(res.body)['name'],
            amount: total,
            products: cart,
            dateTime: DateTime.now()));
    notifyListeners();
  }
}
