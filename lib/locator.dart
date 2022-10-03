import 'package:get_it/get_it.dart';
import 'package:takvim_uygulamasi/Provider/ViewModels/abstract/meeting_view_interface.dart';
import 'package:takvim_uygulamasi/Provider/ViewModels/abstract/order_view_interface.dart';
import 'package:takvim_uygulamasi/Provider/ViewModels/abstract/product_view_interface.dart';
import 'package:takvim_uygulamasi/Provider/ViewModels/abstract/user_view_interface.dart';
import 'package:takvim_uygulamasi/Provider/ViewModels/order_view_model.dart';
import 'package:takvim_uygulamasi/Provider/api/abstract/meetingRoom_api_interface.dart';
import 'package:takvim_uygulamasi/Provider/api/abstract/meeting_api_interface.dart';
import 'package:takvim_uygulamasi/Provider/api/abstract/order_api_interface.dart';
import 'package:takvim_uygulamasi/Provider/api/abstract/product_api_interface.dart';
import 'package:takvim_uygulamasi/Provider/api/abstract/user_api_interface.dart';
import 'package:takvim_uygulamasi/Provider/api/concrete/meetingRoom_api_client.dart';
import 'package:takvim_uygulamasi/Provider/api/concrete/meeting_api_client.dart';
import 'package:takvim_uygulamasi/Provider/api/concrete/order_api_client.dart';
import 'package:takvim_uygulamasi/Provider/api/concrete/product_api_client.dart';
import 'package:takvim_uygulamasi/Provider/api/concrete/user_api_client.dart';

import 'Provider/ViewModels/meeting_room_view_model.dart';
import 'Provider/ViewModels/meeting_view_model.dart';
import 'Provider/ViewModels/product_view_model.dart';
import 'Provider/ViewModels/user_view_model.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  /* locator.registerLazySingleton(()=> WidgetADI()) */
  locator.registerSingleton<UserApiInterface>(UserApiClient());
  locator.registerSingleton<UserViewInterface>(UserViewModel());

  locator.registerSingleton<MeetingApiInterface>(MeetingApiClient());
  locator.registerSingleton<MeetingViewInterface>(MeetingViewModel());

  locator.registerSingleton<MeetingRoomApiInterface>(MeetingRoomApiClient());
  locator.registerSingleton<MeetingViewInterface>(MeetingRoomViewModel());
  locator.registerSingleton<OrderApiInterface>(OrderApiClient());
  locator.registerSingleton<OrderViewInterface>(OrderViewModel());

  locator.registerSingleton<ProductApiInterface>(ProductApiClient());
  locator.registerSingleton<ProductViewInterface>(ProductViewModel());
}
