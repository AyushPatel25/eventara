import 'package:google_maps_flutter/google_maps_flutter.dart';

class EventModel {
  final String ageLimit;
  final String arrangement;
  final Map<String, dynamic> artist;
  final List<Artist> artist1;
  final String category;
  final String date;
  final String description;
  final String duration;
  final int eventId;
  final String eventImage;
  final String language;
  final String layout;
  final String location;
  final Map<String, TicketType> ticketTypes;
  final String time;
  final String title;
  final LatLng venue;

  EventModel({
    required this.ageLimit,
    required this.arrangement,
    required this.artist,
    required this.artist1,
    required this.category,
    required this.date,
    required this.description,
    required this.duration,
    required this.eventId,
    required this.eventImage,
    required this.language,
    required this.layout,
    required this.location,
    required this.ticketTypes,
    required this.time,
    required this.title,
    required this.venue,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      ageLimit: json['age limit'] ?? '',
      arrangement: json['arrangement'] ?? '',
      artist: json['artist'] ?? {}, // Store raw map
      artist1: (json['artist']['artist1'] as List?)?.map((e) => Artist.fromJson(e)).toList() ?? [],
      category: json['category'] ?? '',
      date: json['date'] ?? '',
      description: json['description'] ?? '',
      duration: json['duration'] ?? '',
      eventId: json['eventId'] ?? 0,
      eventImage: json['eventImage'] ?? '',
      language: json['language'] ?? '',
      layout: json['layout'] ?? '',
      location: json['location'] ?? '',
      ticketTypes: (json['ticketTypes'] as Map<String, dynamic>?)?.map(
            (key, value) => MapEntry(key, TicketType.fromJson(value)),
      ) ??
          {},
      time: json['time'] ?? '',
      title: json['title'] ?? '',
      venue: _parseVenue(json['venue']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'age limit': ageLimit,
      'arrangement': arrangement,
      'artist': {
        'artist1': artist1.map((e) => e.toJson()).toList(),
      },
      'category': category,
      'date': date,
      'description': description,
      'duration': duration,
      'eventId': eventId,
      'eventImage': eventImage,
      'language': language,
      'layout': layout,
      'location': location,
      'ticketTypes': ticketTypes.map((key, value) => MapEntry(key, value.toJson())),
      'time': time,
      'title': title,
      'venue': [venue.latitude, venue.longitude],
    };
  }

  static LatLng _parseVenue(dynamic venue) {
    if (venue is List && venue.length == 2) {
      double lat = double.tryParse(venue[0].toString()) ?? 0.0;
      double lng = double.tryParse(venue[1].toString()) ?? 0.0;
      return LatLng(lat, lng);
    }
    return LatLng(0.0, 0.0);
  }
}


class Artist {
  final String imageUrl;
  final String name;

  Artist({required this.imageUrl, required this.name});

  factory Artist.fromJson(dynamic json) {
    return Artist(
      imageUrl: json[0] ?? '',
      name: json[1] ?? '',
    );
  }

  List<dynamic> toJson() {
    return [imageUrl, name];
  }
}


class TicketType {
  final int available;
  final int price;

  TicketType({required this.available, required this.price});

  factory TicketType.fromJson(Map<String, dynamic> json) {
    return TicketType(
      available: json['available'] ?? 0,
      price: json['price'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'available': available,
      'price': price,
    };
  }
}
