import 'package:flutter/material.dart';
import 'package:money_manager/screens/add_transaction/screen_add_transaction.dart';
import 'package:money_manager/screens/catagory/category_add_popup.dart';
import 'package:money_manager/screens/catagory/screen_catogory.dart';
import 'package:money_manager/screens/home/widgets/bottom_navigation.dart';
import 'package:money_manager/screens/transactions/screen_transaction.dart';

class ScreenHome extends StatelessWidget {
  const ScreenHome({Key? key}) : super(key: key);

  static ValueNotifier<int> selectedIndexNotifier = ValueNotifier(0);
  final _pages = const [
    ScreenTransaction(),
    ScreenCatogory(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          title: Text('Money Manager'),
        ),
        bottomNavigationBar: const MoneyBottomNavigation(),
        body: SafeArea(
          child: ValueListenableBuilder(
            valueListenable: selectedIndexNotifier,
            builder: (BuildContext context, int updatedIndex, _) {
              return _pages[updatedIndex];
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (selectedIndexNotifier.value == 0) {
              print('Add Transaction');
              Navigator.of(context).pushNamed(ScreenaddTransaction.routeName);
            } else {
              print('Add Catogories');
              showCategoryAddPopup(context);
              // final _sample = CategoryModel(
              //   id: DateTime.now().millisecondsSinceEpoch.toString(),
              //   name: 'Travel',
              //   type: CategoryType.expense,
              // );
              // CategoryDb().insertCategory(_sample);
            }
          },
          child: const Icon(Icons.add),
        ));
  }
}
