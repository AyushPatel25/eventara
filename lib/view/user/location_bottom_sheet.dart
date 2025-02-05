import 'package:eventapp/componets/button.dart';
import 'package:eventapp/componets/text_field.dart';
import 'package:eventapp/componets/text_style.dart';
import 'package:eventapp/generated/assets.dart';
import 'package:eventapp/utills/appcolors.dart';
import 'package:eventapp/view/home/dashboard_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:country_state_city/country_state_city.dart';

import '../../controller/loc_cont.dart';
import '../home/home_page.dart';

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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          SizedBox(height: 57,),
          // AppBar
          AppBar(
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: Colors.black,
              systemNavigationBarColor: Colors.black,
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
            )
          ),
          SizedBox(height: 20),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
            child: Obx(() => TextField(
              controller: _searchController,
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
                  borderSide: BorderSide(color: AppColors.whiteColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: AppColors.whiteColor),
                ),
                prefixIcon: Icon(Icons.search, color: AppColors.whiteColor),
                hintText: "Search ${locationController.currentType.value}",
                hintStyle: TextStyle(
                  color: Colors.grey,
                  fontFamily: 'regular',
                ),
                filled: true,
                fillColor: AppColors.greyColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: AppColors.primaryColor),
                ),
              ),
            )),
          ),

          Visibility(visible: locationController.selectedCountry.isNotEmpty?true:false, child: SizedBox(height: 10)),

          // visible: locationController.selectedCountry.isNotEmpty?true:false,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
            child: Obx(() => SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  if (locationController.selectedCountry.isNotEmpty)
                    Chip(
                      label: Text(locationController.selectedCountry.value, style: TextStyle(color: AppColors.whiteColor, fontFamily: Assets.fontsPoppinsRegular),),
                      onDeleted: () {
                        locationController.selectedCountry.value = "";
                        locationController.selectedState.value = "";
                        locationController.selectedCity.value = "";
                        locationController.chips.clear();
                        locationController.loadCountries();
                        locationController.currentType.value = "Country";
                      },
                    ),
                  if (locationController.selectedState.isNotEmpty)
                    Chip(
                      label: Text(locationController.selectedState.value, style: TextStyle(color: AppColors.whiteColor, fontFamily: Assets.fontsPoppinsRegular),),
                      onDeleted: () {
                        locationController.selectedState.value = "";
                        locationController.selectedCity.value = "";
                        locationController.loadStates(locationController.selectedCountryCode);
                        locationController.currentType.value = "State";
                      },
                    ),
                  if (locationController.selectedCity.isNotEmpty)
                    Chip(
                      label: Text(locationController.selectedCity.value, style: TextStyle(color: AppColors.whiteColor, fontFamily: Assets.fontsPoppinsRegular),),
                      onDeleted: () {
                        locationController.selectedCity.value = "";
                        locationController.loadCities(locationController.selectedCountryCode, locationController.selectedStateCode);
                        locationController.currentType.value = "City";
                      },
                    ),
                ],
              ),
            )),
          ),
          Visibility(visible: locationController.selectedCountry.isNotEmpty?true:false, child: SizedBox(height: 10)),

          // List of Items (Countries, States, Cities)
          Visibility(
            visible: locationController.displayList.isEmpty?false:true,
            child: Expanded(
              child: Obx(() => ListView.builder(
                itemCount: locationController.displayList.length,
                itemBuilder: (context, index) {
                  var item = locationController.displayList[index];
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: ListTile(
                      title: Text(item.name, style: TextStyle(color: AppColors.whiteColor, fontFamily: Assets.fontsPoppinsRegular)),
                      onTap: () {
                        locationController.handleSelection(item);
                        _searchController.clear();

                        if (locationController.selectedCity.isNotEmpty) {
                          locationController.displayList.clear();
                          Get.back();

                        }
                      }
                    ),
                  );
                },
              )),
            ),
          ),


          // Allow Location Button
          Visibility(
            visible: locationController.displayList.isEmpty?true:false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
              child: ElevatedButton.icon(
                onPressed: () async {
                  final locationController = Get.find<LocationController>();
                  locationController.isManualSelection.value = false;
                  await locationController.getLocation();

                  if (locationController.latitude.value != 'Getting Latitude..') {
                    Get.offAll(() => DashboardPage());
                  } else {
                    Get.snackbar("Location Error", "Please allow location access.");
                  }
                },
                icon: Icon(
                  Icons.location_searching_outlined,
                  color: AppColors.whiteColor,
                  size: 16,
                ),
                label: TextStyleHelper.CustomText(
                  text: 'Use my current location',
                  color: AppColors.whiteColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  fontFamily: Assets.fontsPoppinsBold,
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.divider,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  minimumSize: const Size.fromHeight(53),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
