// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
//
// class EventModel {
//   final String ageLimit;
//   final String arrangement;
//   final Map<String, dynamic> artist;
//   final List<Artist> artist1;
//   final String category;
//   final String eventDate;
//   final String expiryDate;
//   final String description;
//   final String duration;
//   final int eventId;
//   final String eventImage;
//   final String language;
//   final String layout;
//   final String location;
//   final Map<String, TicketType> ticketTypes;
//   final String time;
//   final String title;
//   final LatLng venue;
//
//   EventModel({
//     required this.ageLimit,
//     required this.arrangement,
//     required this.artist,
//     required this.artist1,
//     required this.category,
//     required this.eventDate,
//     required this.expiryDate,
//     required this.description,
//     required this.duration,
//     required this.eventId,
//     required this.eventImage,
//     required this.language,
//     required this.layout,
//     required this.location,
//     required this.ticketTypes,
//     required this.time,
//     required this.title,
//     required this.venue,
//   });
//
//   factory EventModel.fromJson(Map<String, dynamic> json) {
//     return EventModel(
//       ageLimit: json['ageLimit'] ?? '',
//       arrangement: json['arrangement'] ?? '',
//       artist: json['artist'] ?? {},
//       artist1: (json['artist1'] as List?)?.map((e) => Artist.fromJson(e)).toList() ?? [],
//       category: json['category'] ?? '',
//       eventDate: json['eventDate'] ?? '',
//       expiryDate: json['expiryDate'] ?? '',
//       description: json['description'] ?? '',
//       duration: json['duration'] ?? '',
//       eventId: json['eventId'] ?? 0,
//       eventImage: json['eventImage'] ?? '',
//       language: json['language'] ?? '',
//       layout: json['layout'] ?? '',
//       location: json['location'] ?? '',
//       ticketTypes: (json['ticketTypes'] as Map<String, dynamic>?)?.map(
//             (key, value) => MapEntry(key, TicketType.fromJson(value)),
//       ) ?? {},
//       time: json['time'] ?? '',
//       title: json['title'] ?? '',
//       venue: _parseVenue(json['venue']), // ✅ Fix applied here
//     );
//   }
//
//
//
//
//   // factory EventModel.fromJson(Map<String, dynamic> json) {
//   //   return EventModel(
//   //     ageLimit: json['ageLimit'] ?? '',
//   //     arrangement: json['arrangement'] ?? '',
//   //     artist: json['artist'] ?? {},
//   //     artist1: (json['artist1'] as List?)
//   //         ?.map((e) => Artist.fromJson(e))
//   //         .toList() ?? [],
//   //     // Corrected parsing
//   //     category: json['category'] ?? '',
//   //     eventDate: json['eventDate'] ?? '',
//   //     expiryDate: json['expiryDate'] ?? '',
//   //     description: json['description'] ?? '',
//   //     duration: json['duration'] ?? '',
//   //     eventId: json['eventId'] ?? 0,
//   //     eventImage: json['eventImage'] ?? '',
//   //     language: json['language'] ?? '',
//   //     layout: json['layout'] ?? '',
//   //     location: json['location'] ?? '',
//   //     ticketTypes: (json['ticketTypes'] as Map<String, dynamic>?)?.map(
//   //           (key, value) => MapEntry(key, TicketType.fromJson(value)),
//   //     ) ?? {},
//   //     time: json['time'] ?? '',
//   //     title: json['title'] ?? '',
//   //     venue: _parseVenue(json['venue']),
//   //   );
//   // }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'age limit': ageLimit,
//       'arrangement': arrangement,
//       'artist': {
//         'artist1': artist1.map((e) => e.toJson()).toList(),
//       },
//       'category': category,
//       'eventDate': eventDate,
//       'expiryDate': expiryDate,
//       'description': description,
//       'duration': duration,
//       'eventId': eventId,
//       'eventImage': eventImage,
//       'language': language,
//       'layout': layout,
//       'location': location,
//       'ticketTypes': ticketTypes.map((key, value) =>
//           MapEntry(key, value.toJson())),
//       'time': time,
//       'title': title,
//       'venue': [venue.latitude, venue.longitude],
//     };
//   }
//
//   static LatLng _parseVenue(dynamic venue) {
//     if (venue is List && venue.length == 2) {
//       return LatLng(venue[0], venue[1]); // Directly extracting values
//     } else if (venue is String) {
//       // Handle string format like "21.15534° N, 72.76881° E"
//       List<String> coords = venue.replaceAll(RegExp(r'[^\d.,-]'), '').split(
//           ',');
//       if (coords.length == 2) {
//         double? lat = double.tryParse(coords[0]);
//         double? lng = double.tryParse(coords[1]);
//         if (lat != null && lng != null) return LatLng(lat, lng);
//       }
//     }
//     return LatLng(0.0, 0.0); // Default fallback
//   }
// }
//
//   class Artist {
//   final String imageUrl;
//   final String name;
//
//   Artist({required this.imageUrl, required this.name});
//
//   factory Artist.fromJson(dynamic json) {
//     return Artist(
//       imageUrl: json[0] ?? '',
//       name: json[1] ?? '',
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'imageUrl': imageUrl,
//       'name': name,
//     };
//   }
// }
//
// class TicketType {
//   final int available;
//   final int price;
//
//   TicketType({required this.available, required this.price});
//
//   factory TicketType.fromJson(Map<String, dynamic> json) {
//     return TicketType(
//       available: json['available'] ?? 0,
//       price: json['price'] ?? 0,
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'available': available,
//       'price': price,
//     };
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class EventModel {
  final String ageLimit;
  final String arrangement;
  //final Map<String, dynamic> artist;
  // final List<String> artist;
  final List<Artist> artists; // ✅ Change from Map<String, dynamic> to List<Artist>

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

  EventModel({
    required this.ageLimit,
    required this.arrangement,
    // required this.artist,
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
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    print("🔥 Raw Firebase Data: $json");

    EventModel event = EventModel(
      ageLimit: json['ageLimit'] ?? '',
      arrangement: json['arrangement'] ?? '',
      artists: (json['artists'] as List?)?.map((e) => Artist.fromJson(e)).toList() ?? [], // ✅ Fix applied here


      // artist: json['artist'] ?? {},
      // artist1: (json['artist1'] as List?)
      //     ?.map((e) => Artist.fromJson(e))
      //     .toList() ?? [],
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
      venue: _parseVenue(json['venue']),
    );

    print("✅ Parsed Venue Coordinates: ${event.venue.latitude}, ${event.venue
        .longitude}");
    return event;
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {
      'ageLimit': ageLimit,
      'arrangement': arrangement,
      // 'artist': {
      //   'artist1': artist1.map((e) => e.toJson()).toList(),
      // },
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
    };

    print(
        "📤 EventModel converted to JSON: $data"); // Logs converted data before saving
    return data;
  }

  String getDay() {
    List<String> parts = eventDate.split(" ");
    return parts.isNotEmpty ? parts[0] : "--"; // Extracts "23"
  }

  /// **Extracts the Month (e.g., "Mar") from "23 Mar 2025"**
  String getMonth() {
    List<String> parts = eventDate.split(" ");
    return parts.length > 1 ? parts[1] : "--"; // Extracts "Mar"
  }

  int getStartingPrice() {
    if (ticketTypes.isEmpty) return 0;
    return ticketTypes.values.map((e) => e.price).reduce((a, b) => a < b ? a : b);
  }



  static LatLng _parseVenue(dynamic venue) {
    print("📍 Raw Venue Data: $venue");

    if (venue is GeoPoint) {
      print(
          "✅ Venue parsed as GeoPoint: ${venue.latitude}, ${venue.longitude}");
      return LatLng(venue.latitude, venue.longitude);
    } else if (venue is List && venue.length == 2) {
      print("✅ Venue parsed as List: ${venue[0]}, ${venue[1]}");
      return LatLng(venue[0], venue[1]);
    } else if (venue is String) {
      // Handle string format like "21.15534° N, 72.76881° E"
      List<String> coords = venue.replaceAll(RegExp(r'[^\d.,-]'), '').split(
          ',');
      if (coords.length == 2) {
        double? lat = double.tryParse(coords[0]);
        double? lng = double.tryParse(coords[1]);
        if (lat != null && lng != null) {
          print("✅ Venue parsed from String: $lat, $lng");
          return LatLng(lat, lng);
        }
      }
    }

    print("❌ Venue parsing failed, returning (0.0, 0.0)");
    return LatLng(0.0, 0.0);
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


//   class Artist {
//   final String imageUrl;
//   final String name;
//
//   Artist({required this.imageUrl, required this.name});
//
//   factory Artist.fromJson(dynamic json) {
//     print("🎭 Artist Data: $json");
//     return Artist(
//       imageUrl: json[0] ?? '',
//       name: json[1] ?? '',
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'imageUrl': imageUrl,
//       'name': name,
//     };
//   }
// }

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
