import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventapp/controller/signup_cont.dart';
import 'package:eventapp/utills/appcolors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:math';
import '../model/event_model.dart';

class CreateEventController extends GetxController {
  final Rx<File?> eventImage = Rx<File?>(null);
  final Rx<File?> artistImage = Rx<File?>(null);
  final Rx<DateTime?> selectedDate = Rx<DateTime?>(null);
  final Rx<TimeOfDay?> selectedTime = Rx<TimeOfDay?>(null);
  final Rx<String> ageLimit = Rx<String>('15 and above');
  final Rx<String> category = Rx<String>('Concert');
  final Rx<String> arrangement = Rx<String>('Standing');
  final Rx<String> layout = Rx<String>('Indoor');
  final RxList<Map<String, dynamic>> artists = RxList<Map<String, dynamic>>([]);
  final RxList<Map<String, dynamic>> tickets = RxList<Map<String, dynamic>>([]);
  final Rx<LatLng?> selectedLocation = Rx<LatLng?>(null);
  final RxString locationAddress = RxString('');

  // New properties for image confirmation
  final Rx<bool> eventImageConfirmed = Rx<bool>(false);
  final Rx<bool> artistImageConfirmed = Rx<bool>(false);
  final Rx<String> tempEventImageUrl = Rx<String>('');
  final Rx<String> tempArtistImageUrl = Rx<String>('');

  final ImagePicker _picker = ImagePicker();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Declare controllers globally
  TextEditingController descriptionController = TextEditingController();
  TextEditingController durationController = TextEditingController();
  TextEditingController languageController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController eventCityController = TextEditingController();
  TextEditingController eventStateController = TextEditingController();

  // Pick image without uploading
  Future<void> pickImage(String type) async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        final File file = File(image.path);
        if (type == 'event') {
          eventImage.value = file;
          eventImageConfirmed.value = false; // Reset confirmation state
          tempEventImageUrl.value = ''; // Clear any previous URL
        } else if (type == 'artist') {
          artistImage.value = file;
          artistImageConfirmed.value = false; // Reset confirmation state
          tempArtistImageUrl.value = ''; // Clear any previous URL
        }
      } else {
        Get.snackbar("Info", "No image selected", snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      print("Error picking image: $e");
      Get.snackbar("Error", "Failed to pick image: $e", snackPosition: SnackPosition.BOTTOM);
    }
  }

  // New method to confirm and upload an image
  Future<void> confirmAndUploadImage(String type) async {
    try {
      if (type == 'event' && eventImage.value != null) {
        Get.dialog(
          Center(child: CircularProgressIndicator(color: AppColors.whiteColor,)),
          barrierDismissible: false,
        );
        tempEventImageUrl.value = await uploadEventImageToStorage(eventImage.value!.path, 'event');
        eventImageConfirmed.value = true;
        Get.back(); // Close loading dialog
        Get.snackbar(
          "Success",
          "Event image uploaded successfully",
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
        print("Event image URL: ${tempEventImageUrl.value}");
      } else if (type == 'artist' && artistImage.value != null) {
        Get.dialog(
          Center(child: CircularProgressIndicator(color: AppColors.whiteColor,)),
          barrierDismissible: false,
        );
        tempArtistImageUrl.value = await uploadArtistImageToStorage(artistImage.value!.path, 'artist');
        artistImageConfirmed.value = true;
        Get.back(); // Close loading dialog
        Get.snackbar(
          "Success",
          "Artist image uploaded successfully",
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
        print("Artist image URL: ${tempArtistImageUrl.value}");
      } else {
        Get.snackbar("Error", "No image selected", snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.back(); // Close loading dialog in case of error
      print("Error confirming image: $e");
      Get.snackbar("Error", "Failed to upload image: $e", snackPosition: SnackPosition.BOTTOM);
    }
  }

  // Select date
  Future<void> selectDate(BuildContext context) async {
    try {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate.value ?? DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2101),
        builder: (context, child) {
          return Theme(
            data: ThemeData.dark().copyWith(
              colorScheme: ColorScheme.dark(
                primary: Colors.white,
                onPrimary: Colors.black,
                surface: Colors.grey[800]!,
                onSurface: Colors.white,
              ),
              dialogBackgroundColor: Colors.grey[900],
            ),
            child: child!,
          );
        },
      );

      if (picked != null) {
        selectedDate.value = picked;
      }
    } catch (e) {
      print("Error selecting date: $e");
      Get.snackbar("Error", "Failed to select date: $e", snackPosition: SnackPosition.BOTTOM);
    }
  }

  // Select time
  Future<void> selectTime(BuildContext context) async {
    try {
      final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: selectedTime.value ?? TimeOfDay.now(),
        builder: (context, child) {
          return Theme(
            data: ThemeData.dark().copyWith(
              colorScheme: ColorScheme.dark(
                primary: Colors.white,
                onPrimary: Colors.black,
                surface: Colors.grey[800]!,
                onSurface: Colors.white,
              ),
              dialogBackgroundColor: Colors.grey[900],
            ),
            child: child!,
          );
        },
      );

      if (picked != null) {
        selectedTime.value = picked;
      }
    } catch (e) {
      print("Error selecting time: $e");
      Get.snackbar("Error", "Failed to select time: $e", snackPosition: SnackPosition.BOTTOM);
    }
  }

  // Add artist - Updated to store the pre-uploaded URL
  void addArtist(String artistName) {
    if (artistName.isEmpty) {
      Get.snackbar("Error", "Please enter an artist name", snackPosition: SnackPosition.BOTTOM);
      return;
    }

    if (!artistImageConfirmed.value || tempArtistImageUrl.value.isEmpty) {
      Get.snackbar(
        "Error",
        "Please confirm the artist image before adding",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    artists.add({
      'image': artistImage.value, // Keep the File reference for UI
      'image_url': tempArtistImageUrl.value, // Store the uploaded URL
      'name': artistName,
    });

    // Reset artist image fields
    artistImage.value = null;
    artistImageConfirmed.value = false;
    tempArtistImageUrl.value = '';

    Get.snackbar(
      "Success",
      "Artist added successfully",
      backgroundColor: Colors.green,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  // Add ticket type
  void addTicketType(String ticketName, String seat, String price) {
    if (ticketName.isEmpty) {
      Get.snackbar("Error", "Please enter a ticket name", snackPosition: SnackPosition.BOTTOM);
      return;
    }

    if (seat.isEmpty || !RegExp(r'^\d+$').hasMatch(seat)) {
      Get.snackbar("Error", "Please enter a valid number of seats", snackPosition: SnackPosition.BOTTOM);
      return;
    }

    if (price.isEmpty || !RegExp(r'^\d+(\.\d{1,2})?$').hasMatch(price)) {
      Get.snackbar("Error", "Please enter a valid price", snackPosition: SnackPosition.BOTTOM);
      return;
    }

    tickets.add({
      'name': ticketName,
      'seat': seat,
      'price': price,
    });

    Get.snackbar(
      "Success",
      "Ticket type added successfully",
      backgroundColor: Colors.green,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  // Set location
  void setLocation(LatLng location, String address) {
    selectedLocation.value = location;
    locationAddress.value = address;
  }

  // Upload image to Firebase Storage and get URL
  Future<String> uploadEventImageToStorage(String imagePath, String imageType) async {
    try {
      String fileName = '${DateTime.now().millisecondsSinceEpoch}_$imageType.jpg';
      Reference storageRef = _storage.ref().child('EventImage/$fileName');
      UploadTask uploadTask = storageRef.putFile(File(imagePath));
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print("Error uploading image: $e");
      throw Exception("Failed to upload image: $e");
    }
  }

  Future<String> uploadArtistImageToStorage(String imagePath, String imageType) async {
    try {
      String fileName = '${DateTime.now().millisecondsSinceEpoch}_$imageType.jpg';
      Reference storageRef = _storage.ref().child('ArtistImage/$fileName');
      UploadTask uploadTask = storageRef.putFile(File(imagePath));
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print("Error uploading image: $e");
      throw Exception("Failed to upload image: $e");
    }
  }

  // Generate unique 6-digit eventId
  Future<int> generateUniqueEventId() async {
    int newEventId;
    bool isUnique;
    do {
      newEventId = 100000 + (Random().nextInt(900000));
      QuerySnapshot querySnapshot = await _firestore
          .collection('eventDetails')
          .where('eventId', isEqualTo: newEventId)
          .get();
      isUnique = querySnapshot.docs.isEmpty;
    } while (!isUnique);
    return newEventId;
  }

  // Validate event data before saving
  bool validateEventData() {
    if (!eventImageConfirmed.value || tempEventImageUrl.value.isEmpty) {
      Get.snackbar(
        "Error",
        "Please confirm the event image",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    if (titleController.text.isEmpty) {
      Get.snackbar(
        "Error",
        "Please enter an event title",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    if (descriptionController.text.isEmpty) {
      Get.snackbar(
        "Error",
        "Please enter an event description",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    if (selectedDate.value == null) {
      Get.snackbar(
        "Error",
        "Please select an event date",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    if (selectedTime.value == null) {
      Get.snackbar(
        "Error",
        "Please select an event time",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    if (selectedLocation.value == null) {
      Get.snackbar(
        "Error",
        "Please select an event location",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    if (artists.isEmpty) {
      Get.snackbar(
        "Error",
        "Please add at least one artist",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    if (tickets.isEmpty) {
      Get.snackbar(
        "Error",
        "Please add at least one ticket type",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    return true;
  }

  // Save event to Firestore
  Future<void> saveEvent(BuildContext context) async {
    if (!validateEventData()) {
      return;
    }

    try {
      Get.dialog(
        Center(child: CircularProgressIndicator(color: AppColors.whiteColor,)),
        barrierDismissible: false,
      );

      print("===== EVENT DATA =====");
      print("Title: ${titleController.text}");
      print("Description: ${descriptionController.text}");
      print("Duration: ${durationController.text}");
      print("Language: ${languageController.text}");
      print("Event City: ${eventCityController.text}");
      print("Event State: ${eventStateController.text}");
      print("Age Limit: ${ageLimit.value}");
      print("Category: ${category.value}");
      print("Arrangement: ${arrangement.value}");
      print("Layout: ${layout.value}");
      print("Event Date: ${selectedDate.value}");
      print("Event Time: ${selectedTime.value}");
      print("Location: ${locationAddress.value}");
      print("Venue coordinates: ${selectedLocation.value}");
      print("Artists: $artists");
      print("Tickets: $tickets");
      print("Event Image URL: ${tempEventImageUrl.value}");
      print("=====================");

      int eventId = await generateUniqueEventId();

      String eventImageUrl = tempEventImageUrl.value;

      List<Artist> artistList = [];
      for (var artist in artists) {
        artistList.add(Artist(
          artistImage: artist['image_url'] ?? '',
          artistName: artist['name'],
        ));
      }

      Map<String, TicketType> ticketTypes = {};
      for (var ticket in tickets) {
        ticketTypes[ticket['name']] = TicketType(
          available: int.tryParse(ticket['seat']) ?? 0,
          price: int.tryParse(ticket['price']) ?? 0,
        );
      }

      // Prepare the event data
      String eventDate = selectedDate.value != null
          ? DateFormat('dd MMM yyyy').format(selectedDate.value!)
          : '';
      String time = selectedTime.value != null
          ? selectedTime.value!.format(context)
          : '';
      String expiryDate = selectedDate.value != null
          ? DateFormat('dd MMM yyyy').format(selectedDate.value!.add(Duration(days: 1)))
          : '';

      EventModel event = EventModel(
        ageLimit: ageLimit.value,
        arrangement: arrangement.value,
        artists: artistList,
        category: category.value,
        eventDate: eventDate,
        expiryDate: expiryDate,
        description: descriptionController.text,
        duration: durationController.text,
        eventId: eventId,
        eventImage: eventImageUrl,
        language: languageController.text,
        layout: layout.value,
        location: locationAddress.value,
        ticketTypes: ticketTypes,
        time: time,
        title: titleController.text,
        venue: selectedLocation.value ?? const LatLng(0, 0),
        latitude: selectedLocation.value?.latitude,
        longitude: selectedLocation.value?.longitude,
        eventCity: eventCityController.text,
        eventState: eventStateController.text,
      );

      // Save to Firestore
      await _firestore
          .collection('eventDetails')
          .add(event.toJson());

      String? orgId = _auth.currentUser?.uid;
      if (orgId == null) {
        throw Exception("No authenticated user found");
      }

      DocumentReference organizerRef =
      _firestore.collection('organizers').doc(orgId);

      DocumentSnapshot organizerSnapshot = await organizerRef.get();

      if (!organizerSnapshot.exists) {
        OrganizerModel newOrganizer = OrganizerModel(
          uid: orgId,
          organizerName: _auth.currentUser?.displayName ?? "Unknown Organizer",
          organizerEmail: _auth.currentUser?.email ?? "unknown@example.com",
          eventIds: [eventId],
        );
        await organizerRef.set(newOrganizer.toJson());
      } else {
        Map<String, dynamic> organizerData =
            organizerSnapshot.data() as Map<String, dynamic>? ?? {};
        List<dynamic> existingEventIds = organizerData['eventIds'] ?? [];
        if (!existingEventIds.contains(eventId)) {
          existingEventIds.add(eventId);
          await organizerRef.update({
            'eventIds': existingEventIds,
          });
        }
      }

      print("Event ID: $eventId");
      print("Event Document: ${event.toJson()}");

      Get.back();

      Get.snackbar(
        "Success",
        "Event created successfully with ID: $eventId",
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 5),
      );

      // Clear form after successful save
      eventImage.value = null;
      artistImage.value = null;
      selectedDate.value = null;
      selectedTime.value = null;
      artists.clear();
      tickets.clear();
      selectedLocation.value = null;
      locationAddress.value = '';
      eventImageConfirmed.value = false;
      artistImageConfirmed.value = false;
      tempEventImageUrl.value = '';
      tempArtistImageUrl.value = '';
      descriptionController.clear();
      durationController.clear();
      languageController.clear();
      titleController.clear();
      eventCityController.clear();
      eventStateController.clear();
    } catch (e) {
      // Close loading dialog in case of error
      Get.back();

      print("Error saving event: $e");
      Get.snackbar(
        "Error",
        "Failed to create event: $e",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 5),
      );
    }
  }

  @override
  void onClose() {
    // Clean up resources
    descriptionController.dispose();
    durationController.dispose();
    languageController.dispose();
    titleController.dispose();
    eventCityController.dispose();
    eventStateController.dispose();
    super.onClose();
  }
}

