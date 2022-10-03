import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:takvim_uygulamasi/Provider/ViewModels/order_view_model.dart';
import 'package:takvim_uygulamasi/Provider/ViewModels/user_view_model.dart';
import 'package:takvim_uygulamasi/models/Order.dart';

class OrderDetail extends StatefulWidget {
  final Siparis _siparis;
  OrderDetail(this._siparis);
  @override
  _OrderDetailState createState() => _OrderDetailState();
}

class _OrderDetailState extends State<OrderDetail> {
  UserViewModel _userViewModel;
  OrderViewModel _orderViewModel;
  @override
  Widget build(BuildContext context) {
    _userViewModel = Provider.of<UserViewModel>(context, listen: false);
    _orderViewModel = Provider.of<OrderViewModel>(context, listen: false);
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget._siparis.meetingRoom}"),
      ),
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.only(top: 20, left: 20, right: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DataTable(
              columns: const <DataColumn>[
                DataColumn(
                  label: Text(
                    'Urun Adı',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Adet',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
              ],
              rows: widget._siparis.urun
                  .map((e) => DataRow(cells: [
                        DataCell(Text(e.urunler.urunAdi)),
                        DataCell(Text(e.adet.toString())),
                      ]))
                  .toList(),
            ),
            widget._siparis.teslimEdildiMi
                ? Container()
                : InkWell(
                    onTap: () async {
                      await _orderViewModel.siparisTeslim(
                          _userViewModel.getToken, widget._siparis.id, true);
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
                          'Teslim Edildi',
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
    );
  }
}

/*   */