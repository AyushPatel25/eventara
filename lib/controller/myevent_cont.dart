import 'package:get/get.dart';

class EventController extends GetxController{
  var selectedDate = DateTime.now().obs;
  var focusedDate = DateTime.now().obs;

  void onDaySelected(DateTime selectedDay, DateTime focusedDay){
    selectedDate.value = selectedDay;
    focusedDate.value = focusedDay;
  }
}