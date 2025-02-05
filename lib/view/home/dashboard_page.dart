import 'package:eventapp/controller/dashboard_cont.dart';
import 'package:eventapp/utills/appcolors.dart';
import 'package:eventapp/view/home/favourite_page.dart';
import 'package:eventapp/view/home/home_page.dart';
import 'package:eventapp/view/home/myEvent_page.dart';
import 'package:eventapp/view/home/ticket_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DashboardController());
    return GetBuilder<DashboardController>(
        builder: (controller){
          return Scaffold(
            backgroundColor: Colors.black,
            /*body: SafeArea(
              child: IndexedStack(
                index: controller.tabIndex,
                children: [
                  HomePage(),
                  FavouritePage(),
                  EventPage(),
                  TicketPage(),
                ],
              ),
            ),*/
            body: Obx(() => controller.screens[controller.selectedIndex.value]),

            bottomNavigationBar: /*Obx(
                () => NavigationBar(
                    height: 80,
                    elevation: 0,
                    backgroundColor: Colors.black,
                    surfaceTintColor: AppColors.lightGrey,
                    indicatorColor: Colors.transparent,
                    shadowColor: Colors.black,
                    selectedIndex: controller.selectedIndex.value,
                    onDestinationSelected: (index) => controller.selectedIndex.value = index,

                    destinations: [
                      _bottomNavigationBarItem(
                        icon: Icons.home,
                        label: 'Home',
                      ),
                      _bottomNavigationBarItem(
                        icon: Icons.favorite,
                        label: 'Favourite',
                      ),
                      _bottomNavigationBarItem(
                        icon: Icons.event_available,
                        label: 'Event',
                      ),
                      _bottomNavigationBarItem(
                        icon: Icons.airplane_ticket,
                        label: 'Ticket',
                      )
                    ]
                )
            ),*/
            /*bottomNavigationBar:*/ Obx(
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
                    _bottomNavigationBarItem(
                      icon: Iconsax.home_copy,
                      label: 'Home',
                    ),
                    _bottomNavigationBarItem(
                      icon: Iconsax.heart_copy,
                      label: 'Favourite',
                    ),
                    _bottomNavigationBarItem(
                      icon: Iconsax.calendar_1_copy,
                      label: 'Event',
                    ),
                    _bottomNavigationBarItem(
                      icon: Iconsax.ticket_copy,
                      label: 'Ticket',
                    )
                  ]),
          ),
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
