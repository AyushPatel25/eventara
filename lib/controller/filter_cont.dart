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
  RxBool isLoading = true.obs;

  @override
  void onInit() {
    fetchEvents();
    super.onInit();
  }

  // Helper function to parse "DD Mon YYYY" format (e.g., "18 Mar 2025")
  DateTime? _parseEventDate(String dateStr) {
    try {
      final Map<String, int> monthMap = {
        'jan': 1, 'feb': 2, 'mar': 3, 'apr': 4, 'may': 5, 'jun': 6,
        'jul': 7, 'aug': 8, 'sep': 9, 'oct': 10, 'nov': 11, 'dec': 12,
      };

      // Split the date string into components (e.g., ["18", "Mar", "2025"])
      final parts = dateStr.trim().split(' ');
      if (parts.length != 3) return null;

      final day = int.parse(parts[0]);
      final monthStr = parts[1].toLowerCase().substring(0, 3); // Take first 3 letters
      final year = int.parse(parts[2]);

      final month = monthMap[monthStr];
      if (month == null) return null;

      return DateTime(year, month, day);
    } catch (e) {
      print("Error parsing date '$dateStr': $e");
      return null;
    }
  }

  Future<void> fetchEvents() async {
    try {
      isLoading.value = true;
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('eventDetails').get();
      List<Map<String, dynamic>> eventList = snapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        data['eventId'] = doc.id;
        return data;
      }).toList();

      // Filter out past events during initial fetch
      final now = DateTime.now(); // Current date: March 20, 2025
      eventList = eventList.where((event) {
        final eventDateStr = event['eventDate']?.toString() ?? '';
        final eventDate = _parseEventDate(eventDateStr);
        return eventDate != null && eventDate.isAfter(now.subtract(Duration(days: 1))); // Exclude today and before
      }).toList();

      events.assignAll(eventList);
      filteredEvents.clear();
    } catch (e) {
      print("Error fetching events: $e");
    } finally {
      isLoading.value = false;
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
    bool isFilterApplied = selectedFilters.containsValue(true) || searchQuery.isNotEmpty;

    // Apply Category Filter
    List<String> selectedCategories = selectedFilters.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();

    if (selectedCategories.isNotEmpty) {
      tempEvents = tempEvents.where((event) => selectedCategories.contains(event['category'])).toList();
    }

    // Apply Search Query (Name, Date, Artist, Location)
    if (searchQuery.isNotEmpty) {
      tempEvents = tempEvents.where((event) {
        String eventName = event['title'].toString().toLowerCase();
        String eventDate = event['eventDate'].toString().toLowerCase();
        String artist = event['artistName'].toString().toLowerCase();
        String eventLocation = event['location'].toString().toLowerCase();
        return eventName.contains(searchQuery.value) ||
            eventDate.contains(searchQuery.value) ||
            artist.contains(searchQuery.value) ||
            eventLocation.contains(searchQuery.value);
      }).toList();
    }

    if (isFilterApplied) {
      filteredEvents.assignAll(tempEvents);
    } else {
      filteredEvents.clear();
    }
  }
}
