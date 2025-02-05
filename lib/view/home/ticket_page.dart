import 'package:eventapp/componets/past_ticket.dart';
import 'package:eventapp/componets/text_style.dart';
import 'package:eventapp/controller/ticket_cont.dart';
import 'package:eventapp/generated/assets.dart';
import 'package:eventapp/utills/appcolors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../componets/upcoming_ticket.dart';

class TicketPage extends GetView<TicketController> {
  const TicketPage({super.key});

  @override
  Widget build(BuildContext context) {
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
                  fontSize: 30,
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
                    fontSize: 15,
                    fontFamily: Assets.fontsPoppinsBold,
                  ),
                  unselectedLabelColor: AppColors.lightGrey,
                  unselectedLabelStyle: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 15,
                    fontFamily: Assets.fontsPoppinsBold,
                  ),
                  tabs: const [
                    Tab(text: "Upcoming"),
                    Tab(text: "Past tickets"),
                  ],
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.8,
                  child: TabBarView(
                    children: [
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: ListView.separated(
                            physics: NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.zero,
                            itemBuilder: (context, index) => UpcomingTicket(),
                            separatorBuilder: (context, index) => SizedBox(height: 0),
                            itemCount: 4,
                          ),
                        )
                      ),
                      Center(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            child: ListView.separated(
                              physics: NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.zero,
                              itemBuilder: (context, index) => PastTicket(),
                              separatorBuilder: (context, index) => SizedBox(height: 0),
                              itemCount: 4,
                            ),
                          )
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

