import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class FinanceEntry {
  final double amount;
  final String category;

  FinanceEntry({required this.amount, required this.category});

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'category': category,
    };
  }

  factory FinanceEntry.fromJson(Map<String, dynamic> json) {
    return FinanceEntry(
      amount: json['amount'],
      category: json['category'],
    );
  }
}

class FinanceManager {
  static const String keyTransactions = 'transactions';

  Future<void> addTransaction(FinanceEntry transaction) async {
    final transactions = await loadTransactions();
    transactions.add(transaction);
    await saveTransactions(transactions);
  }

  Future<List<FinanceEntry>> loadTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    final transactionsJson = prefs.getStringList(keyTransactions);

    if (transactionsJson != null) {
      return transactionsJson
          .map((json) => FinanceEntry.fromJson(jsonDecode(json)))
          .toList();
    }

    return [];
  }

  Future<void> saveTransactions(List<FinanceEntry> transactions) async {
    final prefs = await SharedPreferences.getInstance();
    final transactionsJson = transactions
        .map((transaction) => jsonEncode(transaction.toJson()))
        .toList();
    prefs.setStringList(keyTransactions, transactionsJson);
  }
}