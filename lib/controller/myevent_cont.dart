import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:table_calendar/table_calendar.dart';
import '../model/event_model.dart';

class EventController extends GetxController {
  var selectedDate = DateTime.now().obs;
  var focusedDate = DateTime.now().obs;
  var events = <DateTime, List<EventModel>>{}.obs;
  var selectedEvents = <EventModel>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchEvents();
  }

  DateTime convertStringToDate(String dateStr) {
    try {
      List<String> parts = dateStr.trim().split(' ');

      Map<String, int> months = {
        'Jan': 1, 'Feb': 2, 'Mar': 3, 'Apr': 4,
        'May': 5, 'Jun': 6, 'Jul': 7, 'Aug': 8,
        'Sep': 9, 'Oct': 10, 'Nov': 11, 'Dec': 12
      };

      int day = int.parse(parts[0]);
      int month = months[parts[1]] ?? 1;
      int year = int.parse(parts[2]);

      return DateTime(year, month, day);
    } catch (e) {
      print('Date parsing error: $e for date string: $dateStr');
      return DateTime.now();
    }
  }

  bool isSameDate(DateTime? date1, DateTime? date2) {
    if (date1 == null || date2 == null) return false;
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  bool isDateInFutureOrToday(DateTime date) {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime compareDate = DateTime(date.year, date.month, date.day);
    return compareDate.isAfter(today) || compareDate.isAtSameMomentAs(today);
  }

  Future<void> fetchEvents() async {
    try {
      isLoading.value = true;
      events.clear();

      var snapshot = await FirebaseFirestore.instance
          .collection('eventDetails')
          .get();

      // Get today's date for comparison
      DateTime now = DateTime.now();
      DateTime today = DateTime(now.year, now.month, now.day);

      for (var doc in snapshot.docs) {
        var data = doc.data();
        var event = EventModel.fromJson(data);

        DateTime eventDate = convertStringToDate(event.eventDate);
        eventDate = DateTime(eventDate.year, eventDate.month, eventDate.day);

        // Only add the event if it's today or in the future
        if (eventDate.isAfter(today) || eventDate.isAtSameMomentAs(today)) {
          if (events.containsKey(eventDate)) {
            events[eventDate]!.add(event);
          } else {
            events[eventDate] = [event];
          }
        }
      }

      updateSelectedEvents(selectedDate.value);

    } catch (e) {
      print('Error fetching events: $e');
    } finally {
      isLoading.value = false;
    }
  }

  List<EventModel> getEventsForDay(DateTime day) {
    DateTime dateWithoutTime = DateTime(day.year, day.month, day.day);

    // Only return events for today or future dates
    if (isDateInFutureOrToday(dateWithoutTime)) {
      return events[dateWithoutTime] ?? [];
    }
    return [];
  }

  void updateSelectedEvents(DateTime date) {
    DateTime dateWithoutTime = DateTime(date.year, date.month, date.day);

    // Only show events in the selected events list if the date is today or in the future
    if (isDateInFutureOrToday(dateWithoutTime)) {
      selectedEvents.assignAll(events[dateWithoutTime] ?? []);
    } else {
      selectedEvents.clear();
    }
  }

  void onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    selectedDate.value = selectedDay;
    focusedDate.value = focusedDay;
    updateSelectedEvents(selectedDay);
  }
}