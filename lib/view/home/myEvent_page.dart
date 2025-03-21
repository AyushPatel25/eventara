
import 'package:eventapp/controller/myevent_cont.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../componets/filterDateWidget.dart';
import '../../componets/text_style.dart';
import '../../generated/assets.dart';
import '../../model/event_model.dart';
import '../../utills/appcolors.dart';

class EventPage extends GetView<EventController> {
  EventPage({super.key});

  EventController eventController = Get.put(EventController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Obx(() => TableCalendar<EventModel>(
                  headerStyle: HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                    titleTextStyle: TextStyle(
                      fontFamily: Assets.fontsPoppinsBold,
                      color: AppColors.whiteColor,
                    ),
                  ),
                  calendarStyle: CalendarStyle(
                    defaultTextStyle: TextStyle(color: AppColors.whiteColor),
                    weekendTextStyle: TextStyle(color: AppColors.whiteColor),
                    outsideTextStyle: TextStyle(color: AppColors.lightGrey),
                    todayTextStyle: TextStyle(
                      color: AppColors.primaryColor,
                    ),
                    todayDecoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.primaryColor)),
                    selectedTextStyle: TextStyle(
                      color: Colors.black,
                    ),
                    selectedDecoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      shape: BoxShape.circle,
                    ),
                    markerDecoration: BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                    markersMaxCount: 1,
                    markerSize: 6,
                  ),
                  availableGestures: AvailableGestures.all,
                  focusedDay: eventController.focusedDate.value,
                  firstDay: DateTime.utc(2025, 1, 1),
                  lastDay: DateTime.utc(2075, 12, 31),
                  selectedDayPredicate: (day) =>
                      eventController.isSameDate(eventController.selectedDate.value, day),
                  onDaySelected: eventController.onDaySelected,
                  eventLoader: eventController.getEventsForDay,
                )),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextStyleHelper.CustomText(
                  text: 'Events on Selected Date',
                  color: AppColors.whiteColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  fontFamily: Assets.fontsPoppinsBold,
                ),
              ),
            ),
            Obx(() {
              if (eventController.isLoading.value) {
                return SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryColor,
                    ),
                  ),
                );
              }

              if (eventController.selectedEvents.isEmpty) {
                return SliverFillRemaining(
                  child: Center(
                    child: TextStyleHelper.CustomText(
                      text: 'No events on this date',
                      color: AppColors.lightGrey,
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                      fontFamily: Assets.fontsPoppinsRegular,
                    ),
                  ),
                );
              }

              return SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: FilterDateWidget(index: index), // Updated to FilterDateWidget
                    );
                  },
                  childCount: eventController.selectedEvents.length,
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}