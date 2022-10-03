import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:takvim_uygulamasi/Provider/ViewModels/user_view_model.dart';
import 'package:takvim_uygulamasi/screens/siparis/siparis_listesi.dart';
import 'package:takvim_uygulamasi/screens/siparis/urun_ekle.dart';

class HomeOrder extends StatefulWidget {
  const HomeOrder({Key key}) : super(key: key);

  @override
  _HomeOrderState createState() => _HomeOrderState();
}

class _HomeOrderState extends State<HomeOrder> {
  int secilenMenuItem = 0;
  UserViewModel _userViewModel;
  OrderList _OrderList = OrderList();
  AddProduct _AddProduct = AddProduct();
  @override
  void initState() {
    super.initState();
    _OrderList = OrderList();
    _AddProduct = AddProduct();
  }

  @override
  Widget build(BuildContext context) {
    _userViewModel = Provider.of<UserViewModel>(context, listen: false);
    return Scaffold(
      bottomNavigationBar: bottomNavMenu(),
      appBar: AppBar(
        title: Text("Siparişler"),
        actions: [
          InkWell(
              onTap: () {
                _userViewModel.logout(context);
              },
              child: Icon(Icons.logout)),
        ],
      ),
      body: Container(
        child: IndexedStack(
          children: [_OrderList, _AddProduct],
          index: secilenMenuItem,
        ),
      ),
    );
  }

  Widget bottomNavMenu() {
    return Container(
      child: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.list,
            ),
            label: "Siparişler",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.add,
            ),
            label: "Urun Ekle",
          ),
        ],
        currentIndex: secilenMenuItem,
        onTap: (index) {
          setState(() {
            secilenMenuItem = index;
          });
        },
      ),
    );
  }
}
