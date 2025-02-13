import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class FilterController extends GetxController {
  RxList<Map<String, dynamic>> events = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> filteredEvents = <Map<String, dynamic>>[].obs;
  RxMap<String, bool> selectedFilters = {
    'Concert': false,
    'Comedy': false,
    'Sport': false,
    'Party': false,
    'Show': false,
  }.obs;
  RxString searchQuery = ''.obs;

  @override
  void onInit() {
    fetchEvents(); // Fetch events when the controller initializes
    super.onInit();
  }

  Future<void> fetchEvents() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('eventDetails').get();
      List<Map<String, dynamic>> eventList = snapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        data['eventId'] = doc.id; // Store Firestore document ID as eventId
        return data;
      }).toList();

      events.assignAll(eventList);
      filteredEvents.assignAll(eventList);
    } catch (e) {
      print("Error fetching events: $e");
    }
  }

  void updateFilter(String category, bool isSelected) {
    selectedFilters[category] = isSelected;
    applyFilters();
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query.toLowerCase();
    applyFilters();
  }

  void applyFilters() {
    List<Map<String, dynamic>> tempEvents = List.from(events);

    // Apply Category Filter
    List<String> selectedCategories = selectedFilters.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();
    if (selectedCategories.isNotEmpty) {
      tempEvents = tempEvents.where((event) => selectedCategories.contains(event['category'])).toList();
    }

    // Apply Search Query (Name, Date, Artist)
    if (searchQuery.value.isNotEmpty) {
      tempEvents = tempEvents.where((event) {
        String eventName = event['title'].toString().toLowerCase();
        String eventDate = event['date'].toString().toLowerCase();
        String artist = event['artistName'].toString().toLowerCase();
        return eventName.contains(searchQuery.value) ||
            eventDate.contains(searchQuery.value) ||
            artist.contains(searchQuery.value);
      }).toList();
    }

    filteredEvents.assignAll(tempEvents);
  }
}
