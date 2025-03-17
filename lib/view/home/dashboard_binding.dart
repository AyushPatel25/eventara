import 'package:eventapp/controller/OTPTimer_cont.dart';
import 'package:eventapp/controller/favourite_cont.dart';
import 'package:eventapp/controller/home_cont.dart';
import 'package:eventapp/controller/loc_cont.dart';
import 'package:eventapp/controller/profile_cont.dart';
import 'package:eventapp/controller/ticket_cont.dart';
import 'package:get/get.dart';
import 'package:eventapp/controller/dashboard_cont.dart';

class DashboardBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<OtpController>(()=> OtpController());
    Get.lazyPut<LocationController>(()=> LocationController());
    Get.lazyPut<DashboardController>(() => DashboardController());
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<FavouriteController>(() => FavouriteController());
    Get.lazyPut<TicketController>(() => TicketController());
    Get.lazyPut<ProfileController>(() => ProfileController());
  }

}