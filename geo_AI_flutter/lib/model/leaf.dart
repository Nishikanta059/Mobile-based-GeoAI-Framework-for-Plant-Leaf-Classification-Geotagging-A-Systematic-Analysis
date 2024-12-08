import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location/location.dart';

class Leaf{

  String img;
  String name;
  LocationData loc;
  Timestamp time;
  bool isProcessed=false;

  Leaf({required this.name,required this.img,required this.loc,required this.time});
}