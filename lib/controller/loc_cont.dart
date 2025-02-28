// import 'dart:async';
// import 'dart:io'; // Required for Platform checks
// import 'package:app_settings/app_settings.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:get/get.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:country_state_city/country_state_city.dart' as csc; // Use alias
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// import '../componets/text_style.dart';
// import '../generated/assets.dart';
// import '../utills/appcolors.dart';
// //import 'package:app_settings/app_settings.dart'; // Import for opening settings
//
// class LocationController extends GetxController {
//   var latitude = ''.obs;
//   var longitude = ''.obs;
//   var city = 'Select location'.obs;
//   var state = 'for better usage'.obs;
//   late StreamSubscription<Position> streamSubscription;
//   var isManualSelection = false.obs;
//
//   var displayList = <dynamic>[].obs;
//   var currentType = "Country".obs;
//
//   var selectedCountry = "".obs;
//   var selectedState = "".obs;
//   var selectedCity = "".obs;
//
//   String selectedCountryCode = "";
//   String selectedStateCode = "";
//
//   var chips = <String>[].obs;
//
//   List<csc.Country> countryList = [];
//   List<csc.State> stateList = []; // Use alias to resolve conflict
//   List<csc.City> cityList = [];
//
//   @override
//   void onInit() {
//     super.onInit();
//     //checkGpsStatus();
//     //getLocation();
//   }
//
//   Future<void> checkGpsStatus() async {
//     bool isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();
//
//     if (!isLocationServiceEnabled) {
//       Get.defaultDialog(
//         title: "GPS Required",
//         middleText: "GPS is turned off. Please enable it for better accuracy.",
//         textCancel: "Cancel",
//         textConfirm: "Enable",
//         onConfirm: () async {
//           await Geolocator.openLocationSettings();
//           Get.back();
//         },
//         onCancel: () async{
//           Navigator.pop(Get.overlayContext!);
//         }
//       );
//       // Get.dialog(
//       //     Dialog(
//       //       backgroundColor: AppColors.greyColor,
//       //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//       //       child: Padding(
//       //         padding: const EdgeInsets.all(16),
//       //         child: Column(
//       //           mainAxisSize: MainAxisSize.min,
//       //           children: [
//       //             SizedBox(
//       //               height: 10,
//       //             ),
//       //             TextStyleHelper.CustomText(
//       //                 text: "GPS Required",
//       //                 color: AppColors.whiteColor,
//       //                 fontWeight: FontWeight.w600,
//       //                 fontSize: 20,
//       //                 fontFamily: Assets.fontsPoppinsBold),
//       //             SizedBox(
//       //               height: 5,
//       //             ),
//       //             TextStyleHelper.CustomText(
//       //                 text: "GPS is turned off. Please enable it for better accuracy.",
//       //                 color: AppColors.lightGrey,
//       //                 fontWeight: FontWeight.w400,
//       //                 fontSize: 16,
//       //                 fontFamily: Assets.fontsPoppinsBold),
//       //             SizedBox(
//       //               height: 10,
//       //             ),
//       //             Divider(
//       //               color: AppColors.divider,
//       //               thickness: 1,
//       //               height: 20,
//       //             ),
//       //             Row(
//       //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       //               children: [
//       //                 TextButton(
//       //                   onPressed: () {
//       //                     Navigator.pop(Get.overlayContext!);
//       //                   },
//       //                   child: TextStyleHelper.CustomText(
//       //                       text: 'Cancel',
//       //                       color: AppColors.whiteColor,
//       //                       fontWeight: FontWeight.w400,
//       //                       fontSize: 16,
//       //                       fontFamily: Assets.fontsPoppinsRegular),
//       //                 ),
//       //                 Container(
//       //                   height: 40,
//       //                   width: 1,
//       //                   color: AppColors.divider,
//       //                   margin: EdgeInsets.symmetric(horizontal: 10),
//       //                 ),
//       //                 TextButton(
//       //                   onPressed: () async {
//       //                     await Geolocator.openLocationSettings();
//       //                     Get.back();
//       //                   },
//       //                   child: TextStyleHelper.CustomText(
//       //                       text: 'Enable',
//       //                       color: AppColors.whiteColor,
//       //                       fontWeight: FontWeight.w400,
//       //                       fontSize: 16,
//       //                       fontFamily: Assets.fontsPoppinsRegular),
//       //                 )
//       //               ],
//       //             )
//       //           ],
//       //         ),
//       //       ),
//       //     ),
//       // );
//     }
//   }
//
//   Future<void> loadCountries() async {
//     countryList = await csc.getAllCountries(); // Use alias
//     displayList.assignAll(countryList);
//   }
//
//   Future<void> loadStates(String countryCode) async {
//     stateList = await csc.getStatesOfCountry(countryCode);
//     displayList.assignAll(stateList);
//     currentType.value = "State";
//   }
//
//   Future<void> loadCities(String countryCode, String stateCode) async {
//     cityList = await csc.getStateCities(countryCode, stateCode);
//     displayList.assignAll(cityList);
//     currentType.value = "City";
//   }
//
//   void handleSelection(dynamic item) {
//     isManualSelection.value = true;
//
//     if (currentType.value == 'Country') {
//       selectedCountry.value = item.name;
//       selectedState.value = "";
//       selectedCity.value = "";
//       selectedCountryCode = item.isoCode;
//       chips.clear();
//       chips.add(item.name);
//       loadStates(item.isoCode);
//     } else if (currentType.value == 'State') {
//       selectedState.value = item.name;
//       selectedCity.value = "";
//       selectedStateCode = item.isoCode;
//       chips.removeWhere((chip) => chip == selectedCountry.value);
//       chips.add(item.name);
//       loadCities(item.countryCode, item.isoCode);
//     } else if (currentType.value == 'City') {
//       selectedCity.value = item.name;
//       chips.removeWhere((chip) => chip == selectedState.value);
//       chips.add(item.name);
//     }
//   }
//
//   void filterList(String filter) {
//     if (currentType.value == 'Country') {
//       displayList.assignAll(countryList
//           .where((country) =>
//           country.name.toLowerCase().contains(filter.toLowerCase()))
//           .toList());
//     } else if (currentType.value == 'State') {
//       displayList.assignAll(stateList
//           .where(
//               (state) => state.name.toLowerCase().contains(filter.toLowerCase()))
//           .toList());
//     } else if (currentType.value == 'City') {
//       displayList.assignAll(cityList
//           .where((city) => city.name.toLowerCase().contains(filter.toLowerCase()))
//           .toList());
//     }
//   }
//
//   getLocation() async {
//     if (isManualSelection.value) {
//       print("Manual selection is active, skipping auto-detection.");
//       return;
//     }
//
//     LocationPermission permission;
//
//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         return Future.error('Location permissions are denied');
//       }
//     }
//
//     if (permission == LocationPermission.deniedForever) {
//       return Future.error(
//           'Location permissions are permanently denied, we cannot request permissions.');
//     }
//
//     streamSubscription = Geolocator.getPositionStream().listen((Position position) {
//       latitude.value = 'Latitude : ${position.latitude}';
//       longitude.value = 'Longitude : ${position.longitude}';
//       getAddressFromLatLong(position);
//     });
//   }
//
//   Future<void> getAddressFromLatLong(Position position) async {
//     try {
//       List<Placemark> placemark = await placemarkFromCoordinates(
//           position.latitude, position.longitude);
//       if (placemark.isNotEmpty) {
//         Placemark place = placemark[0];
//
//         if (!isManualSelection.value) {
//           selectedCity.value = place.locality ?? "";
//           selectedState.value = place.administrativeArea ?? "";
//           selectedCountry.value = place.country ?? "";
//
//           city.value = '${place.locality}';
//           state.value = '${place.administrativeArea}';
//         }
//       }
//     } catch (e) {
//       city.value = "Select location";
//     }
//   }
//
//   Future<void> getCoarseLocation(BuildContext context) async {
//     if (isManualSelection.value) {
//       print("Manual selection is active, skipping auto-detection.");
//       return;
//     }
//
//     LocationPermission permission = await Geolocator.checkPermission();
//
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         return Future.error('Location permissions are denied');
//       }
//     }
//
//     if (permission == LocationPermission.deniedForever) {
//       _showPermissionDialog(context);
//       return Future.error(
//           'Location permissions are permanently denied, we cannot request permissions.');
//     }
//
//     Position position = await Geolocator.getCurrentPosition(
//       desiredAccuracy: LocationAccuracy.low,
//     );
//
//     latitude.value = 'Latitude : ${position.latitude}';
//     longitude.value = 'Longitude : ${position.longitude}';
//
//     getAddressFromLatLong(position);
//
//
//       streamSubscription = Geolocator.getPositionStream(
//           locationSettings: LocationSettings(
//               accuracy: LocationAccuracy.low,
//               distanceFilter: 500
//           )
//       ).listen((Position position) {
//         latitude.value = 'Latitude : ${position.latitude}';
//         longitude.value = 'Longitude : ${position.longitude}';
//         getAddressFromLatLong(position);
//       });
//   }
//
//
//   void _showPermissionDialog(BuildContext context) {
//     if (Platform.isIOS) {
//       showCupertinoDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return CupertinoAlertDialog(
//             title: Text("Permission Required"),
//             content:
//             Text("Location access is permanently denied. Please enable it in settings."),
//             actions: [
//               CupertinoDialogAction(
//                 child: Text("Cancel"),
//                 onPressed: () => Navigator.pop(context),
//               ),
//               CupertinoDialogAction(
//                 child: Text("Open Settings"),
//                 onPressed: () {
//                   Navigator.pop(context);
//                   openAppSettings();// Now it works
//                 },
//               ),
//             ],
//           );
//         },
//       );
//     } else {
//       showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: Text("Permission Required"),
//             content:
//             Text("Location access is permanently denied. Please enable it in settings."),
//             actions: [
//               TextButton(
//                 onPressed: () => Navigator.pop(context),
//                 child: Text("Cancel"),
//               ),
//               TextButton(
//                 onPressed: () {
//                   Navigator.pop(context);
//                   openAppSettings(); // Now it works
//                 },
//                 child: Text("Open Settings"),
//               ),
//             ],
//           );
//         },
//       );
//     }
//   }
// }
//
//
//
//
// // import 'dart:async';
// //
// // import 'package:geocoding/geocoding.dart';
// // import 'package:geolocator/geolocator.dart';
// // import 'package:get/get.dart';
// // import 'package:permission_handler/permission_handler.dart';
// // import 'package:country_state_city/country_state_city.dart';
// //
// // class LocationController extends GetxController {
// //   var latitude = ''.obs;
// //   var longitude = ''.obs;
// //   var city = 'Select location'.obs;
// //   var state = 'for better usage'.obs;
// //   late StreamSubscription<Position>? streamSubscription;
// //
// //   var isManualSelection = false.obs;
// //
// //   var displayList = <dynamic>[].obs;
// //   var currentType = "Country".obs;
// //
// //   var selectedCountry = "".obs;
// //   var selectedState = "".obs;
// //   var selectedCity = "".obs;
// //
// //   String selectedCountryCode = "";
// //   String selectedStateCode = "";
// //
// //   var chips = <String>[].obs;
// //
// //   List<Country> countryList = [];
// //   List<State> stateList = [];
// //   List<City> cityList = [];
// //
// //   @override
// //   void onInit() {
// //     super.onInit();
// //     getLocation();
// //   }
// //
// //   Future<void> loadCountries() async {
// //     countryList = await getAllCountries();
// //     displayList.assignAll(countryList);
// //   }
// //
// //   Future<void> loadStates(String countryCode) async {
// //     stateList = await getStatesOfCountry(countryCode);
// //     displayList.assignAll(stateList);
// //     currentType.value = "State";
// //   }
// //
// //   Future<void> loadCities(String countryCode, String stateCode) async {
// //     cityList = await getStateCities(countryCode, stateCode);
// //     displayList.assignAll(cityList);
// //     currentType.value = "City";
// //   }
// //
// //   void handleSelection(dynamic item) {
// //     isManualSelection.value = true;
// //
// //     if (currentType.value == 'Country') {
// //       selectedCountry.value = item.name;
// //       selectedState.value = "";
// //       selectedCity.value = "";
// //       selectedCountryCode = item.isoCode;
// //       chips.clear();
// //       chips.add(item.name);
// //       loadStates(item.isoCode);
// //     } else if (currentType.value == 'State') {
// //       selectedState.value = item.name;
// //       selectedCity.value = "";
// //       selectedStateCode = item.isoCode;
// //       chips.removeWhere((chip) => chip == selectedCountry.value);
// //       chips.add(item.name);
// //       loadCities(item.countryCode, item.isoCode);
// //     } else if (currentType.value == 'City') {
// //       selectedCity.value = item.name;
// //       chips.removeWhere((chip) => chip == selectedState.value);
// //       chips.add(item.name);
// //     }
// //   }
// //
// //   void filterList(String filter) {
// //     if (currentType.value == 'Country') {
// //       displayList.assignAll(
// //         countryList
// //             .where((country) =>
// //             country.name.toLowerCase().contains(filter.toLowerCase()))
// //             .toList(),
// //       );
// //     } else if (currentType.value == 'State') {
// //       displayList.assignAll(
// //         stateList
// //             .where((state) =>
// //             state.name.toLowerCase().contains(filter.toLowerCase()))
// //             .toList(),
// //       );
// //     } else if (currentType.value == 'City') {
// //       displayList.assignAll(
// //         cityList
// //             .where((city) =>
// //             city.name.toLowerCase().contains(filter.toLowerCase()))
// //             .toList(),
// //       );
// //     }
// //   }
// //
// //   Future<bool> getLocation() async {
// //     // If manual selection is active, don't try to auto-detect
// //     if (isManualSelection.value) {
// //       return true; // Return success - we're using manual location
// //     }
// //
// //     LocationPermission permission;
// //
// //     // First check permission, don't check if service is enabled
// //     // since we're using coarse location which can work without GPS
// //     permission = await Geolocator.checkPermission();
// //     if (permission == LocationPermission.denied) {
// //       permission = await Geolocator.requestPermission();
// //       if (permission == LocationPermission.denied) {
// //         return false;
// //       }
// //     }
// //
// //     if (permission == LocationPermission.deniedForever) {
// //       return false;
// //     }
// //
// //     // Try to get location with a longer timeout and less accuracy
// //     try {
// //       // Set location accuracy to low (uses network-based location instead of GPS)
// //       final position = await Geolocator.getCurrentPosition(
// //         desiredAccuracy: LocationAccuracy.low,
// //         timeLimit: Duration(seconds: 0),
// //       );
// //
// //       // Update location values
// //       latitude.value = 'Latitude : ${position.latitude}';
// //       longitude.value = 'Longitude : ${position.longitude}';
// //       await getAddressFromLatLong(position);
// //
// //       // Setup stream for location updates with low accuracy
// //       streamSubscription = Geolocator.getPositionStream(
// //           locationSettings: LocationSettings(
// //               accuracy: LocationAccuracy.low,
// //               distanceFilter: 500 // Only update when moved 500 meters
// //           )
// //       ).listen((Position position) {
// //         latitude.value = 'Latitude : ${position.latitude}';
// //         longitude.value = 'Longitude : ${position.longitude}';
// //         getAddressFromLatLong(position);
// //       });
// //
// //       return true;
// //     } catch (e) {
// //       // If getting location fails, try again with even lower accuracy
// //       try {
// //         final position = await Geolocator.getLastKnownPosition();
// //         if (position != null) {
// //           latitude.value = 'Latitude : ${position.latitude}';
// //           longitude.value = 'Longitude : ${position.longitude}';
// //           await getAddressFromLatLong(position);
// //           return true;
// //         } else {
// //           return false;
// //         }
// //       } catch (e) {
// //         return false;
// //       }
// //     }
// //   }
// //
// //   Future<void> getAddressFromLatLong(Position position) async {
// //     try {
// //       List<Placemark> placemark = await placemarkFromCoordinates(
// //           position.latitude, position.longitude);
// //       if (placemark.isNotEmpty) {
// //         Placemark place = placemark[0];
// //
// //         // Updating city and state
// //         if (!isManualSelection.value) {
// //           selectedCity.value = place.locality ?? "";
// //           selectedState.value = place.administrativeArea ?? "";
// //           selectedCountry.value = place.country ?? "";
// //
// //           // Update address display
// //           city.value = place.locality ?? "Unknown location";
// //           state.value = place.administrativeArea ?? "";
// //         }
// //       }
// //     } catch (e) {
// //       city.value = "Select location";
// //     }
// //   }
// //
// //   @override
// //   void onClose() {
// //     streamSubscription?.cancel();
// //     super.onClose();
// //   }
// // }
import 'dart:async';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:country_state_city/country_state_city.dart' ;


class LocationController extends GetxController{
  var latitude = ''.obs;
  var longitude = ''.obs;
  var city = 'Select location'.obs;
  var state = 'for better usage'.obs;
  late StreamSubscription<Position> streamSubscription;

  var isManualSelection = false.obs;

  var manualLocation = Rxn<Position>();

  //var selectedItems = <String>[].obs;
  var displayList = <dynamic>[].obs;
  var currentType = "Country".obs;

  var selectedCountry = "".obs;
  var selectedState = "".obs;
  var selectedCity = "".obs;

  String selectedCountryCode = "";
  String selectedStateCode = "";

  var stateLive = "".obs;
  var cityLive = "".obs;

  var chips = <String>[].obs;

  List<Country> countryList = [];
  List<State> stateList = [];
  List<City> cityList = [];

  @override
  void onInit() {
    super.onInit();
    getLocation();
  }


  Future<void> loadCountries() async{
    countryList = await getAllCountries();
    displayList.assignAll(countryList);

  }

  Future<void> loadStates(String countryCode) async{
    stateList = await getStatesOfCountry(countryCode);
    displayList.assignAll(stateList);
    print(displayList);
    currentType.value = "State";
  }

  Future<void> loadCities(String countryCode, String stateCode) async{
    cityList = await getStateCities(countryCode, stateCode);
    displayList.assignAll(cityList);
    currentType.value ="City";
  }

  void handleSelection(dynamic item){

    isManualSelection.value = true;

    if(currentType.value == 'Country') {
      print(item.name);
      selectedCountry.value = item.name;
      selectedState.value = "";
      selectedCity.value = "";
      selectedCountryCode = item.isoCode;
      chips.clear();  // Clear previous selections
      chips.add(item.name);
      loadStates(item.isoCode);
    }
    else if(currentType.value == 'State') {
      selectedState.value = item.name;
      selectedCity.value = "";
      selectedStateCode = item.isoCode;
      chips.removeWhere((chip) => chip == selectedCountry.value);
      chips.add(item.name);
      loadCities(item.countryCode, item.isoCode);
    }
    else if(currentType.value == 'City') {
      selectedCity.value = item.name;
      chips.removeWhere((chip) => chip == selectedState.value);
      chips.add(item.name);
    }
  }

  void filterList(String filter){
    if(currentType.value == 'Country') {
      displayList.assignAll(countryList.where((country) => country.name.toLowerCase().contains(filter.toLowerCase())).toList(),);
    }
    else if(currentType.value == 'State') {
      displayList.assignAll(stateList.where((state) => state.name.toLowerCase().contains(filter.toLowerCase())).toList(),);
    }
    else if(currentType.value == 'City') {
      displayList.assignAll(cityList.where((city) => city.name.toLowerCase().contains(filter.toLowerCase())).toList(),);
    }
  }

  /*static Future<bool> locationPermission() async {
    if (await Permission.location.serviceStatus.isEnabled) {
      PermissionStatus locPermission = await Permission.location.status;

      if (locPermission.isGranted)
      {
        return true;
      }
      else if (locPermission.isDenied)
      {
        PermissionStatus requestStatus = await Permission.location.request();

        if (requestStatus.isGranted)
        {
          return true;
        }
        else if (requestStatus.isPermanentlyDenied)
        {
          openAppSettings();
        }
      }
      else if (locPermission.isPermanentlyDenied)
      {
        openAppSettings();
      }
    }
    else
    {
      openAppSettings();
    }
    return false;
  }*/
  Future<void> getLatLongFromAddress() async {
    if (selectedCity.isNotEmpty && selectedState.isNotEmpty && selectedCountry.isNotEmpty) {
      String fullAddress = "${selectedCity.value}, ${selectedState.value}, ${selectedCountry.value}";
      try {
        List<Location> locations = await locationFromAddress(fullAddress);
        if (locations.isNotEmpty) {
          double lat = locations.first.latitude;
          double lng = locations.first.longitude;

          // Update manualLocation
          manualLocation.value = Position(
            latitude: lat,
            longitude: lng,
            timestamp: DateTime.now(),
            accuracy: 0.0,
            altitude: 0.0,
            heading: 0.0,
            speed: 0.0,
            speedAccuracy: 0.0,
            altitudeAccuracy: 0.0,
            headingAccuracy: 0.0,
          );

          latitude.value = 'Latitude: $lat';
          longitude.value = 'Longitude: $lng';

          print("Manual Location Set: Lat: $lat, Lng: $lng");
        }
      } catch (e) {
        print("Error getting lat-long from address: $e");
      }
    }
  }


  getLocation() async {
    if (isManualSelection.value) {
      print("Manual selection is active, skipping auto-detection.");
      return;
    }

    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings(); // Prompt user to enable GPS
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.low,
    );

    try {
      Position position = await Geolocator.getCurrentPosition();
      if (position.latitude == 0.0 && position.longitude == 0.0) {
        await Geolocator.openLocationSettings();
        return Future.error('GPS seems to be off. Please enable it.');
      }
    } catch (e) {
      await Geolocator.openLocationSettings();
      return Future.error('Error getting location. Ensure GPS is on.');
    }

    streamSubscription = Geolocator.getPositionStream(
      locationSettings: locationSettings,
    ).listen((Position position) {
      latitude.value = 'Latitude : ${position.latitude}';
      longitude.value = 'Longitude : ${position.longitude}';
      getAddressFromLatLong(position);
    });
  }

  Future<void> getAddressFromLatLong(Position position) async {
    try {
      List<Placemark> placemark = await placemarkFromCoordinates(
          position.latitude, position.longitude);
      if (placemark.isNotEmpty) {
        Placemark place = placemark[0];

        if (!isManualSelection.value) {
          cityLive.value = place.locality ?? "";
          stateLive.value = place.administrativeArea ?? "";
          //selectedCountry.value = place.country ?? "";

          city.value =
          '${place.locality}';

          state.value =
          '${place.administrativeArea}';


        }
      }
    } catch (e) {
      city.value = "Select location";
    }
  }

}
