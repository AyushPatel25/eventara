import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventapp/controller/loc_cont.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../model/event_model.dart';

class HomeController extends GetxController {
  static HomeController get instance => Get.find();

  final LocationController locationController = Get.put(LocationController());

  final RxInt curousalCurrentIndex = 0.obs;
  var favoriteEvents = <int>{}.obs;
  var indexCategory = 0.obs;
  var isLoading = true.obs;

  var events = <EventModel>[].obs;
  var filteredEvents = <EventModel>[].obs;
  var carouselEvents = <EventModel>[].obs;
  var nearEvents = <EventModel>[].obs;
  var selectedCategory = 'All'.obs;
  RxString searchQuery = ''.obs;

  RxMap<String, bool> selectedFilters = {
    'Concert': false,
    'Comedy': false,
    'Sport': false,
    'Party': false,
    'Show': false,
  }.obs;

  @override
  void onInit() {
    super.onInit();
    fetchEvents();
    fetchNearEvents();
    ever(locationController.isLocationEnabled, (_) => _updateNearEvents());
    ever(locationController.isManualSelection, (_) => _updateNearEvents());
    locationController.getLocation();
  }

  void _updateNearEvents() {
    if (!locationController.isManualSelection.value && locationController.isLocationEnabled.value) {
      fetchNearEvents();
    }
  }

  DateTime parseEventDate(String dateStr) {
    try {
      List<String> parts = dateStr.replaceAll('/', '-').split('-');
      if (parts.length == 3) {
        int day = int.parse(parts[0]);
        int month = int.parse(parts[1]);
        int year = int.parse(parts[2]);
        return DateTime(year, month, day);
      }
      return DateTime.now();
    } catch (e) {
      print("Error parsing date: $e");
      return DateTime.now();
    }
  }

  double calculateDistance(double lat1, double lon1, double? lat2, double? lon2) {
    if (lat2 == null || lon2 == null) return double.infinity;

    try {
      return Geolocator.distanceBetween(
          lat1,
          lon1,
          lat2,
          lon2
      ) / 1000;
    } catch (e) {
      print("❌ Error calculating distance: $e");
      return double.infinity;
    }
  }

  Future<void> fetchNearEvents() async {
    try {
      isLoading.value = true;
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('eventDetails').get();
      await locationController.getLocation();

      double? userLat;
      double? userLon;

      try {
        String latString = locationController.latitude.value.toString().trim();
        String lonString = locationController.longitude.value.toString().trim();

        if (latString.isNotEmpty) userLat = double.parse(latString);
        if (lonString.isNotEmpty) userLon = double.parse(lonString);
      } catch (e) {
        print("❌ Conversion error: $e");
        userLat = null;
        userLon = null;
      }

      if (userLat == null || userLon == null) {
        print("⚠️ Could not get valid user coordinates");
        nearEvents.value = [];
        return;
      }

      DateTime today = DateTime.now();

      List<EventModel> nearEventsList = [];

      for (var doc in snapshot.docs) {
        try {
          var data = doc.data() as Map<String, dynamic>;
          var event = EventModel.fromJson(data);

          DateTime eventDate = DateFormat('dd MMM yyyy').parse(event.eventDate);
          if (!(eventDate.isAfter(today) || eventDate.isAtSameMomentAs(today))) {
            continue; // Skip past events
          }

          double? eventLat = event.latitude;
          double? eventLon = event.longitude;

          if (eventLat == null || eventLon == null) {
            continue;
          }

          double distance = calculateDistance(userLat, userLon, eventLat, eventLon);

          if (distance <= 200) {
            nearEventsList.add(event);
          }
          print("📍 Event ${event.title} is at distance $distance km");
        } catch (e) {
          print("❌ Error processing event document: $e");
        }
      }

      nearEvents.value = nearEventsList;
      print("📍 Found ${nearEvents.length} events near user");

    } catch (e) {
      print("❌ Error fetching near events: $e");
      nearEvents.value = [];
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchEvents() async {
    try {
      isLoading.value = true;
      QuerySnapshot snapshot =
      await FirebaseFirestore.instance.collection('eventDetails').get();

      DateTime today = DateTime.now();

      events.value = snapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        return EventModel.fromJson(data);
      }).where((event) {
        DateTime eventDate = DateFormat('dd MMM yyyy').parse(event.eventDate);
        return eventDate.isAfter(today) || eventDate.isAtSameMomentAs(today);
      }).toList();

      events.sort((a, b) {
        DateTime dateA = parseEventDate(a.eventDate);
        DateTime dateB = parseEventDate(b.eventDate);
        return dateA.compareTo(dateB);
      });

      carouselEvents.value = events.take(3).toList();

      applyFilters();
    } catch (e) {
      print("Error fetching events: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void updateCategory(int index) {
    indexCategory.value = index;
    selectedCategory.value = _getCategoryName(index);

    // Clear any selected filters when changing category
    if (index != 0) { // If not "All"
      selectedFilters.forEach((key, value) {
        selectedFilters[key] = false;
      });
    }

    applyFilters();
  }

  String _getCategoryName(int index) {
    List<String> categories = ["All", "Concert", "Comedy", "Sport", "Party", "Show"];
    return categories[index];
  }

  void toggleFavourite(int index) {
    if (favoriteEvents.contains(index)) {
      favoriteEvents.remove(index);
    } else {
      favoriteEvents.add(index);
    }
  }

  void updatePageIndecator(int index) {
    curousalCurrentIndex.value = index;
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
    List<EventModel> tempEvents = List.from(events);
    print("Total events before filtering: ${tempEvents.length}");
    print("Selected category: ${selectedCategory.value}");

    // Apply category filter
    if (selectedCategory.value != "All") {
      tempEvents = tempEvents.where((event) {
        print("Event category: ${event.category}, Selected: ${selectedCategory.value}");
        return event.category.toLowerCase() == selectedCategory.value.toLowerCase();
      }).toList();
      print("Events after category filtering: ${tempEvents.length}");
    }

    // Apply individual filters if All is selected but filters are checked
    if (selectedCategory.value == "All") {
      bool anyFilterSelected = selectedFilters.values.contains(true);

      if (anyFilterSelected) {
        tempEvents = tempEvents.where((event) {
          return selectedFilters[event.category] == true;
        }).toList();
      }
    }

    // Apply search query filter
    if (searchQuery.value.isNotEmpty) {
      tempEvents = tempEvents.where((event) {
        return event.title.toLowerCase().contains(searchQuery.value) ||
            event.description.toLowerCase().contains(searchQuery.value) ||
            event.location.toLowerCase().contains(searchQuery.value);
      }).toList();
    }

    filteredEvents.assignAll(tempEvents);
    print("Final filtered events: ${filteredEvents.length}");
  }
}