import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventapp/utills/appcolors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import '../model/event_model.dart';

class UpdateDeleteEventController extends GetxController {
  final Rx<File?> eventImage = Rx<File?>(null);
  final Rx<DateTime?> selectedDate = Rx<DateTime?>(null);
  final Rx<TimeOfDay?> selectedTime = Rx<TimeOfDay?>(null);
  final Rx<String> ageLimit = Rx<String>('');
  final Rx<String> category = Rx<String>('');
  final Rx<String> arrangement = Rx<String>('');
  final Rx<String> layout = Rx<String>('');
  final Rx<bool> eventImageConfirmed = Rx<bool>(false);
  final Rx<String> tempEventImageUrl = Rx<String>('');

  // Artist-related fields
  final RxList<Map<String, dynamic>> artists = RxList<Map<String, dynamic>>([]);
  final Rx<File?> artistImage = Rx<File?>(null);
  final Rx<bool> artistImageConfirmed = Rx<bool>(false);
  final Rx<String> tempArtistImageUrl = Rx<String>('');
  TextEditingController artistNameController = TextEditingController();

  // Ticket-related fields
  final RxList<Map<String, dynamic>> tickets = RxList<Map<String, dynamic>>([]);
  TextEditingController ticketNameController = TextEditingController();
  TextEditingController ticketSeatController = TextEditingController();
  TextEditingController ticketPriceController = TextEditingController();

  // Location-related fields
  final Rx<LatLng?> selectedLocation = Rx<LatLng?>(null);
  final RxString locationAddress = RxString('');

  final ImagePicker _picker = ImagePicker();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController durationController = TextEditingController();
  TextEditingController languageController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController eventCityController = TextEditingController();
  TextEditingController eventStateController = TextEditingController();
  String? eventDocId;
  int? eventId;

  @override
  void onInit() {
    super.onInit();
    artists.value = [];
    tickets.value = [];
    if (Get.arguments != null && Get.arguments['eventId'] != null) {
      eventId = Get.arguments['eventId'];
      fetchEventData(eventId!);
    }
  }

  Future<void> fetchEventData(int eventId) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('eventDetails')
          .where('eventId', isEqualTo: eventId)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        eventDocId = querySnapshot.docs.first.id;
        Map<String, dynamic> data =
        querySnapshot.docs.first.data() as Map<String, dynamic>;

        print('Fetched data: $data'); // Debug log

        // Populate basic fields
        titleController.text = data['title']?.toString() ?? '';
        tempEventImageUrl.value = data['eventImage']?.toString() ?? '';
        eventImageConfirmed.value = true;
        selectedDate.value = data['eventDate'] != null
            ? DateFormat('dd MMM yyyy').parse(data['eventDate'])
            : null;

        // Parse eventTime or time field as string (e.g., "9:00 PM")
        if (data['time'] != null) {
          try {
            final DateTime parsedTime = DateFormat("h:mm a").parse(data['time']);
            selectedTime.value = TimeOfDay.fromDateTime(parsedTime);
          } catch (e) {
            print("Error parsing time: $e");
            selectedTime.value = null;
          }
        }

        ageLimit.value = data['ageLimit']?.toString() ?? '';
        category.value = data['category']?.toString() ?? '';
        arrangement.value = data['arrangement']?.toString() ?? '';
        layout.value = data['layout']?.toString() ?? '';
        descriptionController.text = data['description']?.toString() ?? '';
        durationController.text = data['duration']?.toString() ?? '';
        languageController.text = data['language']?.toString() ?? '';
        eventCityController.text = data['eventCity']?.toString() ?? '';
        eventStateController.text = data['eventState']?.toString() ?? '';

        // Fetch artists with field name mapping
        if (data['artists'] != null) {
          List<dynamic> fetchedArtists = data['artists'] as List<dynamic>;
          artists.assignAll(fetchedArtists.map((artist) {
            return {
              'name': artist['artistName']?.toString() ?? 'Unnamed Artist',
              'imageUrl': artist['artistImage']?.toString() ?? '',
            };
          }).toList());
        } else {
          artists.clear();
        }

        // Fetch ticketTypes and convert to tickets list
        if (data['ticketTypes'] != null) {
          Map<String, dynamic> ticketTypes = data['ticketTypes'] as Map<String, dynamic>;
          tickets.assignAll(ticketTypes.entries.map((entry) {
            return {
              'name': entry.key.toString(),
              'seat': entry.value['available']?.toString() ?? '0',
              'price': entry.value['price']?.toString() ?? '0',
            };
          }).toList());
        } else {
          tickets.clear();
        }

        // Fetch location with fallback to venue (GeoPoint)
        if (data['location'] != null) {
          locationAddress.value = data['location']?.toString() ?? '';
          if (data['latitude'] != null && data['longitude'] != null) {
            selectedLocation.value = LatLng(
              (data['latitude'] as num).toDouble(),
              (data['longitude'] as num).toDouble(),
            );
          } else if (data['venue'] != null) {
            GeoPoint venue = data['venue'] as GeoPoint;
            selectedLocation.value = LatLng(venue.latitude, venue.longitude);
            // Optionally fetch address from coordinates if needed
            try {
              List<Placemark> placemarks = await placemarkFromCoordinates(
                  venue.latitude, venue.longitude);
              if (placemarks.isNotEmpty) {
                Placemark place = placemarks[0];
                locationAddress.value =
                '${place.street ?? ''}, ${place.subLocality ?? ''}, ${place.locality ?? ''}, ${place.country ?? ''}';
              }
            } catch (e) {
              print("Error fetching address from venue: $e");
              locationAddress.value = "Unknown location";
            }
          }
        } else {
          locationAddress.value = '';
          selectedLocation.value = null;
        }
      } else {
        Get.snackbar("Error", "Event not found",
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      print("Error fetching event: $e");
      Get.snackbar("Error", "Failed to fetch event: $e",
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  // Pick event image
  Future<void> pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        eventImage.value = File(image.path);
        eventImageConfirmed.value = false;
        tempEventImageUrl.value = '';
      } else {
        Get.snackbar("Info", "No image selected",
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      print("Error picking image: $e");
      Get.snackbar("Error", "Failed to pick image: $e",
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  // Confirm and upload event image
  Future<void> confirmAndUploadImage() async {
    try {
      if (eventImage.value != null) {
        Get.dialog(
          Center(child: CircularProgressIndicator(color: AppColors.whiteColor)),
          barrierDismissible: false,
        );
        tempEventImageUrl.value =
        await uploadEventImageToStorage(eventImage.value!.path);
        eventImageConfirmed.value = true;
        Get.back();
        Get.snackbar("Success", "Event image uploaded successfully",
            backgroundColor: Colors.green,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM);
      } else {
        Get.snackbar("Error", "No image selected",
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.back();
      print("Error uploading image: $e");
      Get.snackbar("Error", "Failed to upload image: $e",
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  // Upload event image to Firebase Storage
  Future<String> uploadEventImageToStorage(String imagePath) async {
    try {
      String fileName = '${DateTime.now().millisecondsSinceEpoch}_event.jpg';
      Reference storageRef = _storage.ref().child('EventImage/$fileName');
      UploadTask uploadTask = storageRef.putFile(File(imagePath));
      TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      throw Exception("Failed to upload image: $e");
    }
  }

  // Pick artist image
  Future<void> pickArtistImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        artistImage.value = File(image.path);
        artistImageConfirmed.value = false;
        tempArtistImageUrl.value = '';
      } else {
        Get.snackbar("Info", "No image selected",
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      print("Error picking artist image: $e");
      Get.snackbar("Error", "Failed to pick artist image: $e",
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  // Confirm and upload artist image
  Future<void> confirmAndUploadArtistImage() async {
    try {
      if (artistImage.value != null) {
        Get.dialog(
          Center(child: CircularProgressIndicator(color: AppColors.whiteColor)),
          barrierDismissible: false,
        );
        tempArtistImageUrl.value =
        await uploadArtistImageToStorage(artistImage.value!.path);
        artistImageConfirmed.value = true;
        Get.back();
        Get.snackbar("Success", "Artist image uploaded successfully",
            backgroundColor: Colors.green,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM);
      } else {
        Get.snackbar("Error", "No image selected",
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.back();
      print("Error uploading artist image: $e");
      Get.snackbar("Error", "Failed to upload artist image: $e",
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  // Upload artist image to Firebase Storage
  Future<String> uploadArtistImageToStorage(String imagePath) async {
    try {
      String fileName = '${DateTime.now().millisecondsSinceEpoch}_artist.jpg';
      Reference storageRef = _storage.ref().child('ArtistImage/$fileName');
      UploadTask uploadTask = storageRef.putFile(File(imagePath));
      TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      throw Exception("Failed to upload artist image: $e");
    }
  }

  // Add artist
  void addArtist(String name) {
    if (name.isEmpty) {
      Get.snackbar("Error", "Please enter artist name",
          snackPosition: SnackPosition.BOTTOM);
      return;
    }
    if (tempArtistImageUrl.value.isEmpty && !artistImageConfirmed.value) {
      Get.snackbar("Error", "Please upload an artist image",
          snackPosition: SnackPosition.BOTTOM);
      return;
    }
    artists.add({
      'name': name,
      'imageUrl': tempArtistImageUrl.value,
    });
    artistImage.value = null;
    artistImageConfirmed.value = false;
    tempArtistImageUrl.value = '';
  }

  // Remove artist
  void removeArtist(Map<String, dynamic> artist) {
    artists.remove(artist);
  }

  // Add ticket type
  void addTicketType(String name, String seat, String price) {
    if (name.isEmpty || seat.isEmpty || price.isEmpty) {
      Get.snackbar("Error", "Please fill all ticket fields",
          snackPosition: SnackPosition.BOTTOM);
      return;
    }
    tickets.add({
      'name': name,
      'seat': seat,
      'price': price,
    });
  }

  // Remove ticket
  void removeTicket(Map<String, dynamic> ticket) {
    tickets.remove(ticket);
  }

  // Set location
  void setLocation(LatLng location, String address) {
    selectedLocation.value = location;
    locationAddress.value = address;
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
      if (picked != null) selectedDate.value = picked;
    } catch (e) {
      print("Error selecting date: $e");
      Get.snackbar("Error", "Failed to select date: $e",
          snackPosition: SnackPosition.BOTTOM);
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
      Get.snackbar("Error", "Failed to select time: $e",
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  // Update event in Firestore
  Future<void> updateEvent() async {
    if (titleController.text.isEmpty || selectedDate.value == null) {
      Get.snackbar("Error", "Please fill all required fields",
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    try {
      Get.dialog(
        Center(child: CircularProgressIndicator(color: AppColors.whiteColor)),
        barrierDismissible: false,
      );

      String eventDate = DateFormat('dd MMM yyyy').format(selectedDate.value!);
      String expiryDate = DateFormat('dd MMM yyyy')
          .format(selectedDate.value!.add(Duration(days: 1)));
      String eventTime = selectedTime.value != null
          ? DateFormat("h:mm a").format(DateTime(
          2023, 1, 1, selectedTime.value!.hour, selectedTime.value!.minute))
          : "";

      // Prepare location data
      Map<String, dynamic> locationData = {
        'address': locationAddress.value,
        'latitude': selectedLocation.value?.latitude,
        'longitude': selectedLocation.value?.longitude,
      };

      // Convert tickets list back to ticketTypes map
      Map<String, dynamic> ticketTypes = {};
      for (var ticket in tickets) {
        ticketTypes[ticket['name']] = {
          'price': int.tryParse(ticket['price']) ?? 0,
          'available': int.tryParse(ticket['seat']) ?? 0,
        };
      }

      // Prepare artists with the correct field names
      List<Map<String, dynamic>> artistsData = artists.map((artist) {
        return {
          'artistName': artist['name'],
          'artistImage': artist['imageUrl'],
        };
      }).toList();

      // Update eventDetails collection with all fields
      await _firestore.collection('eventDetails').doc(eventDocId).update({
        'title': titleController.text,
        'eventDate': eventDate,
        'expiryDate': expiryDate,
        'time': eventTime,
        'eventTime': eventTime, // Update both fields for compatibility
        'ageLimit': ageLimit.value,
        'category': category.value,
        'arrangement': arrangement.value,
        'layout': layout.value,
        'description': descriptionController.text,
        'duration': durationController.text,
        'language': languageController.text,
        'eventCity': eventCityController.text,
        'eventState': eventStateController.text,
        'eventImage': tempEventImageUrl.value,
        'artists': artistsData,
        'ticketTypes': ticketTypes,
        'location': locationAddress.value,
        'latitude': selectedLocation.value?.latitude,
        'longitude': selectedLocation.value?.longitude,
        'venue': selectedLocation.value != null
            ? GeoPoint(
          selectedLocation.value!.latitude,
          selectedLocation.value!.longitude,
        )
            : null,
      });

      // Update organizers collection
      String? orgId = _auth.currentUser?.uid;
      if (orgId == null) throw Exception("No authenticated user found");

      // Convert eventId to string for the map key
      String eventIdString = eventId.toString();

      DocumentReference organizerRef =
      _firestore.collection('organizers').doc(orgId);
      await organizerRef.update({
        'events.$eventIdString.eventDate': eventDate,
        'events.$eventIdString.eventImage': tempEventImageUrl.value,

      });

      Get.back();
      Get.snackbar("Success", "Event updated successfully",
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM);
      Get.back(); // Navigate back after successful update
    } catch (e) {
      Get.back();
      print("Error updating event: $e");
      Get.snackbar("Error", "Failed to update event: $e",
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  // Delete event from Firestore
  Future<void> deleteEvent() async {
    try {
      Get.dialog(
        Center(child: CircularProgressIndicator(color: AppColors.whiteColor)),
        barrierDismissible: false,
      );

      String? orgId = _auth.currentUser?.uid;
      if (orgId == null) throw Exception("No authenticated user found");

      // Delete from eventDetails collection
      await _firestore.collection('eventDetails').doc(eventDocId).delete();

      // Delete from organizers collection
      String eventIdString = eventId.toString();
      DocumentReference organizerRef =
      _firestore.collection('organizers').doc(orgId);
      await organizerRef.update({
        'events.$eventIdString': FieldValue.delete(),
      });

      Get.back();
      Get.back(); // Navigate back after deletion
      Get.snackbar("Success", "Event deleted successfully",
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.back();
      print("Error deleting event: $e");
      Get.snackbar("Error", "Failed to delete event: $e",
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    durationController.dispose();
    languageController.dispose();
    locationController.dispose();
    eventCityController.dispose();
    eventStateController.dispose();
    artistNameController.dispose();
    ticketNameController.dispose();
    ticketSeatController.dispose();
    ticketPriceController.dispose();
    super.onClose();
  }
}