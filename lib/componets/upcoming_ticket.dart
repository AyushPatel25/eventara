import 'package:eventapp/componets/text_style.dart';
import 'package:eventapp/controller/ticket_cont.dart';
import 'package:eventapp/view/home/eticket.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../generated/assets.dart';
import '../utills/appcolors.dart';

class UpcomingTicket extends StatelessWidget {
  final Map<String, dynamic> ticket;

  UpcomingTicket({super.key, required this.ticket});

  final TicketController ticketController = Get.find<TicketController>();

  @override
  Widget build(BuildContext context) {
    String eventName = ticket['eventName'] ?? 'Unknown Event';
    String location = ticket['eventLocation'] ?? 'Unknown Location';
    String eventImage = ticket['eventImage'] ?? '';
    String date = ticket['eventDate'] ?? 'N/A';
    String time = ticket['eventTime'].toString() ?? 'N/A';
    String seatNo = ticket['seatNo'] ?? 'Standing';
    String gateNo = ticket['gateNo'] ?? 'N/A';
    String ticketCategory = ticket['ticketCategory'];
    int ticketPrice = ticket['ticketPrice'];
    int ticketCount = ticket['ticketCount'];
    String arrangement = ticket['arrangement'];
    List<String> ticketNumbers = List<String>.from(ticket['ticketNumbers'] ?? []);

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
                      //color: Colors.red,
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
                                  child: _ticketDetail("Location", location)
                              )
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
                                        child: _ticketDetail("Date", date)
                                    )
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
                                        child: _ticketDetail("Time", time)
                                    )
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
                                        child: _ticketDetail("Category", ticketCategory)
                                    )
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
                                        child: _ticketDetail("Price", ticketPrice.toString())
                                    )
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
                      //color: Colors.red,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          TextStyleHelper.CustomText(
                            text: 'For E-Ticket',
                            color: AppColors.lightGrey,
                            fontWeight: FontWeight.w400,
                            fontSize: 8,
                            fontFamily: Assets.fontsPoppinsRegular,
                          ),
                          IconButton(
                            onPressed: () {
                              Get.to(() => Eticket(), arguments: {
                                'eventImage': eventImage,
                                'eventName': eventName,
                                'eventLocation': location,
                                'eventDate': date,
                                'ticketCategory': ticketCategory,
                                'ticketPrice': ticketPrice,
                                'ticketCount': ticketCount,
                                'eventTime': time,
                                'arrangement': arrangement,
                                'ticketNumbers': ticketNumbers,
                                'fromBookTicket': false,
                              })!.then((_) {
                                ticketController.fetchUserTickets(); // Refresh tickets after returning
                              });
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
            )
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