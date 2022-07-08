// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:money_manager/db/catogory/category_db.dart';
import 'package:money_manager/db/transaction/transaction_db.dart';
import 'package:money_manager/models/category/catogary_model.dart';
import 'package:money_manager/models/transactions/transaction_model.dart';

ValueNotifier<CategoryType> selectedCategoryNotifier =
    ValueNotifier(CategoryType.income);

class ScreenaddTransaction extends StatefulWidget {
  static const routeName = 'add_transaction';
  const ScreenaddTransaction({Key? key}) : super(key: key);

  @override
  State<ScreenaddTransaction> createState() => _ScreenaddTransactionState();
}

class _ScreenaddTransactionState extends State<ScreenaddTransaction> {
  DateTime? _selectedDate;
  CategoryType? _selectedCategoryType;
  CategoryModel? _selectedCategoryModel;
  String? _categoryId;
  final _purposeTextEditingController = TextEditingController();
  final _amountTextEditingController = TextEditingController();

  @override
  void initState() {
    _selectedCategoryType = CategoryType.income;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _purposeTextEditingController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                hintText: 'Purpose',
              ),
            ),
            TextFormField(
              controller: _amountTextEditingController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Amount',
              ),
            ),
            TextButton.icon(
              onPressed: () async {
                final _selectedDateTemp = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now().subtract(Duration(days: 30)),
                  lastDate: DateTime.now(),
                );
                if (_selectedDateTemp == null) {
                  return;
                } else {
                  print(_selectedDateTemp.toString());
                  setState(() {
                    _selectedDate = _selectedDateTemp;
                  });
                }
              },
              icon: Icon(Icons.calendar_today),
              label: Text(_selectedDate == null
                  ? 'Select Date'
                  : _selectedDate!.toString()),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  children: [
                    ValueListenableBuilder(
                        valueListenable: selectedCategoryNotifier,
                        builder: (BuildContext ctx, CategoryType newCategory,
                            Widget? _) {
                          return Radio<CategoryType>(
                            value: CategoryType.income,
                            groupValue: _selectedCategoryType,
                            onChanged: (newValue) {
                              setState(() {
                                _selectedCategoryType = CategoryType.income;
                                _categoryId = null;
                              });
                              // if (newValue == null) {
                              //   return;
                              // } else {
                              //   selectedCategoryNotifier.value = newValue;
                              //   selectedCategoryNotifier.notifyListeners();
                              // }
                              // print(newValue);
                            },
                          );
                        }),
                    Text('Income'),
                  ],
                ),
                Row(
                  children: [
                    ValueListenableBuilder(
                        valueListenable: selectedCategoryNotifier,
                        builder: (BuildContext ctx, CategoryType newCategory,
                            Widget? _) {
                          return Radio<CategoryType>(
                            value: CategoryType.expense,
                            groupValue: _selectedCategoryType,
                            onChanged: (newValue) {
                              setState(() {
                                _selectedCategoryType = CategoryType.expense;
                                _categoryId = null;
                              });
                              // if (newValue == null) {
                              //   return;
                              // } else {
                              //   selectedCategoryNotifier.value = newValue;
                              //   selectedCategoryNotifier.notifyListeners();
                              // }
                              // print(newValue);
                            },
                          );
                        }),
                    Text('Expense'),
                  ],
                ),
              ],
            ),
            DropdownButton<String>(
              hint: Text('Select Category'),
              value: _categoryId,
              items: (_selectedCategoryType == CategoryType.income
                      ? CategoryDb().incomeCategoryListListener
                      : CategoryDb().expenseCategoryListListener)
                  .value
                  .map((e) {
                return DropdownMenuItem(
                  value: e.id,
                  child: Text(e.name),
                  onTap: () {
                    _selectedCategoryModel = e;
                  },
                );
              }).toList(),
              onChanged: (selectedValue) {
                print(selectedValue);
                setState(() {
                  _categoryId = selectedValue;
                });
              },
              onTap: () {},
            ),
            ElevatedButton(
              onPressed: () {
                addTrnsaction();
              },
              child: Text('Submit'),
            ),
          ],
        ),
      )),
    );
  }

  Future<void> addTrnsaction() async {
    final _purposeText = _purposeTextEditingController.text;
    final _amountText = _amountTextEditingController.text;
    if (_purposeText.isEmpty) {
      return;
    }
    if (_amountText.isEmpty) {
      return;
    }
    // if (_categoryId == null) {
    //   return;
    // }
    if (_selectedDate == null) {
      return;
    }
    if (_selectedCategoryModel == null) {
      return;
    }
    final _parsedAmount = double.tryParse(_amountText);
    if (_parsedAmount == null) {
      return;
    }
    // _selectedDate
    //_selectedCategoryType
    //_categoryId
    final _model = TransactioModel(
      purpose: _purposeText,
      amount: _parsedAmount,
      date: _selectedDate!,
      type: _selectedCategoryType!,
      category: _selectedCategoryModel!,
    );
    await TransactionDb.instance.addTransaction(_model);
    Navigator.of(context).pop();
    TransactionDb.instance.refresh();
  }
}
