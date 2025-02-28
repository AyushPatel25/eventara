import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventapp/controller/loc_cont.dart';
import 'package:get/get.dart';
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
    locationController.getLocation();
  }

  DateTime parseEventDate(String dateStr) {
    try {
      // Assuming date format is "dd-MM-yyyy" or "dd/MM/yyyy"
      List<String> parts = dateStr.replaceAll('/', '-').split('-');
      if (parts.length == 3) {
        int day = int.parse(parts[0]);
        int month = int.parse(parts[1]);
        int year = int.parse(parts[2]);
        return DateTime(year, month, day);
      }
      return DateTime.now(); // fallback to current date if parsing fails
    } catch (e) {
      print("Error parsing date: $e");
      return DateTime.now();
    }
  }

  Future<void> fetchEvents() async {
    try {
      isLoading.value = true;
      QuerySnapshot snapshot =
      await FirebaseFirestore.instance.collection('eventDetails').get();

      DateTime now = DateTime.now();
      // Remove time component from current date for accurate date comparison
      DateTime today = DateTime(now.year, now.month, now.day);

      // Filter out expired events and convert to EventModel
      events.value = snapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        return EventModel.fromJson(data);
      }).where((event) {
        DateTime eventDate = parseEventDate(event.eventDate);
        return eventDate.isAfter(today) || eventDate.isAtSameMomentAs(today);
      }).toList();

      // Sort events by date
      events.sort((a, b) {
        DateTime dateA = parseEventDate(a.eventDate);
        DateTime dateB = parseEventDate(b.eventDate);
        return dateA.compareTo(dateB);
      });

      // Get the nearest 3 events for carousel
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

    // Apply Category Filter
    if (selectedCategory.value != "All") {
      tempEvents = tempEvents.where((event) => event.category == selectedCategory.value).toList();
    }

    List<String> selectedCategories = selectedFilters.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();
    if (selectedCategories.isNotEmpty) {
      tempEvents = tempEvents.where((event) => selectedCategories.contains(event.category)).toList();
    }

    // Apply Search Query (Name, Date, Artist, Location)
    if (searchQuery.value.isNotEmpty) {
      tempEvents = tempEvents.where((event) {
        String eventName = event.title.toLowerCase();
        String eventDate = event.eventDate.toLowerCase();
        String artistNames = event.artists.map((artist) => artist.artistName.toLowerCase()).join(", ");
        String eventLoc = event.location.toLowerCase();
        return eventName.contains(searchQuery.value) ||
            eventDate.contains(searchQuery.value) ||
            artistNames.contains(searchQuery.value) ||
            eventLoc.contains(searchQuery.value);
      }).toList();
    }

    filteredEvents.assignAll(tempEvents);
  }
}