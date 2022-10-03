import 'package:device_calendar/device_calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:takvim_uygulamasi/Provider/ViewModels/order_view_model.dart';
import 'package:takvim_uygulamasi/Provider/ViewModels/product_view_model.dart';
import 'package:takvim_uygulamasi/Provider/ViewModels/user_view_model.dart';
import 'package:takvim_uygulamasi/models/ProductQuantity.dart';
import 'package:takvim_uygulamasi/models/UsersModel.dart';

class AddOrder extends StatefulWidget {
  const AddOrder({Key key}) : super(key: key);

  @override
  _AddOrderState createState() => _AddOrderState();
}

class _AddOrderState extends State<AddOrder> {
  List<ProductQuantity> _list = [];
  UserViewModel _userViewModel;
  ProductViewModel _productViewModel;
  OrderViewModel _orderViewModel;

  int adet;
  var formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      getUrun();
      getRoom();
    });
  }

  getUrun() async {
    if (_userViewModel == null || _productViewModel == null) {
      _userViewModel = await Provider.of<UserViewModel>(context, listen: false);
      _productViewModel =
          await Provider.of<ProductViewModel>(context, listen: false);
      _orderViewModel =
          await Provider.of<OrderViewModel>(context, listen: false);
    }

    await _productViewModel.getProduct(_userViewModel.getToken);

    setState(() {});
  }

  String dropdownValue;
  String salon;
  List<Users> _meetingRoom = [];
  getRoom() async {
    // ignore: await_only_futures
    _userViewModel = await Provider.of<UserViewModel>(context, listen: false);
    await _userViewModel.getMeetingRoom(_userViewModel.getToken);
    await _userViewModel.getRoom.map((room) {
      if (room.toplantiOdasiMi && room.toplantiSalonAdi != null) {
        _meetingRoom.add(
            new Users(id: room.id, toplantiSalonAdi: room.toplantiSalonAdi));
      }
    }).toList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    _userViewModel = Provider.of<UserViewModel>(context, listen: false);
    _productViewModel = Provider.of<ProductViewModel>(context, listen: false);
    _orderViewModel = Provider.of<OrderViewModel>(context, listen: false);
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: Text("Sipariş Ver")),
      body: Container(
        width: width,
        height: height,
        child: Column(
          children: [
            Container(
              width: width,
              height: height - 85,
              /* decoration: BoxDecoration(
                    color: const Color(0xff292929),
                    border: Border.all(width: 1.0, color: const Color(0xff707070)),
                  ), */
              child: Column(
                children: <Widget>[
                  Container(
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.only(
                                left: 10.0, right: 10.0, top: 20),
                            child: Text("Toplantı Salonu"),
                          ),
                          Container(
                            padding:
                                const EdgeInsets.only(left: 10.0, right: 10.0),
                            alignment: Alignment.centerLeft,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              child: DropdownButton<String>(
                                  isExpanded: true,
                                  value: salon,
                                  icon: Icon(Icons.arrow_downward),
                                  iconSize: 24,
                                  elevation: 16,
                                  /*  style: TextStyle(color: Colors.deepPurple), */
                                  underline: Container(
                                    height: 1,
                                    color: Colors.grey,
                                  ),
                                  hint: Text("Toplanti Salonu Seçiniz"),
                                  onChanged: (newValue) {
                                    setState(() {
                                      salon = newValue;
                                    });
                                  },
                                  items: _meetingRoom.map((room) {
                                    return DropdownMenuItem(
                                      child: Text(room..meetingRoomName),
                                      value: room.id,
                                    );
                                  }).toList()),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Divider(
                    height: 2,
                    color: Colors.black,
                  ),
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          height: height - 290,
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: _productViewModel.getProductList.length,
                            itemBuilder: (context, index) {
                              return Container(
                                child: ListTile(
                                  title: Text(_productViewModel
                                      .getProductList[index].productName),
                                  trailing: Container(
                                    width: 100,
                                    padding: const EdgeInsets.only(left: 20),
                                    child: TextFormField(
                                      decoration: const InputDecoration(
                                          labelText: 'Adet', hintText: ''),
                                      onChanged: (String value) {
                                        adet = int.parse(value);
                                        _list.add(new ProductQuantity(
                                            _productViewModel
                                                .getProductList[index].id,
                                            adet));
                                      },
                                      autofocus: false,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      await _orderViewModel.setOrder(
                          _userViewModel.getToken, salon, _list);
                      Navigator.pop(context, "success");
                    },
                    child: Container(
                      width: width * 0.3,
                      height: height * 0.05,
                      margin: EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(19.0),
                        color: Colors.blue,
                        border: Border.all(
                            width: 2.0, color: const Color(0xffffffff)),
                      ),
                      child: Center(
                        child: Text(
                          'Kaydet',
                          style: TextStyle(
                            fontFamily: 'Segoe UI',
                            fontSize: 16,
                            color: const Color(0xffffffff),
                            fontWeight: FontWeight.w700,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
