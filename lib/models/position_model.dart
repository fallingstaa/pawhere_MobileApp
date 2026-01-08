import 'dart:convert';

/// A data model representing a single GPS position reported by a Traccar device.
class Position {
  /// The Traccar internal ID of the device that generated this position.
  /// This ID is used to link the position back to a Pet/Tracker.
  final int deviceId;

  /// The latitude coordinate.
  final double latitude;

  /// The longitude coordinate.
  final double longitude;

  /// Timestamp when the position was recorded by the device.
  final DateTime deviceTime;

  Position({
    required this.deviceId,
    required this.latitude,
    required this.longitude,
    required this.deviceTime,
  });

  /// Factory constructor to create a Position instance from a JSON map (e.g., from HTTP response).
  factory Position.fromJson(Map<String, dynamic> json) => Position(
        deviceId: json['deviceId'] ?? 0,
        latitude: (json['latitude'] ?? 0).toDouble(),
        longitude: (json['longitude'] ?? 0).toDouble(),
        deviceTime: DateTime.tryParse(json['deviceTime'] ?? '') ?? DateTime.now(),
      );
}