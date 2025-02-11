import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventapp/model/event_model.dart';
import 'package:eventapp/componets/text_style.dart';
import 'package:eventapp/generated/assets.dart';
import 'package:eventapp/utills/appcolors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EventDetailsController extends GetxController {
  final ScrollController scrollController = ScrollController();
  var isTitleVisible = RxBool(false);
  double titlePosition = 200;

  var isLoading = true.obs;
  var event = Rxn<EventModel>();

  var currentLocation = Rx<Position?>(null);
  var destinationLocation = Rxn<Coords>();



  @override
  void onInit() {
    super.onInit();


    scrollController.addListener(() {
      isTitleVisible.value = scrollController.offset >= titlePosition;
    });

    int? eventId = Get.arguments?['eventId'];
    if (eventId != null) {
      print(eventId);
      fetchEventDetails(eventId);
    } else {
      Get.snackbar("Error", "Event ID not found", );
    }

  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  Future<void> fetchEventDetails(int eventId) async {
    try {
      isLoading.value = true;

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('eventDetails')
          .where('eventId', isEqualTo: eventId)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot doc = querySnapshot.docs.first;
        event.value = EventModel.fromJson(doc.data() as Map<String, dynamic>);
        // Debugging: Log venue coordinates
        print("Venue Coordinates: ${event.value!.venue.latitude}, ${event.value!.venue.longitude}");
        LatLng venue = LatLng(event.value!.venue.latitude, event.value!.venue.longitude);
        destinationLocation.value =
            Coords(event.value!.venue.latitude, event.value!.venue.longitude);


      } else {
        print("No event found for eventId: $eventId");
        Get.snackbar("Error", "Event not found", backgroundColor: Colors.red);
      }
    } catch (e) {
      print("Error fetching event details: $e");
      Get.snackbar("Error", "Failed to load event", backgroundColor: Colors.red);
    } finally {
      isLoading.value = false;
    }
  }



  Future<void> getUserLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // Show pop-up to enable location settings
        Get.defaultDialog(
          title: "Location Disabled",
          middleText: "Please enable location services to continue.",
          backgroundColor: Colors.black,
          titleStyle: TextStyle(color: Colors.white),
          middleTextStyle: TextStyle(color: Colors.white),
          textConfirm: "Turn On",
          textCancel: "Cancel",
          confirmTextColor: Colors.black,
          onConfirm: () async {
            await Geolocator.openLocationSettings(); // Open location settings
            Get.back();
          },
          onCancel: () => Get.back(),
        );
        return;
      }

      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        throw Exception("Location permission denied.");
      }

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      currentLocation.value = position;
    } catch (e) {
      print("Error getting user location: $e");
      Get.snackbar("Error", "Could not get location", backgroundColor: Colors.red);
    }
  }

  /// **Open Google Maps or Other Map Apps**
  Future<void> openMaps() async {
    try {
      if (currentLocation.value == null) {
        await getUserLocation();
      }

      if (destinationLocation.value == null) {
        print("Error: Destination not available.");
        Get.snackbar("Error", "Destination location not set.", backgroundColor: Colors.red);
        return;
      }

      final availableMaps = await MapLauncher.installedMaps;
      if (availableMaps.isEmpty) {
        print("No map applications found.");
        Get.snackbar("Error", "No installed map applications found.", backgroundColor: Colors.red);
        return;
      }


      showModalBottomSheet(
        backgroundColor: Colors.black,
        context: Get.context!,
        builder: (BuildContext context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextStyleHelper.CustomText(
                  text: 'Open In',
                  color: AppColors.whiteColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                  fontFamily: Assets.fontsPoppinsRegular,
                ),
              ),
              Divider(color: AppColors.divider, height: 10),
              ListView.builder(
                shrinkWrap: true,
                itemCount: availableMaps.length,
                itemBuilder: (context, index) {
                  final map = availableMaps[index];
                  return ListTile(
                    title: TextStyleHelper.CustomText(
                      text: map.mapName,
                      color: AppColors.whiteColor,
                      fontWeight: FontWeight.w400,
                      fontSize: 15,
                      fontFamily: Assets.fontsPoppinsRegular,
                    ),
                    leading: SvgPicture.asset(
                      map.icon,
                      height: 30.0,
                      width: 30.0,
                    ),
                    onTap: () async {
                      Navigator.of(context).pop();
                      await map.showDirections(
                        origin: Coords(
                          currentLocation.value!.latitude,
                          currentLocation.value!.longitude,
                        ),
                        destination: destinationLocation.value!,
                      );
                    },
                  );
                },
              ),
            ],
          );
        },
      );
    } catch (e) {
      print("Error opening maps: $e");
      Get.snackbar("Error", "Could not open maps.", backgroundColor: Colors.red);
    }
  }
}
