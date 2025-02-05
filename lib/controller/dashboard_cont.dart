import 'package:eventapp/view/home/home_page.dart';
import 'package:get/get.dart';

import '../view/home/favourite_page.dart';
import '../view/home/myEvent_page.dart';
import '../view/home/ticket_page.dart';

class DashboardController extends GetxController{
  final RxInt selectedIndex = 0.obs;

  final screens = [
    HomePage(),
    FavouritePage(),
    EventPage(),
    TicketPage(),
  ];
  /*var tabIndex = 0;

  void changeTableIndex(int index){
    tabIndex = index;
    update();
  }*/
}