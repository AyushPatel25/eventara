import 'package:get/get.dart';
import 'package:flutter/material.dart';

class TicketCategory {
  String name;
  int price;
  RxInt availableSpots;
  RxInt selectedTickets = 0.obs;

  TicketCategory({
    required this.name,
    required this.price,
    required int spots,
  }) : availableSpots = spots.obs;
}