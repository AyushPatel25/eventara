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
  }

  /// 🔹 Fetch Events from Firestore
  Future<void> fetchEvents() async {
    try {
      isLoading.value = true;
      QuerySnapshot snapshot =
      await FirebaseFirestore.instance.collection('eventDetails').get();

      events.value = snapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        return EventModel.fromJson(data);
      }).toList();

      applyFilters(); // Apply filters after fetching data
    } catch (e) {
      print("Error fetching events: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// 🔹 Update Category Selection
  void updateCategory(int index) {
    indexCategory.value = index;
    selectedCategory.value = _getCategoryName(index);
    applyFilters();
  }

  /// 🔹 Get Category Name by Index
  String _getCategoryName(int index) {
    List<String> categories = ["All", "Concert", "Comedy", "Sport", "Party", "Show"];
    return categories[index];
  }

  /// 🔹 Handle Favorite Toggle
  void toggleFavourite(int index) {
    if (favoriteEvents.contains(index)) {
      favoriteEvents.remove(index);
    } else {
      favoriteEvents.add(index);
    }
  }

  /// 🔹 Update Page Indicator for Carousel
  void updatePageIndecator(int index) {
    curousalCurrentIndex.value = index;
  }

  /// 🔹 Update Filters for Categories
  void updateFilter(String category, bool isSelected) {
    selectedFilters[category] = isSelected;
    applyFilters();
  }

  /// 🔹 Update Search Query
  void updateSearchQuery(String query) {
    searchQuery.value = query.toLowerCase();
    applyFilters();
  }

  /// 🔹 Apply Filters for Category & Search
  void applyFilters() {
    List<EventModel> tempEvents = List.from(events);

    // Apply Category Filter
    if (selectedCategory.value != "All") {
      tempEvents = tempEvents.where((event) => event.category == selectedCategory.value).toList();
    }

    // Apply Additional Selected Filters
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
