import 'package:eventapp/controller/dashboard_cont.dart';
import 'package:eventapp/utills/appcolors.dart';
import 'package:eventapp/view/home/favourite_page.dart';
import 'package:eventapp/view/home/home_page.dart';
import 'package:eventapp/view/home/myEvent_page.dart';
import 'package:eventapp/view/home/ticket_page.dart';
import 'package:eventapp/view/organizer/controller/org_dash_cont.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class OrganizerDashboard extends StatelessWidget {
  const OrganizerDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OrgDashController());
    return GetBuilder<OrgDashController>(
        builder: (controller){
          return Scaffold(
              backgroundColor: Colors.black,
              body: Obx(() => controller.screens[controller.selectedIndex.value]),

              bottomNavigationBar:
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 0),
                    child: Divider(
                      color: AppColors.greyColor,
                      thickness: 1,
                      height: 1,
                    ),
                  ),
                  Obx(
                        () => BottomNavigationBar(
                      backgroundColor: Colors.black,
                      unselectedItemColor: AppColors.lightGrey,
                      selectedItemColor: AppColors.whiteColor,
                      onTap: controller.selectedIndex.call,
                      currentIndex: controller.selectedIndex.value,
                      showSelectedLabels: false,
                      showUnselectedLabels: false,
                      type: BottomNavigationBarType.fixed,
                      items: [
                        _bottomNavigationBarItem(icon: Iconsax.home_copy, label: 'Home'),
                        _bottomNavigationBarItem(icon: Iconsax.add_square_copy, label: 'Favourite'),
                        // _bottomNavigationBarItem(icon: Iconsax.calendar_1_copy, label: 'Event'),
                        // _bottomNavigationBarItem(icon: Iconsax.ticket_copy, label: 'Ticket'),
                      ],
                    ),
                  ),
                ],
              )

          );
        }
    );
  }
  _bottomNavigationBarItem({required IconData icon, required String label}){
    return BottomNavigationBarItem(
      icon: Icon(icon, size: 25,),
      label: label,
    );
  }
}
