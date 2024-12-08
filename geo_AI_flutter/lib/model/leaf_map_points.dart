import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LeafMapPoints {
  LatLng location;

  String id;
  String maskedimgUrl;
  Timestamp time;
  String className;

  LeafMapPoints(
      {required this.id,
      required this.time,
      required this.location,
      required this.maskedimgUrl,
      required this.className});
}
