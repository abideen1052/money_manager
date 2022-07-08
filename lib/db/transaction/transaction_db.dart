import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:money_manager/models/transactions/transaction_model.dart';

const TRANSACTION_DB_NAME = 'transactin-db';

abstract class TransactionDbFunctions {
  Future<void> addTransaction(TransactioModel obj);
  Future<List<TransactioModel>> getAllTransactions();
  Future<void> deleteTransaction(String id);
}

class TransactionDb implements TransactionDbFunctions {
  TransactionDb._internal();
  static TransactionDb instance = TransactionDb._internal();
  factory TransactionDb() {
    return instance;
  }

  ValueNotifier<List<TransactioModel>> transactionListNotifier =
      ValueNotifier([]);
  @override
  Future<void> addTransaction(TransactioModel obj) async {
    final _db = await Hive.openBox<TransactioModel>(TRANSACTION_DB_NAME);
    await _db.put(obj.id, obj);
  }

  Future<void> refresh() async {
    final _list = await getAllTransactions();
    _list.sort((first, second) => second.date.compareTo(first.date));
    transactionListNotifier.value.clear();
    transactionListNotifier.value.addAll(_list);
    transactionListNotifier.notifyListeners();
  }

  @override
  Future<List<TransactioModel>> getAllTransactions() async {
    final _db = await Hive.openBox<TransactioModel>(TRANSACTION_DB_NAME);
    return _db.values.toList();
  }

  @override
  Future<void> deleteTransaction(String id) async {
    final _db = await Hive.openBox<TransactioModel>(TRANSACTION_DB_NAME);
    await _db.delete(id);
    refresh();
  }
}
