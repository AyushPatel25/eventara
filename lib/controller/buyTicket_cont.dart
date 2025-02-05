import 'package:eventapp/model/TicketCategory.dart';
import 'package:get/get.dart';

class BuyTicketController extends GetxController {
  var categories = <TicketCategory>[
    TicketCategory(name: "Diamond", price: 5000, spots: 1000),
    TicketCategory(name: "Gold", price: 3000, spots: 500),
    TicketCategory(name: "Silver", price: 2000, spots: 200),
  ].obs;

  void increment(int index) {
    if (categories[index].selectedTickets.value < categories[index].availableSpots.value) {
      categories[index].selectedTickets.value++;
    }
  }

  void decrement(int index) {
    if (categories[index].selectedTickets.value > 0) {
      categories[index].selectedTickets.value--;
    }
  }

  void purchase(int index) {
    if (categories[index].availableSpots.value >= categories[index].selectedTickets.value) {
      categories[index].availableSpots.value -= categories[index].selectedTickets.value;
    }
  }
}