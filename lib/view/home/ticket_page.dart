import 'package:eventapp/componets/past_ticket.dart';
import 'package:eventapp/componets/text_style.dart';
import 'package:eventapp/controller/ticket_cont.dart';
import 'package:eventapp/generated/assets.dart';
import 'package:eventapp/utills/appcolors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../componets/upcoming_ticket.dart';

class TicketPage extends StatelessWidget {
  const TicketPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TicketController ticketController = Get.put(TicketController());

    return DefaultTabController(
      length: 2,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.black,
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                surfaceTintColor: Colors.black,
                backgroundColor: Colors.black,
                title: TextStyleHelper.CustomText(
                  text: 'Tickets',
                  color: AppColors.whiteColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 25,
                  fontFamily: Assets.fontsPoppinsBold,
                ),
              ),

              SliverAppBar(
                pinned: true,
                surfaceTintColor: Colors.black,
                backgroundColor: Colors.black,
                flexibleSpace: TabBar(
                  tabAlignment: TabAlignment.start,
                  isScrollable: true,
                  indicatorColor: AppColors.primaryColor,
                  labelColor: AppColors.whiteColor,
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    fontFamily: Assets.fontsPoppinsBold,
                  ),
                  unselectedLabelColor: AppColors.lightGrey,
                  unselectedLabelStyle: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    fontFamily: Assets.fontsPoppinsBold,
                  ),
                  tabs: const [
                    Tab(text: "Upcoming"),
                    Tab(text: "Past tickets"),
                  ],
                ),
              ),

              SliverFillRemaining(
                child: TabBarView(
                  children: [
                    Obx(() {
                      if (ticketController.isLoading.value) {
                        return Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primaryColor,
                          ),
                        );
                      }

                      if (ticketController.upcomingTickets.isEmpty) {
                        return Center(
                          child: TextStyleHelper.CustomText(
                            text: "No Upcoming Tickets",
                            color: AppColors.whiteColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            fontFamily: Assets.fontsPoppinsRegular,
                          ),
                        );
                      }

                      return ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        itemCount: ticketController.upcomingTickets.length,
                        itemBuilder: (context, index) {
                          return UpcomingTicket(
                            ticket: ticketController.upcomingTickets[index],
                          );
                        },
                      );
                    }),

                    Obx(() {
                      if (ticketController.isLoading.value) {
                        return Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primaryColor,
                          ),
                        );
                      }

                      if (ticketController.pastTickets.isEmpty) {
                        return Center(
                          child: TextStyleHelper.CustomText(
                            text: "No Past Tickets",
                            color: AppColors.whiteColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            fontFamily: Assets.fontsPoppinsRegular,
                          ),
                        );
                      }

                      return ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        itemCount: ticketController.pastTickets.length,
                        itemBuilder: (context, index) {
                          return PastTicket(
                            ticket: ticketController.pastTickets[index],
                          );
                        },
                      );
                    }),
                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}