import 'dart:developer';

import 'package:smart_shop_app/main.dart';
import 'package:smart_shop_app/service/products/products.dart';

class Transaction {
  final int id;
  final ProductData product;
  final double quantity;
  final double totalPrice;
  final DateTime date;
  final String status;

  Transaction({
    required this.id,
    required this.product,
    required this.quantity,
    required this.totalPrice,
    required this.date,
    required this.status,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    log(json.toString());
    return Transaction(
      id: json['id'],
      product: ProductData.fromMap(json['product_id']),
      quantity: json['quantity'],
      totalPrice: json['total_price'],
      date: DateTime.parse(json['order_date']),
      status: json['status'],
    );
  }
}

class TransactionService {
  Future<List<Map<String, dynamic>>?> getTransactions() async {
    try {
      final currentUser = supabase.auth.currentUser;

      if (currentUser == null) {
        return null;
      }

      final response = await supabase
          .from("transaction")
          .select("* , product_id(*)")
          .eq("user_id", currentUser.id);

      return response;
    } catch (e) {
      return null;
    }
  }

  addTransaction(List<dynamic> payload) async {
    try {
      final currentUser = supabase.auth.currentUser;

      if (currentUser == null) {
        return;
      }

      await supabase.from("transaction").insert(payload);
      return true;
    } catch (e) {
      return false;
    }
  }
}
