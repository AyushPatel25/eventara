import 'package:eventapp/componets/text_style.dart';
import 'package:eventapp/controller/ticket_cont.dart';
import 'package:eventapp/view/home/eticket.dart';
import 'package:eventapp/view/home/feedback_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../generated/assets.dart';
import '../utills/appcolors.dart';

class PastTicket extends StatelessWidget {
  final Map<String, dynamic> ticket;

  PastTicket({super.key, required this.ticket});

  final TicketController ticketController = Get.find<TicketController>();

  @override
  Widget build(BuildContext context) {
    String eventName = ticket['eventName']?.toString() ?? 'Unknown Event';
    String location = ticket['eventLocation']?.toString() ?? 'Unknown Location';
    String eventImage = ticket['eventImage']?.toString() ?? '';
    String date = ticket['eventDate'] is String
        ? ticket['eventDate']
        : ticket['eventDate'] != null
        ? ticket['eventDate'].toString()
        : 'N/A';
    String time = ticket['eventTime']?.toString() ?? 'N/A';
    String seatNo = ticket['seatNo']?.toString() ?? 'Standing';
    String gateNo = ticket['gateNo']?.toString() ?? 'N/A';
    String ticketCategory = ticket['ticketCategory']?.toString() ?? 'N/A';
    String ticketPrice = ticket['ticketPrice']?.toString() ?? '0';
    String ticketCount = ticket['ticketCount']?.toString() ?? '1';
    String arrangement = ticket['arrangement']?.toString() ?? 'N/A';
    List<String> ticketNumbers = List<String>.from(ticket['ticketNumbers'] ?? []);
    String eventId = ticket['eventId']?.toString() ?? '';

    return SingleChildScrollView(
      child: Container(
        width: MediaQuery.of(context).size.width > 400 ? 400 : MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            Image.asset(Assets.imagesTicketRot, fit: BoxFit.cover, width: double.infinity),
            Padding(
              padding: const EdgeInsets.fromLTRB(25, 20, 25, 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 4,
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            eventName,
                            style: TextStyle(
                              color: AppColors.whiteColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              fontFamily: Assets.fontsPoppinsBold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 7),
                          Container(
                            height: 24,
                            child: FittedBox(
                              alignment: Alignment.centerLeft,
                              fit: BoxFit.scaleDown,
                              child: _ticketDetail("Location", location),
                            ),
                          ),
                          const SizedBox(height: 3),
                          Row(
                            children: [
                              Flexible(
                                flex: 1,
                                child: Container(
                                  height: 24,
                                  child: FittedBox(
                                    alignment: Alignment.centerLeft,
                                    fit: BoxFit.scaleDown,
                                    child: _ticketDetail("Date", date),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 15),
                              Flexible(
                                flex: 1,
                                child: Container(
                                  height: 24,
                                  child: FittedBox(
                                    alignment: Alignment.centerLeft,
                                    fit: BoxFit.scaleDown,
                                    child: _ticketDetail("Time", time),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 3),
                          Row(
                            children: [
                              Flexible(
                                flex: 1,
                                child: Container(
                                  height: 24,
                                  child: FittedBox(
                                    alignment: Alignment.centerLeft,
                                    fit: BoxFit.scaleDown,
                                    child: _ticketDetail("Category", ticketCategory),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 15),
                              Flexible(
                                flex: 1,
                                child: Container(
                                  height: 24,
                                  child: FittedBox(
                                    alignment: Alignment.centerLeft,
                                    fit: BoxFit.scaleDown,
                                    child: _ticketDetail("Price", ticketPrice),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          TextStyleHelper.CustomText(
                            text: 'For Feedback',
                            color: AppColors.lightGrey,
                            fontWeight: FontWeight.w400,
                            fontSize: 8,
                            fontFamily: Assets.fontsPoppinsRegular,
                          ),
                          IconButton(
                            onPressed: () {
                              if (eventId.isNotEmpty) {
                                Get.to(() => FeedbackPage(
                                  eventId: eventId,
                                  eventName: eventName,
                                  eventImage: eventImage,
                                ));
                              } else {
                                Get.snackbar('Error', 'Event ID not found for this ticket');
                              }
                            },
                            color: AppColors.whiteColor,
                            iconSize: 50,
                            icon: const Icon(Icons.arrow_circle_right_rounded),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _ticketDetail(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextStyleHelper.CustomText(
          text: label,
          color: AppColors.lightGrey,
          fontWeight: FontWeight.w400,
          fontSize: 7,
          fontFamily: Assets.fontsPoppinsRegular,
        ),
        TextStyleHelper.CustomText(
          text: value,
          color: AppColors.whiteColor,
          fontWeight: FontWeight.w400,
          fontSize: 10,
          fontFamily: Assets.fontsPoppinsRegular,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}