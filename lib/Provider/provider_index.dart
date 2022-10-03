import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:takvim_uygulamasi/Provider/ViewModels/meeting_room_view_model.dart';
import 'package:takvim_uygulamasi/Provider/ViewModels/meeting_view_model.dart';
import 'package:takvim_uygulamasi/Provider/ViewModels/user_view_model.dart';

import '../locator.dart';
import 'ViewModels/order_view_model.dart';
import 'ViewModels/product_view_model.dart';

class ProviderIndex extends StatelessWidget {
  Widget child;
  ProviderIndex({this.child});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserViewModel>(
          create: (context) => locator<UserViewModel>(),
        ),
        ChangeNotifierProvider<MeetingViewModel>(
          create: (context) => locator<MeetingViewModel>(),
        ),
        ChangeNotifierProvider<MeetingRoomViewModel>(
          create: (context) => locator<MeetingRoomViewModel>(),
        ),
        ChangeNotifierProvider<SiparisViewModel>(
          create: (context) => locator<SiparisViewModel>(),
        ),
        ChangeNotifierProvider<UrunViewModel>(
          create: (context) => locator<UrunViewModel>(),
        ),
      ],
      // builder: (context) => locator<BankalarViewModel>(),
      child: this.child,
    );
  }
}
