import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventapp/utills/appcolors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';
import '../../componets/text_style.dart';
import '../../controller/update_delete_cont.dart';
import '../../generated/assets.dart';

class UpdateDeleteEventPage extends StatelessWidget {
  UpdateDeleteEventPage({super.key});

  final UpdateDeleteEventController controller =
  Get.put(UpdateDeleteEventController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text(
            'Update & Delete Event',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w700,
              fontFamily: Assets.fontsPoppinsBold,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                  // Event Image Picker
                  GestureDetector(
                  onTap: () => controller.pickImage(),
          child: Obx(() => Column(
            children: [
            Container(
            height: 220,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: AppColors.divider,
            ),
            child: controller.eventImage.value == null &&
                controller.tempEventImageUrl.value.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment:
                MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_a_photo,
                      color: Colors.white, size: 40),
                  SizedBox(height: 8),
                  Text(
                    "Add Event Image",
                    style: TextStyle(color: Colors.white),
                  )
                ],
              ),
            )
                : Stack(
                fit: StackFit.expand,
                children: [
            ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: controller.eventImage.value !=
                null
                ? Image.file(
              controller.eventImage.value!,
              fit: BoxFit.cover,
            )
                : Image.network(
              controller.tempEventImageUrl.value,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Center(
                child: Icon(
                  Icons.broken_image,
                  color: Colors.white,
                  size: 40,
                ),
              ),
            ),
          ),
              if (!controller.eventImageConfirmed.value)
          Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
              color: Colors.black.withOpacity(0.7),
              padding: EdgeInsets.symmetric(
                  vertical: 12, horizontal: 16),
              child: Row(
                  mainAxisAlignment:
                  MainAxisAlignment.spaceEvenly,
                  children: [
                  ElevatedButton.icon(
                  onPressed: () =>
              controller.pickImage(),
          icon: Icon(Icons.refresh,
              color: Colors.white),
          label: Text("Change",
              style: TextStyle(
                  color: Colors.white)),
          style:
          ElevatedButton.styleFrom(
          backgroundColor:
          Colors.orange,
          padding:
          EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 10),
        ),
      ),
      ElevatedButton.icon(
        onPressed: () => controller
            .confirmAndUploadImage(),
        icon: Icon(Icons.check,
            color: Colors.white),
        label: Text("Confirm",
            style: TextStyle(
                color: Colors.white)),
        style:
        ElevatedButton.styleFrom(
          backgroundColor:
          Colors.green,
          padding:
          EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 10),
        ),
      ),
      ],
    ),
    ),
    ),
    if (controller.eventImageConfirmed.value)
    Positioned(
    top: 10,
    right: 10,
    child: Container(
    padding: EdgeInsets.all(10),
    decoration: BoxDecoration(
    color: Colors.green,
    shape: BoxShape.circle,
    ),
    child: Icon(
    Icons.check,
    color: Colors.white,
    size: 24,
    ),
    ),
    ),
    ],
    ),
    ),
    SizedBox(height: 10),
    Container(
    height: 40,
    width: double.infinity,
    decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(10),
    color: AppColors.greyColor,
    ),
    child: Padding(
    padding: const EdgeInsets.all(8.0),
    child: Row(
    children: [
    Icon(
    Icons.info_outline,
    color: AppColors.lightGrey,
    size: 16,
    ),
    SizedBox(width: 10),
    TextStyleHelper.CustomText(
    text:
    "Image dimension should be 1316 x 720.",
    color: AppColors.lightGrey,
    fontWeight: FontWeight.w400,
    fontSize: 14,
    fontFamily: Assets.fontsPoppinsRegular,
    )
    ],
    ),
    ),
    ),
    ],
    )),
    ),
    SizedBox(height: 20),

    // Title Field
    TextField(
    controller: controller.titleController,
    style: TextStyle(color: Colors.white),
    cursorColor: AppColors.whiteColor,
    decoration: InputDecoration(
    labelText: "Title",
    hintText: "Enter event title",
    labelStyle: TextStyle(color: Colors.grey),
    hintStyle: TextStyle(color: Colors.grey[600]),
    fillColor: AppColors.greyColor,
    filled: true,
    border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(color: Colors.grey),
    ),
    enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(color: Colors.grey),
    ),
    focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(color: Colors.grey),
    ),
    ),
    ),
    SizedBox(height: 15),

    // Date Picker
    GestureDetector(
    onTap: () => controller.selectDate(context),
    child: Obx(() => AbsorbPointer(
    child: TextField(
    style: TextStyle(color: Colors.white),
    cursorColor: AppColors.whiteColor,
    decoration: InputDecoration(
    hintText: controller.selectedDate.value == null
    ? "Select date"
        : DateFormat('dd MMM yyyy')
        .format(controller.selectedDate.value!),
    labelStyle: TextStyle(color: Colors.grey),
    hintStyle: TextStyle(
    color: controller.selectedDate.value == null
    ? Colors.grey[600]
        : Colors.white),
    fillColor: AppColors.greyColor,
    filled: true,
    border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(color: Colors.grey),
    ),
    enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(color: Colors.grey),
    ),
    focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(color: Colors.grey),
    ),
    suffixIcon:
    Icon(Icons.calendar_today, color: Colors.white),
    ),
    ),
    )),
    ),
    SizedBox(height: 15),

    // Time Picker
    GestureDetector(
    onTap: () => controller.selectTime(context),
    child: Obx(() => AbsorbPointer(
    child: TextField(
    style: TextStyle(color: Colors.white),
    cursorColor: AppColors.whiteColor,
    decoration: InputDecoration(
    hintText: controller.selectedTime.value == null
    ? "Select time"
        : controller.selectedTime.value!.format(context),
    labelStyle: TextStyle(color: Colors.grey),
    hintStyle: TextStyle(
    color: controller.selectedTime.value == null
    ? Colors.grey[600]
        : Colors.white),
    fillColor: AppColors.greyColor,
    filled: true,
    border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(color: Colors.grey),
    ),
    enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(color: Colors.grey),
    ),
    focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(color: Colors.grey),
    ),
    suffixIcon:
    Icon(Icons.access_time, color: Colors.white),
    ),
    ),
    )),
    ),
    SizedBox(height: 15),

    // Description
    TextField(
    controller: controller.descriptionController,
    cursorColor: AppColors.whiteColor,
    style: TextStyle(color: Colors.white),
    maxLines: 4,
    minLines: 3,
    decoration: InputDecoration(
    enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(color: Colors.grey),
    ),
    focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(color: Colors.grey),
    ),
    hintText: "Write your event description",
    hintStyle: TextStyle(color: Colors.grey[600]),
    labelText: "Description",
    labelStyle: TextStyle(color: Colors.grey),
    filled: true,
    fillColor: AppColors.greyColor,
    ),
    ),
    SizedBox(height: 15),

    // Language
    TextField(
    controller: controller.languageController,
    style: TextStyle(color: Colors.white),
    cursorColor: AppColors.whiteColor,
    decoration: InputDecoration(
    labelText: "Language",
    hintText: "Enter language",
    labelStyle: TextStyle(color: Colors.grey),
    hintStyle: TextStyle(color: Colors.grey[600]),
    fillColor: AppColors.greyColor,
    filled: true,
    border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(color: Colors.grey),
    ),
    enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(color: Colors.grey),
    ),
    focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(color: Colors.grey),
    ),
    ),
    ),
    SizedBox(height: 15),

    // Duration
    TextField(
    controller: controller.durationController,
    style: TextStyle(color: Colors.white),
    cursorColor: AppColors.whiteColor,
    decoration: InputDecoration(
    labelText: "Duration",
    hintText: "Enter duration (Ex: 3 Hours)",
    labelStyle: TextStyle(color: Colors.grey),
    hintStyle: TextStyle(color: Colors.grey[600]),
    fillColor: AppColors.greyColor,
    filled: true,
    border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(color: Colors.grey),
    ),
    enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(color: Colors.grey),
    ),
    focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(color: Colors.grey),
    ),
    ),
    ),
    SizedBox(height: 15),

    // Event City
    TextField(
    controller: controller.eventCityController,
    style: TextStyle(color: Colors.white),
    cursorColor: AppColors.whiteColor,
    decoration: InputDecoration(
    labelText: "Event city",
    hintText: "Enter city name",
    labelStyle: TextStyle(color: Colors.grey),
    hintStyle: TextStyle(color: Colors.grey[600]),
    fillColor: AppColors.greyColor,
    filled: true,
    border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(color: Colors.grey),
    ),
    enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(color: Colors.grey),
    ),
    focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(color: Colors.grey),
    ),
    ),
    ),
    SizedBox(height: 15),

    // Event State
    TextField(
    controller: controller.eventStateController,
    style: TextStyle(color: Colors.white),
    cursorColor: AppColors.whiteColor,
    decoration: InputDecoration(
    labelText: "Event state",
    hintText: "Enter state name",
    labelStyle: TextStyle(color: Colors.grey),
    hintStyle: TextStyle(color: Colors.grey[600]),
    fillColor: AppColors.greyColor,
    filled: true,
    border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(color: Colors.grey),
    ),
    enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(color: Colors.grey),
    ),
    focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(color: Colors.grey),
    ),
    ),
    ),
    SizedBox(height: 15),

    // Artist Section
    Container(
    margin: EdgeInsets.symmetric(vertical: 16),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Text(
    "Artists",
    style: TextStyle(
    color: Colors.white,
    fontSize: 16,
    fontWeight: FontWeight.bold,
    ),
    ),
    SizedBox(height: 10),
    Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Column(
    children: [
    GestureDetector(
    onTap: () => controller.pickArtistImage(),
    child: Obx(() => Stack(
    children: [
    CircleAvatar(
    radius: 35,
    backgroundColor: AppColors.greyColor,
    backgroundImage:
    controller.tempArtistImageUrl.value
        .isNotEmpty
    ? NetworkImage(
    controller
        .tempArtistImageUrl
        .value,
    )
        : controller.artistImage.value !=
    null
    ? FileImage(
    controller
        .artistImage.value!)
        : null,
    child: controller.artistImage.value ==
    null &&
    controller.tempArtistImageUrl
        .value.isEmpty
    ? Icon(Icons.add_a_photo,
    color: Colors.white, size: 25)
        : null,
    ),
    if (controller.artistImageConfirmed.value)
    Positioned(
    bottom: 0,
    right: 0,
    child: Container(
    padding: EdgeInsets.all(5),
    decoration: BoxDecoration(
    color: Colors.green,
    shape: BoxShape.circle,
    border: Border.all(
    color: Colors.white,
    width: 1.5),
    ),
    child: Icon(
    Icons.check,
    color: Colors.white,
    size: 12,
    ),
    ),
    ),
    ],
    )),
    ),
    Obx(() => controller.artistImage.value != null &&
    !controller.artistImageConfirmed.value
    ? Container(
    margin: EdgeInsets.only(top: 8),
    child: ElevatedButton(
    onPressed: () =>
    controller.confirmAndUploadArtistImage(),
    child: Text(
    "Upload",
    style: TextStyle(fontSize: 12),
    ),
    style: ElevatedButton.styleFrom(
    backgroundColor: Colors.green,
    padding: EdgeInsets.symmetric(
    horizontal: 12, vertical: 6),
    minimumSize: Size(70, 30),
    ),
    ),
    )
        : SizedBox.shrink()),
    ],
    ),
    SizedBox(width: 16),
    Expanded(
    child: TextField(
    controller: controller.artistNameController,
    style: TextStyle(color: Colors.white),
    decoration: InputDecoration(
    labelText: "Artist name",
    hintText: "Enter artist name",
    labelStyle: TextStyle(color: Colors.grey),
    hintStyle: TextStyle(color: Colors.grey[600]),
    fillColor: AppColors.greyColor,
    filled: true,
    border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(color: Colors.grey),
    ),
    enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(color: Colors.grey),
    ),
    focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(color: Colors.grey),
    ),
    ),
    ),
    ),
    IconButton(
    onPressed: () {
    controller.addArtist(
    controller.artistNameController.text,
    );
    controller.artistNameController.clear();
    },
    icon: Icon(Icons.add, color: Colors.white),
    ),
    ],
    ),
    ],
    ),
    ),
    SizedBox(height: 15),

    // Artist List
    Obx(() => Column(
    children: controller.artists.isNotEmpty
    ? controller.artists.map((artist) {
    return Padding(
    padding: EdgeInsets.only(bottom: 10),
    child: Container(
    padding: EdgeInsets.all(8),
    decoration: BoxDecoration(
    color: AppColors.greyColor,
    borderRadius: BorderRadius.circular(10),
    ),
    child: Row(
    children: [
    CircleAvatar(
    radius: 20,
    backgroundColor: Colors.grey[600],
    backgroundImage: artist['imageUrl'] !=
    null &&
    artist['imageUrl'].isNotEmpty
    ? NetworkImage(
    artist['imageUrl'] as String)
        : null,
    child: artist['imageUrl'] == null ||
    artist['imageUrl'].isEmpty
    ? Icon(Icons.person,
    color: Colors.white)
        : null,
    ),
    SizedBox(width: 10),
    Expanded(
    child: Text(
    artist['name'] ?? 'Unnamed Artist',
    style: TextStyle(
    color: Colors.white,
    fontSize: 16),
    ),
    ),
    IconButton(
    icon: Icon(Icons.delete,
    color: Colors.red),
    onPressed: () {
    controller.removeArtist(artist);
    },
    ),
    ],
    ),
    ),
    );
    }).toList()
        : [
    Padding(
    padding: EdgeInsets.only(bottom: 10),
    child: Text(
    'No artists added',
    style: TextStyle(color: Colors.grey),
    ),
    ),
    ],
    )),

    SizedBox(height: 15),

    // Ticket Section
    Container(
    margin: EdgeInsets.symmetric(vertical: 16),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Text(
    "Ticket Types",
    style: TextStyle(
    color: Colors.white,
    fontSize: 16,
    fontWeight: FontWeight.bold,
    ),
    ),
    SizedBox(height: 10),
    Row(
    children: [
    Expanded(
    child: TextField(
    controller: controller.ticketNameController,
    style: TextStyle(color: Colors.white),
    decoration: InputDecoration(
    labelText: "Ticket Name",
    hintText: "Enter ticket name",
    labelStyle: TextStyle(color: Colors.grey),
    hintStyle: TextStyle(color: Colors.grey[600]),
    fillColor: AppColors.greyColor,
    filled: true,
    border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(color: Colors.grey),
    ),
    enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(color: Colors.grey),
    ),
    focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(color: Colors.grey),
    ),
    ),
    ),
    ),
    SizedBox(width: 5),
    Expanded(
    child: TextField(
    controller: controller.ticketSeatController,
    style: TextStyle(color: Colors.white),
    decoration: InputDecoration(
    labelText: "Total seat",
    hintText: "Enter total seat",
    labelStyle: TextStyle(color: Colors.grey),
    hintStyle: TextStyle(color: Colors.grey[600]),
    fillColor: AppColors.greyColor,
    filled: true,
    border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(color: Colors.grey),
    ),
    enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(color: Colors.grey),
    ),
    focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(color: Colors.grey),
    ),
    ),
    ),
    ),
    SizedBox(width: 5),
    Expanded(
    child: TextField(
    controller: controller.ticketPriceController,
    style: TextStyle(color: Colors.white),
    decoration: InputDecoration(
    labelText: "Ticket price",
    hintText: "Enter ticket price",
    labelStyle: TextStyle(color: Colors.grey),
    hintStyle: TextStyle(color: Colors.grey[600]),
    fillColor: AppColors.greyColor,
    filled: true,
    border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(color: Colors.grey),
    ),
    enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(color: Colors.grey),
    ),
    focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(color: Colors.grey),
    ),
    ),
    ),
    ),
    IconButton(
    onPressed: () {
    controller.addTicketType(
    controller.ticketNameController.text,
    controller.ticketSeatController.text,
    controller.ticketPriceController.text,
    );
    controller.ticketNameController.clear();
    controller.ticketSeatController.clear();
    controller.ticketPriceController.clear();
    },
    icon: Icon(Icons.add, color: Colors.white),
    ),
    ],
    ),
    ],
    ),
    ),
    SizedBox(height: 10),

    // Ticket List
    Obx(() => Column(
    children: controller.tickets.isNotEmpty
    ? controller.tickets.map((ticket) {
    return Padding(
    padding: EdgeInsets.only(bottom: 10),
    child: Container(
    padding: EdgeInsets.all(8),
    decoration: BoxDecoration(
    color: AppColors.greyColor,
    borderRadius: BorderRadius.circular(10),
    ),
    child: Row(
    children: [
    Expanded(
    child: Text(
    ticket['name'] ?? '',
    style: TextStyle(
    color: Colors.white,
    fontSize: 16),
    ),
    ),
    SizedBox(width: 10),
    Expanded(
    child: Text(
    ticket['seat'] ?? '',
    style: TextStyle(
    color: Colors.white,
    fontSize: 16),
    ),
    ),
    SizedBox(width: 10),
    Expanded(
    child: Text(
    ticket['price'] ?? '',
    style: TextStyle(
    color: Colors.white,
    fontSize: 16),
    ),
    ),
    IconButton(
    icon: Icon(Icons.delete,
    color: Colors.red),
    onPressed: () {
    controller.removeTicket(ticket);
    },
    ),
    ],
    ),
    ),
    );
    }).toList()
        : [
    Padding(
    padding: EdgeInsets.only(bottom: 10),
    child: Text(
    'No tickets added',
    style: TextStyle(color: Colors.grey),
    ),
    ),
    ],
    )),
    SizedBox(height: 15),

    // Location/Map Section
    Container(
    padding: EdgeInsets.all(15),
    decoration: BoxDecoration(
    color: AppColors.greyColor,
    borderRadius: BorderRadius.circular(10),
    border: Border.all(color: Colors.grey),
    ),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Text(
    "Event Location",
    style: TextStyle(
    color: Colors.white,
    fontSize: 16,
    fontWeight: FontWeight.bold),
    ),
    SizedBox(height: 10),
    Obx(() => Text(
    controller.locationAddress.value.isEmpty
    ? "No location selected"
        : controller.locationAddress.value,
    style: TextStyle(color: Colors.grey),
    )),
    SizedBox(height: 15),
    ElevatedButton.icon(
    onPressed: () => Get.to(() => LocationPickerScreen(
    controller: controller)),
    icon: Icon(Icons.map, color: Colors.black),
    label: Text("Select on Map"),
    style: ElevatedButton.styleFrom(
    backgroundColor: AppColors.whiteColor,
    foregroundColor: Colors.black,
    minimumSize: Size(double.infinity, 45),
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(10),
    ),
    ),
    ),
    ],
    ),
    ),

    SizedBox(height: 30),

    // Update Button
    ElevatedButton(
    onPressed: () => controller.updateEvent(),
    style: ElevatedButton.styleFrom(
    backgroundColor: AppColors.whiteColor,
    foregroundColor: Colors.black,
    minimumSize: Size(double.infinity, 50),
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(10),
    ),
    ),
    child: Text(
    "Update Event",
    style: TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.black,
    fontFamily: Assets.fontsPoppinsBold),
    ),
    ),
    SizedBox(height: 15),

    // Delete Button
    ElevatedButton(
    onPressed: () {
    Get.defaultDialog(
    title: "Confirm Deletion",
    middleText: "Are you sure you want to delete this event?",
    textConfirm: "Yes",
    textCancel: "No",
    confirmTextColor: Colors.white,
    onConfirm: () => controller.deleteEvent(),
    buttonColor: Colors.red,
    cancelTextColor: Colors.grey,
    );
    },
    style: ElevatedButton.styleFrom(
    backgroundColor: Colors.red,
    foregroundColor: Colors.white,
    minimumSize: Size(double.infinity, 50),
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(10),
    ),
    ),
    child: Text(
    "Delete Event",
    style: TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.white,
    ),
    ),
    ),
    ],
    ),
    ),
    ),
    ),
    );
  }
}

// Location Picker Screen
class LocationPickerScreen extends StatefulWidget {
  final UpdateDeleteEventController controller;
  const LocationPickerScreen({required this.controller, super.key});

  @override
  _LocationPickerScreenState createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  GoogleMapController? mapController;
  final TextEditingController _searchController = TextEditingController();
  LatLng _center = const LatLng(37.7, -122.4);
  String _currentAddress = "";

  @override
  void initState() {
    super.initState();
    if (widget.controller.selectedLocation.value != null) {
      _center = widget.controller.selectedLocation.value!;
      _currentAddress = widget.controller.locationAddress.value;
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    mapController?.setMapStyle('''
      [
        {
          "elementType": "geometry",
          "stylers": [
            {
              "color": "#1d2c4d"
            }
          ]
        },
        {
          "elementType": "labels.text.fill",
          "stylers": [
            {
              "color": "#8ec3b9"
            }
          ]
        },
        {
          "elementType": "labels.text.stroke",
          "stylers": [
            {
              "color": "#1a3646"
            }
          ]
        },
        {
          "featureType": "administrative.country",
          "elementType": "geometry.stroke",
          "stylers": [
            {
              "color": "#4b6878"
            }
          ]
        },
        {
          "featureType": "administrative.land_parcel",
          "elementType": "labels.text.fill",
          "stylers": [
            {
              "color": "#64779e"
            }
          ]
        },
        {
          "featureType": "administrative.province",
          "elementType": "geometry.stroke",
          "stylers": [
            {
              "color": "#4b6878"
            }
          ]
        },
        {
          "featureType": "landscape.man_made",
          "elementType": "geometry.stroke",
          "stylers": [
            {
              "color": "#334e87"
            }
          ]
        },
        {
          "featureType": "landscape.natural",
          "elementType": "geometry",
          "stylers": [
            {
              "color": "#023e58"
            }
          ]
        },
        {
          "featureType": "poi",
          "elementType": "geometry",
          "stylers": [
            {
              "color": "#283d6a"
            }
          ]
        },
        {
          "featureType": "poi",
          "elementType": "labels.text.fill",
          "stylers": [
            {
              "color": "#6f9ba5"
            }
          ]
        },
        {
          "featureType": "poi",
          "elementType": "labels.text.stroke",
          "stylers": [
            {
              "color": "#1d2c4d"
            }
          ]
        },
        {
          "featureType": "poi.park",
          "elementType": "geometry.fill",
          "stylers": [
            {
              "color": "#023e58"
            }
          ]
        },
        {
          "featureType": "poi.park",
          "elementType": "labels.text.fill",
          "stylers": [
            {
              "color": "#3C7680"
            }
          ]
        },
        {
          "featureType": "road",
          "elementType": "geometry",
          "stylers": [
            {
              "color": "#304a7d"
            }
          ]
        },
        {
          "featureType": "road",
          "elementType": "labels.text.fill",
          "stylers": [
            {
              "color": "#98a5be"
            }
          ]
        },
        {
          "featureType": "road",
          "elementType": "labels.text.stroke",
          "stylers": [
            {
              "color": "#1d2c4d"
            }
          ]
        },
        {
          "featureType": "road.highway",
          "elementType": "geometry",
          "stylers": [
            {
              "color": "#2c6675"
            }
          ]
        },
        {
          "featureType": "road.highway",
          "elementType": "geometry.stroke",
          "stylers": [
            {
              "color": "#255763"
            }
          ]
        },
        {
          "featureType": "road.highway",
          "elementType": "labels.text.fill",
          "stylers": [
            {
              "color": "#b0d5ce"
            }
          ]
        },
        {
          "featureType": "road.highway",
          "elementType": "labels.text.stroke",
          "stylers": [
            {
              "color": "#023e58"
            }
          ]
        },
        {
          "featureType": "transit",
          "elementType": "labels.text.fill",
          "stylers": [
            {
              "color": "#98a5be"
            }
          ]
        },
        {
          "featureType": "transit",
          "elementType": "labels.text.stroke",
          "stylers": [
            {
              "color": "#1d2c4d"
            }
          ]
        },
        {
          "featureType": "transit.line",
          "elementType": "geometry.fill",
          "stylers": [
            {
              "color": "#283d6a"
            }
          ]
        },
        {
          "featureType": "transit.station",
          "elementType": "geometry",
          "stylers": [
            {
              "color": "#3a4762"
            }
          ]
        },
        {
          "featureType": "water",
          "elementType": "geometry",
          "stylers": [
            {
              "color": "#0e1626"
            }
          ]
        },
        {
          "featureType": "water",
          "elementType": "labels.text.fill",
          "stylers": [
            {
              "color": "#4e6d70"
            }
          ]
        }
      ]
    ''');
  }

  Future<void> _getAddressFromLatLng(LatLng position) async {
    try {
      List<Placemark> placemarks =
      await placemarkFromCoordinates(position.latitude, position.longitude);

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        setState(() {
          _currentAddress =
          '${place.street ?? ''}, ${place.subLocality ?? ''}, ${place.locality ?? ''}, ${place.country ?? ''}';
        });
      }
    } catch (e) {
      print(e);
      setState(() {
        _currentAddress = "Unable to get address";
      });
    }
  }

  void _searchLocation(String query) async {
    try {
      List<Location> locations = await locationFromAddress(query);
      if (locations.isNotEmpty) {
        Location location = locations.first;
        LatLng latLng = LatLng(location.latitude, location.longitude);
        _center = latLng;

        mapController?.animateCamera(CameraUpdate.newLatLngZoom(latLng, 14.0));
        await _getAddressFromLatLng(latLng);
      } else {
        Get.snackbar("Info", "Location not found. Please try another search term.",
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      print("Error searching location: $e");
      Get.snackbar("Error", "Unable to search location. Please try again.",
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Location'),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              widget.controller.setLocation(_center, _currentAddress);
              Get.back();
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 14.0,
            ),
            onCameraMove: (CameraPosition position) {
              _center = position.target;
            },
            onCameraIdle: () {
              _getAddressFromLatLng(_center);
            },
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            markers: {
              Marker(
                markerId: MarkerId('center'),
                position: _center,
                draggable: true,
                onDragEnd: (newPosition) {
                  _center = newPosition;
                  _getAddressFromLatLng(newPosition);
                },
              ),
            },
          ),
          // Search bar at top
          Positioned(
            top: 10,
            left: 10,
            right: 10,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 5,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search for a location',
                  hintStyle: TextStyle(color: Colors.grey[600]),
                  prefixIcon: Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                    },
                  ),
                  border: InputBorder.none,
                  contentPadding:
                  EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                ),
                onSubmitted: (value) {
                  if (value.isNotEmpty) {
                    _searchLocation(value);
                  }
                },
              ),
            ),
          ),
          // Address display at bottom
          Positioned(
            bottom: 20,
            left: 10,
            right: 60,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Selected Location',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    _currentAddress.isNotEmpty
                        ? _currentAddress
                        : 'Move the map to select a location',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Coordinates: ${_center.latitude.toStringAsFixed(4)}, ${_center.longitude.toStringAsFixed(4)}',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    mapController?.dispose();
    super.dispose();
  }
}