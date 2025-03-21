import 'package:eventapp/componets/text_style.dart';
import 'package:eventapp/generated/assets.dart';
import 'package:eventapp/utills/appcolors.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import '../../controller/createEvent_cont.dart';

class CreateEvent extends StatelessWidget {
  CreateEvent({super.key});

  final CreateEventController controller = Get.put(CreateEventController());
  final TextEditingController artistNameController = TextEditingController();
  final TextEditingController ticketNameController = TextEditingController();
  final TextEditingController ticketSeatController = TextEditingController();
  final TextEditingController ticketPriceController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController languageController = TextEditingController();
  final TextEditingController durationController = TextEditingController();
  final TextEditingController eventCityController = TextEditingController();
  final TextEditingController eventStateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              surfaceTintColor: Colors.black,
              backgroundColor: Colors.black,
              title: Text(
                'Create event',
                style: TextStyle(
                    color: AppColors.whiteColor,
                    fontSize: 25,
                    fontWeight: FontWeight.w700,
                    fontFamily: Assets.fontsPoppinsBold),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Event Image Picker
                    GestureDetector(
                      onTap: () => controller.pickImage('event'),
                      child: Obx(() => Column(
                        children: [
                          Container(
                            height: 220,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color: AppColors.divider,
                            ),
                            child: controller.eventImage.value == null
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
                                  borderRadius:
                                  BorderRadius.circular(25),
                                  child: Image.file(
                                    controller.eventImage.value!,
                                    fit: BoxFit.cover,
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
                                                controller.pickImage('event'),
                                            icon: Icon(Icons.refresh,
                                                color: Colors.white),
                                            label: Text("Change",
                                                style: TextStyle(
                                                    color: Colors.white)),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.orange,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 16, vertical: 10),
                                            ),
                                          ),
                                          ElevatedButton.icon(
                                            onPressed: () =>
                                                controller.confirmAndUploadImage(
                                                    'event'),
                                            icon: Icon(Icons.check,
                                                color: Colors.white),
                                            label: Text("Confirm",
                                                style: TextStyle(
                                                    color: Colors.white)),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.green,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 16, vertical: 10),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                // Confirmation badge when image is confirmed
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
                                      text: "Image dimension should be 1316 x 720.",
                                      color: AppColors.lightGrey,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14,
                                      fontFamily: Assets.fontsPoppinsRegular)
                                ],
                              ),
                            ),
                          ),
                        ],
                      )),
                    ),
                    SizedBox(height: 15),

                    // Title
                    TextField(
                      controller: controller.titleController,
                      style: TextStyle(color: Colors.white),
                      cursorColor: AppColors.whiteColor,
                      decoration: InputDecoration(
                        labelText: "Title",
                        hintText: "Enter title",
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
                            suffixIcon: Icon(Icons.calendar_today,
                                color: Colors.white),
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
                                : controller.selectedTime.value!
                                .format(context),
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
                            suffixIcon: Icon(Icons.access_time,
                                color: Colors.white),
                          ),
                        ),
                      )),
                    ),
                    SizedBox(height: 15),

                    // Location
                    // TextField(
                    //   controller: controller.locationController,
                    //   style: TextStyle(color: Colors.white),
                    //   cursorColor: AppColors.whiteColor,
                    //   decoration: InputDecoration(
                    //     labelText: "Location",
                    //     hintText: "Enter location",
                    //     labelStyle: TextStyle(color: Colors.grey),
                    //     hintStyle: TextStyle(color: Colors.grey[600]),
                    //     fillColor: AppColors.greyColor,
                    //     filled: true,
                    //     border: OutlineInputBorder(
                    //       borderRadius: BorderRadius.circular(10),
                    //       borderSide: BorderSide(color: Colors.grey),
                    //     ),
                    //     enabledBorder: OutlineInputBorder(
                    //       borderRadius: BorderRadius.circular(10),
                    //       borderSide: BorderSide(color: Colors.grey),
                    //     ),
                    //     focusedBorder: OutlineInputBorder(
                    //       borderRadius: BorderRadius.circular(10),
                    //       borderSide: BorderSide(color: Colors.grey),
                    //     ),
                    //   ),
                    // ),
                    // SizedBox(height: 15),

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

                    Obx(() => Container(
                      height: 60,
                      decoration: BoxDecoration(
                        color: AppColors.greyColor,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: Center(
                        child: DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            labelText: "Layout",
                            labelStyle: TextStyle(color: Colors.grey),
                            border: InputBorder.none,
                            contentPadding:
                            EdgeInsets.symmetric(horizontal: 12),
                          ),
                          dropdownColor: AppColors.greyColor,
                          style: TextStyle(color: Colors.white),
                          value: controller.layout.value,
                          items: ['Indoor', 'Outdoor']
                              .map((String value) => DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          ))
                              .toList(),
                          onChanged: (value) {
                            if (value != null) controller.layout.value = value;
                          },
                        ),
                      ),
                    )),
                    SizedBox(height: 15),

                    // Age Limit Dropdown
                    Obx(() => Container(
                      height: 60,
                      decoration: BoxDecoration(
                        color: AppColors.greyColor,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: Center(
                        child: DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            labelText: "Age Limit",
                            labelStyle: TextStyle(color: Colors.grey),
                            border: InputBorder.none,
                            contentPadding:
                            EdgeInsets.symmetric(horizontal: 12),
                          ),
                          dropdownColor: AppColors.greyColor,
                          style: TextStyle(color: Colors.white),
                          value: controller.ageLimit.value,
                          items: ['15 and above', '18 and above', 'All']
                              .map((String value) => DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          ))
                              .toList(),
                          onChanged: (value) {
                            if (value != null) controller.ageLimit.value = value;
                          },
                        ),
                      ),
                    )),
                    SizedBox(height: 15),

                    // Category Dropdown
                    Obx(() => Container(
                      height: 60,
                      decoration: BoxDecoration(
                        color: AppColors.greyColor,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: Center(
                        child: DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            labelText: "Category",
                            labelStyle: TextStyle(color: Colors.grey),
                            border: InputBorder.none,
                            contentPadding:
                            EdgeInsets.symmetric(horizontal: 12),
                          ),
                          dropdownColor: AppColors.greyColor,
                          style: TextStyle(color: Colors.white),
                          value: controller.category.value,
                          items: [
                            'Concert',
                            'Comedy',
                            'Sport',
                            'Party',
                            'Show'
                          ]
                              .map((String value) => DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          ))
                              .toList(),
                          onChanged: (value) {
                            if (value != null) controller.category.value = value;
                          },
                        ),
                      ),
                    )),
                    SizedBox(height: 15),

                    // Arrangement Dropdown
                    Obx(() => Container(
                      height: 60,
                      decoration: BoxDecoration(
                        color: AppColors.greyColor,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: Center(
                        child: DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            labelText: "Arrangement",
                            labelStyle: TextStyle(color: Colors.grey),
                            border: InputBorder.none,
                            contentPadding:
                            EdgeInsets.symmetric(horizontal: 12),
                          ),
                          dropdownColor: AppColors.greyColor,
                          style: TextStyle(color: Colors.white),
                          value: controller.arrangement.value,
                          items: ['Standing', 'Sitting']
                              .map((String value) => DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          ))
                              .toList(),
                          onChanged: (value) {
                            if (value != null)
                              controller.arrangement.value = value;
                          },
                        ),
                      ),
                    )),
                    SizedBox(height: 15),

                    // Artist Section
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                children: [
                                  GestureDetector(
                                    onTap: () => controller.pickImage('artist'),
                                    child: Obx(() => Stack(
                                      children: [
                                        CircleAvatar(
                                          radius: 35,
                                          backgroundColor: AppColors.greyColor,
                                          backgroundImage: controller.artistImage.value != null
                                              ? FileImage(controller.artistImage.value!)
                                              : null,
                                          child: controller.artistImage.value == null
                                              ? Icon(Icons.add_a_photo, color: Colors.white, size: 25)
                                              : null,
                                        ),
                                        // Confirmation badge when image is confirmed
                                        if (controller.artistImageConfirmed.value)
                                          Positioned(
                                            bottom: 0,
                                            right: 0,
                                            child: Container(
                                              padding: EdgeInsets.all(5),
                                              decoration: BoxDecoration(
                                                color: Colors.green,
                                                shape: BoxShape.circle,
                                                border: Border.all(color: Colors.white, width: 1.5),
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
                                  // Confirmation button for artist image - only show if image selected but not confirmed
                                  Obx(() => controller.artistImage.value != null && !controller.artistImageConfirmed.value
                                      ? Container(
                                    margin: EdgeInsets.only(top: 8),
                                    child: ElevatedButton(
                                      onPressed: () => controller.confirmAndUploadImage('artist'),
                                      child: Text(
                                        "Upload",
                                        style: TextStyle(fontSize: 12),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green,
                                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                        minimumSize: Size(70, 30),
                                      ),
                                    ),
                                  )
                                      : SizedBox.shrink()
                                  ),
                                ],
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: TextField(
                                  controller: artistNameController,
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
                                    artistNameController.text,
                                  );
                                  artistNameController.clear();
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
                      children: controller.artists
                          .map((artist) => Padding(
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
                                backgroundImage:
                                artist['image'] != null
                                    ? FileImage(artist['image'])
                                    : null,
                                child: artist['image'] == null
                                    ? Icon(Icons.person,
                                    color: Colors.white)
                                    : null,
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  artist['name'],
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16),
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete,
                                    color: Colors.red),
                                onPressed: () {
                                  controller.artists.remove(artist);
                                },
                              )
                            ],
                          ),
                        ),
                      ))
                          .toList(),
                    )),

                    SizedBox(height: 15),

                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: ticketNameController,
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
                            controller: ticketSeatController,
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
                            controller: ticketPriceController,
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
                                ticketNameController.text,
                                ticketSeatController.text,
                                ticketPriceController.text);
                            ticketNameController.clear();
                            ticketSeatController.clear();
                            ticketPriceController.clear();
                          },
                          icon: Icon(Icons.add, color: Colors.white),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Obx(() => Column(
                      children: controller.tickets
                          .map((ticket) => Padding(
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
                                  ticket['name'],
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16),
                                ),
                              ),
                              SizedBox(height: 10),
                              Expanded(
                                child: Text(
                                  ticket['seat'],
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16),
                                ),
                              ),
                              SizedBox(height: 10),
                              Expanded(
                                child: Text(
                                  ticket['price'],
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16),
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete,
                                    color: Colors.red),
                                onPressed: () {
                                  controller.tickets.remove(ticket);
                                },
                              )
                            ],
                          ),
                        ),
                      ))
                          .toList(),
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
                          //SizedBox(height: 10),
                          // Row(
                          //   children: [
                          //     Expanded(
                          //       child: Obx(() => Text(
                          //         controller.selectedLocation.value == null
                          //             ? "Coordinates: Not selected"
                          //             : "Lat: ${controller.selectedLocation.value!.latitude.toStringAsFixed(6)}, Lng: ${controller.selectedLocation.value!.longitude.toStringAsFixed(6)}",
                          //         style: TextStyle(color: Colors.grey),
                          //       )),
                          //     ),
                          //   ],
                          // ),
                          SizedBox(height: 15),
                          ElevatedButton.icon(
                            onPressed: () =>
                                Get.to(() => LocationPickerScreen(controller: controller)),
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

                    // Submit Button
                    ElevatedButton(
                      onPressed: () {
                        // if (controller.eventImage.value == null ||
                        //     controller.selectedLocation.value == null) {
                        //   Get.snackbar(
                        //     "Error",
                        //     "Please upload an event image and select a location",
                        //     backgroundColor: Colors.red,
                        //     colorText: Colors.white,
                        //     snackPosition: SnackPosition.BOTTOM,
                        //   );
                        //   return;
                        // }
                        // if (titleController.text.isEmpty ||
                        //     locationController.text.isEmpty ||
                        //     descriptionController.text.isEmpty ||
                        //     languageController.text.isEmpty ||
                        //     durationController.text.isEmpty ||
                        //     eventCityController.text.isEmpty ||
                        //     eventStateController.text.isEmpty) {
                        //   Get.snackbar(
                        //     "Error",
                        //     "Please fill all the data",
                        //     backgroundColor: Colors.red,
                        //     colorText: Colors.white,
                        //     snackPosition: SnackPosition.BOTTOM,
                        //   );
                        //   return;
                        // }
                        controller.saveEvent(context); // Pass context here
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.whiteColor,
                        foregroundColor: Colors.black,
                        minimumSize: Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        "Create Event",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LocationPickerScreen extends StatefulWidget {
  final CreateEventController controller;
  const LocationPickerScreen({required this.controller, super.key});

  @override
  _LocationPickerScreenState createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  GoogleMapController? mapController;
  final TextEditingController _searchController = TextEditingController();
  LatLng _center = const LatLng(21.2049, 72.8411);
  String _currentAddress = "";

  @override
  void initState() {
    super.initState();
    // If there's already a selected location, use it
    if (widget.controller.selectedLocation.value != null) {
      _center = widget.controller.selectedLocation.value!;
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    // Apply dark theme to map
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
          '${place.street}, ${place.subLocality}, ${place.locality}, ${place.country}';
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
        Get.snackbar(
            "Info", "Location not found. Please try another search term.",
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
        title: Text('Select Location', style: TextStyle(
          color: AppColors.whiteColor,
          fontFamily: Assets.fontsPoppinsBold,
          fontSize: 25
        ),),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              widget.controller.setLocation(_center, _currentAddress);
              Navigator.pop(context);
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
                      IconButton(
                        icon: Icon(Icons.my_location, color: Colors.white),
                        onPressed: () async {
                          Position position =
                          await Geolocator.getCurrentPosition();
                          LatLng currentLocation =
                          LatLng(position.latitude, position.longitude);
                          _center = currentLocation;
                          mapController?.animateCamera(
                              CameraUpdate.newLatLngZoom(currentLocation, 16.0));
                          await _getAddressFromLatLng(currentLocation);
                        },
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(),
                        iconSize: 20,
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