import 'package:eventapp/controller/myevent_cont.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../componets/text_style.dart';
import '../../generated/assets.dart';
import '../../utills/appcolors.dart';

class EventPage extends GetView<EventController> {
  EventPage({super.key});

  EventController eventController = Get.put(EventController());

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.black,
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                surfaceTintColor: Colors.black,
                backgroundColor: Colors.black,
                title: TextStyleHelper.CustomText(
                  text: 'Events',
                  color: AppColors.whiteColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 25,
                  fontFamily: Assets.fontsPoppinsBold,
                ),
              ),
              SliverToBoxAdapter(
                child: Obx(() => TableCalendar(
                  headerStyle: HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                    titleTextStyle: TextStyle(
                      fontFamily: Assets.fontsPoppinsBold,
                    ),
                  ),
                  calendarStyle: CalendarStyle(
                      todayTextStyle: TextStyle(
                        color: AppColors.primaryColor,
                      ),
                      todayDecoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.primaryColor)
                      ),
                      selectedTextStyle: TextStyle(
                        color: Colors.black,
                      ),
                      selectedDecoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        shape: BoxShape.circle,
                      )
                  ),
                  availableGestures: AvailableGestures.all,
                  focusedDay: eventController.selectedDate.value,
                  selectedDayPredicate: (day) => isSameDay(eventController.selectedDate.value, day),
                  onDaySelected: (selectedDay, focusedDay) => eventController.onDaySelected(selectedDay, focusedDay),
                  firstDay: DateTime.utc(2025, 1, 1),
                  lastDay: DateTime.utc(2075, 12, 31),
                ),
                )
              )
              /*SliverAppBar(
                pinned: true,
                surfaceTintColor: Colors.black,
                backgroundColor: Colors.black,
                flexibleSpace: TabBar(
                  tabAlignment: TabAlignment.start,
                  isScrollable: true,
                  indicatorColor: AppColors.whiteColor,
                  labelColor: AppColors.whiteColor,
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 15,
                    fontFamily: Assets.fontsPoppinsBold,
                  ),
                  unselectedLabelColor: AppColors.lightGrey,
                  unselectedLabelStyle: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 15,
                    fontFamily: Assets.fontsPoppinsBold,
                  ),
                  tabs: const [
                    Tab(text: "Upcoming"),
                    Tab(text: "Past events"),
                  ],
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: TabBarView(
                    children: [
                      Center(
                        child: Text(
                          'Upcoming Events',
                          style: TextStyle(color: AppColors.whiteColor, fontSize: 20),
                        ),
                      ),
                      Center(
                        child: Text(
                          'Past Events',
                          style: TextStyle(color: AppColors.whiteColor, fontSize: 20),
                        ),
                      ),
                    ],
                  ),
                ),
              ),*/
            ],
          ),
        ),
      ),
    );
  }
}
