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

  //var selectedItems = <String>[].obs;
  var displayList = <dynamic>[].obs;
  var currentType = "Country".obs;

  var selectedCountry = "".obs;
  var selectedState = "".obs;
  var selectedCity = "".obs;

  String selectedCountryCode = "";
  String selectedStateCode = "";

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

  getLocation() async {

    if (isManualSelection.value) {
      print("Manual selection is active, skipping auto-detection.");
      return;
    }
    bool serviceEnabled;

    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      await Geolocator.openAppSettings();
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    streamSubscription = Geolocator.getPositionStream().listen((Position position){

      latitude.value='Latitude : ${position.latitude}';
      longitude.value='Longitude : ${position.longitude}';
      getAddressFromLatLong(position);
    });
  }

  Future<void> getAddressFromLatLong(Position position) async {
    try {
      List<Placemark> placemark = await placemarkFromCoordinates(
          position.latitude, position.longitude);
      if (placemark.isNotEmpty) {
        Placemark place = placemark[0];

        // Updating city and state
        if (!isManualSelection.value) {
          selectedCity.value = place.locality ?? "";
          selectedState.value = place.administrativeArea ?? "";
          selectedCountry.value = place.country ?? "";

          // Update address display
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
