import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:country_state_city/country_state_city.dart';
import '../../componets/button.dart';
import '../../componets/text_field.dart';
import '../../componets/text_style.dart';
import '../../generated/assets.dart';
import '../../utills/appcolors.dart';
import '../home/dashboard_page.dart';
import '../home/home_page.dart';
import '../../controller/loc_cont.dart';

showLocationBottomSheet(BuildContext context) {
  showModalBottomSheet(
    backgroundColor: Colors.black,
    isScrollControlled: true,
    enableDrag: true,
    context: context,
    builder: (context) {
      return LocationBottomSheet();
    },
  );
}

class LocationBottomSheet extends StatelessWidget {
  final LocationController locationController = Get.put(LocationController());
  final TextEditingController _searchController = TextEditingController();
  // Add a reactive loading state
  final RxBool isLoading = false.obs;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          SizedBox(height: 57),
          // AppBar
          AppBar(
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: Colors.black,
              systemNavigationBarColor: Colors.black,
            ),
            leading: IconButton(
              onPressed: () {
                Get.offAll(DashboardPage());
                Future.delayed(Duration(milliseconds: 300), () {
                  FocusScope.of(context).requestFocus(FocusNode());
                });
                locationController.displayList.clear();
              },
              icon: Icon(Icons.arrow_back),
            ),
            elevation: 1,
            backgroundColor: Colors.black,
            surfaceTintColor: Colors.black,
            title: TextStyleHelper.CustomText(
              text: "Location",
              color: AppColors.whiteColor,
              fontWeight: FontWeight.w600,
              fontSize: 25,
              fontFamily: Assets.fontsPoppinsBold,
            ),
          ),
          SizedBox(height: 20),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
            child: Obx(() => SizedBox(
              height: 50,
              child: TextField(
                controller: _searchController,
                cursorColor: AppColors.whiteColor,
                onTap: () {
                  locationController.selectedCountry.value = "";
                  locationController.selectedState.value = "";
                  locationController.selectedCity.value = "";
                  locationController.chips.clear();
                  locationController.displayList.clear();
                  locationController.loadCountries();
                },
                onChanged: locationController.filterList,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: AppColors.lightGrey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: AppColors.lightGrey),
                  ),
                  prefixIcon: Icon(Icons.search, color: AppColors.lightGrey),
                  hintText: "Search ${locationController.currentType.value}",
                  hintStyle: TextStyle(
                    color: AppColors.lightGrey,
                    fontFamily: 'regular',
                  ),
                  filled: true,
                  fillColor: AppColors.greyColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: AppColors.primaryColor),
                  ),
                ),
              ),
            )),
          ),

          Visibility(
            visible: locationController.selectedCountry.isNotEmpty ? true : false,
            child: SizedBox(height: 10),
          ),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
            child: Obx(() => SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  if (locationController.selectedCountry.isNotEmpty)
                    Chip(
                      label: Text(
                        locationController.selectedCountry.value,
                        style: TextStyle(
                          color: AppColors.whiteColor,
                          fontFamily: Assets.fontsPoppinsRegular,
                        ),
                      ),
                      onDeleted: () {
                        locationController.selectedCountry.value = "";
                        locationController.selectedState.value = "";
                        locationController.selectedCity.value = "";
                        locationController.chips.clear();
                        locationController.loadCountries();
                        locationController.currentType.value = "Country";
                      },
                    ),
                  const SizedBox(width: 5),
                  if (locationController.selectedState.isNotEmpty)
                    Chip(
                      label: Text(
                        locationController.selectedState.value,
                        style: TextStyle(
                          color: AppColors.whiteColor,
                          fontFamily: Assets.fontsPoppinsRegular,
                        ),
                      ),
                      onDeleted: () {
                        locationController.selectedState.value = "";
                        locationController.selectedCity.value = "";
                        locationController.loadStates(locationController.selectedCountryCode);
                        locationController.currentType.value = "State";
                      },
                    ),
                  const SizedBox(width: 5),
                  if (locationController.selectedCity.isNotEmpty)
                    Chip(
                      label: Text(
                        locationController.selectedCity.value,
                        style: TextStyle(
                          color: AppColors.whiteColor,
                          fontFamily: Assets.fontsPoppinsRegular,
                        ),
                      ),
                      onDeleted: () {
                        locationController.selectedCity.value = "";
                        locationController.loadCities(
                          locationController.selectedCountryCode,
                          locationController.selectedStateCode,
                        );
                        locationController.currentType.value = "City";
                      },
                    ),
                ],
              ),
            )),
          ),
          Visibility(
            visible: locationController.selectedCountry.isNotEmpty ? true : false,
            child: SizedBox(height: 10),
          ),

          Visibility(
            visible: locationController.displayList.isEmpty ? false : true,
            child: Expanded(
              child: Obx(() => ListView.builder(
                itemCount: locationController.displayList.length,
                itemBuilder: (context, index) {
                  var item = locationController.displayList[index];
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: ListTile(
                      title: Text(
                        item.name,
                        style: TextStyle(
                          color: AppColors.whiteColor,
                          fontFamily: Assets.fontsPoppinsRegular,
                        ),
                      ),
                      onTap: () {
                        locationController.handleSelection(item);
                        _searchController.clear();

                        if (locationController.selectedCity.isNotEmpty) {
                          locationController.displayList.clear();
                          Get.offAll(DashboardPage());
                        }
                      },
                    ),
                  );
                },
              )),
            ),
          ),

          Visibility(
            visible: locationController.displayList.isEmpty ? true : false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
              child: Obx(() => ElevatedButton(
                onPressed: isLoading.value
                    ? null // Disable button while loading
                    : () async {
                  isLoading.value = true; // Start loading
                  final locationController = Get.find<LocationController>();
                  locationController.isManualSelection.value = false;

                  try {
                    await locationController.getLocation();

                    if (locationController.latitude.value != 'Getting Latitude..') {
                      Get.offAll(() => DashboardPage());
                    } else {
                      Get.snackbar(
                        "Location Error",
                        "Please allow location access.",
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                      );
                    }
                  } catch (e) {
                    Get.snackbar(
                      "Error",
                      "Failed to fetch location: $e",
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                    );
                  } finally {
                    isLoading.value = false; // Stop loading
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.divider, // Default background
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  minimumSize: const Size.fromHeight(43),
                ),
                child: isLoading.value
                    ? SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    color: AppColors.whiteColor, // Black loader
                    strokeWidth: 2.5,
                  ),
                )
                    : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.location_searching_outlined,
                      color: AppColors.whiteColor,
                      size: 16,
                    ),
                    SizedBox(width: 8),
                    TextStyleHelper.CustomText(
                      text: 'Use my current location',
                      color: AppColors.whiteColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      fontFamily: Assets.fontsPoppinsBold,
                    ),
                  ],
                ),
              )),
            ),
          ),
        ],
      ),
    );
  }
}