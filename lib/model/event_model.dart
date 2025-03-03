
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class EventModel {
  final String ageLimit;
  final String arrangement;

  //final Map<String, dynamic> artist;
  // final List<String> artist;
  final List<
      Artist> artists;
  final String eventCity;
  final String eventState;
  final String category;
  final String eventDate;
  final String expiryDate;
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
  double? latitude;
  double? longitude;


  EventModel({
    required this.ageLimit,
    required this.arrangement,
    required this.artists,
    required this.category,
    required this.eventDate,
    required this.expiryDate,
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
    required this.latitude, // ✅ Add these
    required this.longitude,
    required this.eventCity,
    required this.eventState,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    print("🔥 Raw Firebase Data: $json");

    LatLng parsedVenue = _parseVenue(json['venue']);
    double? latitude = parsedVenue.latitude;
    double? longitude = parsedVenue.longitude;

    if (json['latitude'] != null) {
      latitude = json['latitude'] is String ?
      double.tryParse(json['latitude']) :
      json['latitude'];
    }

    if (json['longitude'] != null) {
      longitude = json['longitude'] is String ?
      double.tryParse(json['longitude']) :
      json['longitude'];
    }

    EventModel event = EventModel(
      ageLimit: json['ageLimit'] ?? '',
      arrangement: json['arrangement'] ?? '',
      artists: (json['artists'] as List?)
          ?.map((e) => Artist.fromJson(e))
          .toList() ?? [],
      category: json['category'] ?? '',
      eventDate: json['eventDate'] ?? '',
      expiryDate: json['expiryDate'] ?? '',
      description: json['description'] ?? '',
      duration: json['duration'] ?? '',
      eventId: json['eventId'] ?? 0,
      eventImage: json['eventImage'] ?? '',
      language: json['language'] ?? '',
      layout: json['layout'] ?? '',
      location: json['location'] ?? '',
      ticketTypes: (json['ticketTypes'] as Map<String, dynamic>?)?.map(
            (key, value) => MapEntry(key, TicketType.fromJson(value)),
      ) ?? {},
      time: json['time'] ?? '',
      title: json['title'] ?? '',
      venue: parsedVenue,
      latitude: latitude,
      // ✅ Ensure non-nullable values
      longitude: longitude, // ✅ Ensure non-nullable values
      eventCity: json['eventCity'] ?? '',
      eventState: json['eventState'] ?? '',
    );

    print("✅ Parsed Venue Coordinates: ${event.venue.latitude}, ${event.venue
        .longitude}");
    print("✅ Event Lat/Lon: ${event.latitude}, ${event.longitude}");
    return event;
  }


  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {
      'ageLimit': ageLimit,
      'arrangement': arrangement,
      'artists': artists.map((e) => e.toJson()).toList(),
      'category': category,
      'eventDate': eventDate,
      'expiryDate': expiryDate,
      'description': description,
      'duration': duration,
      'eventId': eventId,
      'eventImage': eventImage,
      'language': language,
      'layout': layout,
      'location': location,
      'ticketTypes': ticketTypes.map((key, value) =>
          MapEntry(key, value.toJson())),
      'time': time,
      'title': title,
      'venue': [venue.latitude, venue.longitude],
      'eventCity': eventCity,
      'eventState': eventState,
    };

    print(
        "📤 EventModel converted to JSON: $data"); // Logs converted data before saving
    return data;
  }

  String getDay() {
    List<String> parts = eventDate.split(" ");
    return parts.isNotEmpty ? parts[0] : "--";
  }

  String getMonth() {
    List<String> parts = eventDate.split(" ");
    return parts.length > 1 ? parts[1] : "--";
  }

  int getStartingPrice() {
    if (ticketTypes.isEmpty) return 0;
    return ticketTypes.values.map((e) => e.price).reduce((a, b) =>
    a < b
        ? a
        : b);
  }


  static LatLng _parseVenue(dynamic venue) {
    print("📍 Raw Venue Data: $venue");

    double lat = 0.0;
    double lng = 0.0;
    bool validCoordinates = false;

    try {
      if (venue is GeoPoint) {
        lat = venue.latitude;
        lng = venue.longitude;
        validCoordinates = true;
      } else if (venue is List) {
        if (venue.length >= 2) {
          // Try to safely parse each coordinate
          if (venue[0] is num) {
            lat = (venue[0] as num).toDouble();
          } else if (venue[0] is String) {
            lat = double.tryParse(venue[0]) ?? 0.0;
          }

          if (venue[1] is num) {
            lng = (venue[1] as num).toDouble();
          } else if (venue[1] is String) {
            lng = double.tryParse(venue[1]) ?? 0.0;
          }

          validCoordinates = true;
        }
      } else if (venue is String) {
        // Handle string format
        venue = venue.replaceAll('°', ''); // Remove degree symbols
        List<String> parts = venue.split(',');
        if (parts.length >= 2) {
          String latStr = parts[0].replaceAll(RegExp(r'[^\d.-]'), '');
          String lngStr = parts[1].replaceAll(RegExp(r'[^\d.-]'), '');

          lat = double.tryParse(latStr) ?? 0.0;
          lng = double.tryParse(lngStr) ?? 0.0;
          validCoordinates = true;
        }
      } else if (venue is Map) {
        // Handle map format
        if (venue.containsKey('latitude') && venue.containsKey('longitude')) {
          var rawLat = venue['latitude'];
          var rawLng = venue['longitude'];

          if (rawLat is num) {
            lat = rawLat.toDouble();
          } else if (rawLat is String) {
            lat = double.tryParse(rawLat) ?? 0.0;
          }

          if (rawLng is num) {
            lng = rawLng.toDouble();
          } else if (rawLng is String) {
            lng = double.tryParse(rawLng) ?? 0.0;
          }

          validCoordinates = true;
        }
      }
    } catch (e) {
      print("❌ Error parsing venue: $e");
    }

    if (validCoordinates) {
      print("✅ Venue parsed: $lat, $lng");
    } else {
      print("❌ Venue parsing failed, returning (0.0, 0.0)");
    }

    return LatLng(lat, lng);
  }
}





class Artist {
  final String artistImage;
  final String artistName;

  Artist({required this.artistImage, required this.artistName});

  factory Artist.fromJson(Map<String, dynamic> json) {
    print("🎭 Artist Data: $json");
    return Artist(
      artistImage: json['artistImage'] ?? '', // ✅ Match Firestore field names
      artistName: json['artistName'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'artistImage': artistImage, // ✅ Match Firestore field names
      'artistName': artistName,
    };
  }
}



class TicketType {
  final int available;
  final int price;

  TicketType({required this.available, required this.price});

  factory TicketType.fromJson(Map<String, dynamic> json) {
    print("🎟️ TicketType Data: $json");
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
