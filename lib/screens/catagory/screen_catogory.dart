import 'package:flutter/material.dart';
import 'package:money_manager/db/catogory/category_db.dart';
import 'package:money_manager/screens/catagory/expense_list.dart';
import 'package:money_manager/screens/catagory/income_list.dart';

class ScreenCatogory extends StatefulWidget {
  const ScreenCatogory({Key? key}) : super(key: key);

  @override
  _ScreenCatogoryState createState() => _ScreenCatogoryState();
}

class _ScreenCatogoryState extends State<ScreenCatogory>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    CategoryDb().refreshUI();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey,
          tabs: const [
            Tab(
              text: 'Income',
            ),
            Tab(
              text: 'Expense',
            ),
          ],
        ),
        Expanded(
          child: TabBarView(controller: _tabController, children: const [
            IncomeList(),
            ExpenseList(),
          ]),
        )
      ],
    );
  }
}
