import 'package:eventapp/view/home/home_page.dart';
import 'package:eventapp/view/organizer/create_event.dart';
import 'package:eventapp/view/organizer/organizer_home.dart';
import 'package:get/get.dart';


class OrgDashController extends GetxController{
  final RxInt selectedIndex = 0.obs;

  final screens = [
    OrganizerHome(),
    CreateEvent()
  ];
/*var tabIndex = 0;

  void changeTableIndex(int index){
    tabIndex = index;
    update();
  }*/
}