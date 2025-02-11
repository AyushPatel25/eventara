import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../model/event_model.dart';

class HomeController extends GetxController {
  static HomeController get instance => Get.find();
  final RxInt curousalCurrentIndex = 0.obs;

  var favoriteEvents = <int>{}.obs;
  var indexCategory = 0.obs;
  var isLoading = true.obs;

  var events = <EventModel>[].obs;
  var filteredEvents = <EventModel>[].obs;
  var selectedCategory = 'All'.obs;

  @override
  void onInit() {
    super.onInit();
    fetchEvents();
  }

  void updateCategory(int index) {
    indexCategory.value = index;
    selectedCategory.value = _getCategoryName(index);
    filterEvents();
  }

  void updatePageIndecator(int index) {
    curousalCurrentIndex.value = index;
  }

  void toggleFavourite(int index) {
    if (favoriteEvents.contains(index)) {
      favoriteEvents.remove(index);
    } else {
      favoriteEvents.add(index);
    }
  }

  Future<void> fetchEvents() async {
    try {
      isLoading.value = true;
      QuerySnapshot snapshot =
      await FirebaseFirestore.instance.collection('eventDetails').get();

      events.value = snapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        return EventModel.fromJson(data);
      }).toList();

      filteredEvents.value = events; // Show all initially
    } catch (e) {
      print("Error fetching events: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void filterEvents() {
    if (selectedCategory.value == "All") {
      filteredEvents.value = events;
    } else {
      filteredEvents.value =
          events.where((event) => event.category == selectedCategory.value).toList();
    }
  }

  String _getCategoryName(int index) {
    List<String> categories = ["All", "Concert", "Comedy", "Sport", "Party", "Show"];
    return categories[index];
  }
}
