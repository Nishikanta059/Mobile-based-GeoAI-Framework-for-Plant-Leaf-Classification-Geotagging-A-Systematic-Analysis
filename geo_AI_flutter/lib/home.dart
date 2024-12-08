import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drdo_public/enterName.dart';
import 'package:drdo_public/globalValue.dart';
import 'package:drdo_public/leafDetails.dart';
import 'package:drdo_public/model/leaf.dart';
import 'package:drdo_public/model/leaf_map_points.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'services/cloud_firestore.dart';
import 'services/sorage.dart';
import 'shared/enterUrl.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool flag = false;
  bool isSelected = false;
  final ImagePicker imagePicker = ImagePicker();
  XFile? selectedImage;
  LatLng loc2 = const LatLng(0.0, 0.0);
  var loc;

  String selectedImageString = "";

  static const LatLng _kMapCenter =
      LatLng(19.018255973653343, 72.84793849278007);

  final CameraPosition _kInitialPosition = const CameraPosition(
      target: _kMapCenter, zoom: 11.0, tilt: 0, bearing: 0);
  List<Marker> _markers = <Marker>[];
  List<Marker> updatedMarkers = [];
  // List<Markers> markers; //This t

  List<LeafMapPoints> lflist = [];

  Future _initLocationService() async {
    var location = Location();

    try {
      var serviceEnabled = await location.serviceEnabled();
    } on PlatformException catch (err) {
      // _serviceEnabled = false;

      // location service is still not created

      _initLocationService(); // re-invoke himself every time the error is catch, so until the location service setup is complete
    }

    if (!await location.serviceEnabled()) {
      if (!await location.requestService()) {
        return;
      }
    }

    var permission = await location.hasPermission();
    if (permission == PermissionStatus.denied) {
      permission = await location.requestPermission();
      if (permission != PermissionStatus.granted) {
        return;
      }
    }

    loc = await location.getLocation();
    flag = true;
    setState(() {});
    loc2 = LatLng(loc.latitude, loc.longitude);

    final prefs = await SharedPreferences.getInstance();

    final String? nameVal = prefs.getString('name');

    if (nameVal == null) {
      name = "";
    } else {
      name = nameVal;
    }
  }

  @override
  void initState() {
    super.initState();
    _initLocationService();
  }

  void getMapPins() async {
    FireStoreService fireStoreService = FireStoreService();

    lflist = await fireStoreService.getLeafMapPoints();
    // final Uint8List markerIcon = await getBytesFromAsset("assets/images/waste-bin.png");
    // final Uint8List markerIcon2 = await getBytesFromAsset("assets/images/garbage-truck.png");
    updatedMarkers = [];
    lflist.forEach((lf) async {
      ImageConfiguration configuration = const ImageConfiguration();
      updatedMarkers.add(Marker(
          markerId: MarkerId(lf.id),
          icon: await BitmapDescriptor.fromAssetImage(
              const ImageConfiguration(size: Size(12, 12)),
              "assets/icons8-oak-tree-48.png"),
          infoWindow: InfoWindow(
              title: "Tree data",
              snippet:
                  "Class Name : ${lf.className}  ,loc: [ ${lf.location.latitude}  ${lf.location.longitude}  ]"),
          position: lf.location));
    });

    _markers = updatedMarkers;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    FireStoreService fireStoreService = FireStoreService();
    StorageService storageService = StorageService();

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    // print();

    var leafDocStream = FirebaseFirestore.instance
        .collection('leaves')
        .doc(currentDocId)
        .snapshots();

    var dlServerStatusStream = FirebaseFirestore.instance
        .collection('apiLinks')
        .doc('mlLocalHost')
        .snapshots();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            title: const Text(
              'Leaf Geo AI',
              style: TextStyle(color: Colors.green),
            ),
            backgroundColor: Colors.black,
            actions: [
              GestureDetector(
                child: Icon(Icons.settings),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return EnterUrl();
                  }));
                },
              )
            ],
            bottom: const TabBar(
              tabs: [
                Tab(
                  child: Text(
                    'Identify leaf',
                    style: TextStyle(color: Colors.greenAccent),
                  ),
                ),
                Tab(
                  child: Text(
                    'Tree Map',
                    style: TextStyle(color: Colors.greenAccent),
                  ),
                )
              ],
            ),
          ),
          body: TabBarView(
            children: [
              isNewDoc
                  ? StreamBuilder(
                      stream: leafDocStream,
                      builder:
                          (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                        var data;
                        var isProcessed = false;
                        if (snapshot.hasData) {
                          data = snapshot.data as DocumentSnapshot;
                          isProcessed = data['isProcessed'];
                        }
                        if (!isProcessed) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: height * 0.2,
                                  child: const LoadingIndicator(
                                      indicatorType:
                                          Indicator.ballScaleMultiple,

                                      /// Required, The loading type of the widget
                                      colors: [Colors.green],

                                      /// Optional, The color collections
                                      strokeWidth: 2,

                                      /// Optional, The stroke of the line, only applicable to widget which contains line
                                      // backgroundColor: Colors.grey,      /// Optional, Background of the widget
                                      pathBackgroundColor: Colors.blueAccent

                                      /// Optional, the stroke backgroundColor
                                      ),
                                ),
                                const Text(
                                    "Uploaded image is being Processed Please wait...\n\n"),
                                const Text("may take upto 2min"),
                              ],
                            ),
                          );
                        } else {
                          var arr = data['className'].toString();

                          return SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                LeafDetails(
                                  response: arr,
                                  maskedImage: data['maskedImage'],
                                ),
                                // Padding(
                                //   padding: const EdgeInsets.symmetric(
                                //       horizontal: 20.0, vertical: 10),
                                //   child: SizedBox(
                                //     height: height * 0.6,
                                //     width: width * 0.9,
                                //     child: Transform.rotate(
                                //         angle: math.pi / 2,
                                //         child: Image.network(
                                //           data['maskedImage'],
                                //           fit: BoxFit.cover,
                                //           loadingBuilder: (BuildContext context,
                                //               Widget child,
                                //               ImageChunkEvent?
                                //                   loadingProgress) {
                                //             if (loadingProgress == null)
                                //               return child;
                                //             return SizedBox(
                                //               height: height * 0.6,
                                //               width: width * 0.95,
                                //               child: Center(
                                //                 child:
                                //                     CircularProgressIndicator(
                                //                   value: loadingProgress
                                //                               .expectedTotalBytes !=
                                //                           null
                                //                       ? loadingProgress
                                //                               .cumulativeBytesLoaded /
                                //                           loadingProgress
                                //                               .expectedTotalBytes!
                                //                       : null,
                                //                 ),
                                //               ),
                                //             );
                                //           },
                                //         )),
                                //   ),
                                // ),
                                // Text(
                                //   "Class Name :" + data['className'].toString(),
                                //   style: const TextStyle(
                                //     fontSize: 20,
                                //   ),
                                // ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 50),
                                  child: TextButton(
                                      style: globalButtonStyle,
                                      onPressed: () {
                                        isNewDoc = false;
                                        setState(() {});
                                      },
                                      child: const Text(
                                        'Analyze another leaf',
                                      )),
                                ),
                              ],
                            ),
                          );
                        }
                      })
                  : (isSelected
                      ? SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(height: 50),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Center(
                                    child: SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.5,
                                        child: kIsWeb
                                            ? Image.network(selectedImage!.path)
                                            : Image.file(
                                                File(selectedImage!.path),
                                                fit: BoxFit.cover,
                                              )),
                                  ),
                                ],
                              ),

                              //todo change to x file
                              const SizedBox(
                                height: 60,
                              ),
                              TextButton(
                                  style: globalButtonStyle,
                                  onPressed: () async {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Processing...'),
                                      ),
                                    );
                                    selectedImageString = await storageService
                                        .uploadPic(selectedImage!)!;
                                    await fireStoreService.addLeafDoc(
                                        l: Leaf(
                                            img: selectedImageString,
                                            name: name,
                                            loc: loc!,
                                            time: Timestamp.fromDate(
                                                DateTime.now())));
                                    isSelected = false;
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('request sent'),
                                      ),
                                    );
                                    setState(() {});
                                  },
                                  child: const Text('analyze')),
                              const SizedBox(
                                height: 20,
                              ),
                              TextButton(
                                  style: globalButtonStyle,
                                  onPressed: () async {
                                    selectedImage = await imagePicker.pickImage(
                                        source: ImageSource.camera);
                                    // if (selectedImages!.isNotEmpty) {
                                    //   imageFileList!.addAll(selectedImages);
                                    // }
                                    isSelected = true;
                                    setState(() {});
                                  },
                                  child: const Text('retake')),
                            ],
                          ),
                        )
                      : StreamBuilder(
                          stream: dlServerStatusStream,
                          builder: (context,
                              AsyncSnapshot<DocumentSnapshot> snapshot) {
                            bool isActive = false;
                            if (snapshot.hasData) {
                              var data = snapshot.data as DocumentSnapshot;
                              isActive = data['isActive'];
                            }

                            return Center(
                                child: !isActive
                                    ? const Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "AI Server is offline",
                                          ),
                                          Text(
                                              "Please make it online to proceed.")
                                        ],
                                      )
                                    : Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              FloatingActionButton(
                                                focusColor: Colors.white,
                                                foregroundColor: Colors.green,
                                                backgroundColor: Colors.black,
                                                onPressed: () async {
                                                  if (name == "") {
                                                    await Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                const EnterName()));
                                                  }
                                                  selectedImage =
                                                      await imagePicker
                                                          .pickImage(
                                                              source:
                                                                  ImageSource
                                                                      .camera,
                                                              imageQuality: 90);

                                                  isSelected = true;
                                                  setState(() {});
                                                },
                                                child: const Icon(Icons.camera),
                                              ),
                                              const SizedBox(
                                                width: 20,
                                              ),
                                              FloatingActionButton(
                                                focusColor: Colors.white,
                                                foregroundColor: Colors.green,
                                                backgroundColor: Colors.black,
                                                onPressed: () async {
                                                  if (name == "") {
                                                    await Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                const EnterName()));
                                                  }
                                                  selectedImage =
                                                      await imagePicker
                                                          .pickImage(
                                                    source: ImageSource.gallery,
                                                  );

                                                  isSelected = true;
                                                  setState(() {});
                                                },
                                                child: const Icon(
                                                    Icons.file_upload),
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 30.0),
                                            child: loc != null
                                                ? Text(
                                                    "Location : [ ${loc.latitude}    ${loc.longitude} ]")
                                                : const SizedBox(),
                                          )
                                        ],
                                      ));
                          })),
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Container(
                    color: Colors.greenAccent,
                    width: width * 0.8,
                    height: height * 0.7,
                    child: GoogleMap(
                      initialCameraPosition: _kInitialPosition,
                      compassEnabled: true,
                      myLocationButtonEnabled: true,
                      myLocationEnabled: true,
                      markers: Set<Marker>.of(_markers),
                      onMapCreated: (GoogleMapController controller) async {
                        // _mapConroller.complete(controller);
                        getMapPins();
                        setState(() {});
                        controller.animateCamera(CameraUpdate.newCameraPosition(
                            CameraPosition(
                                bearing: 20.0, target: loc2, zoom: 15)));
                      },
                    ),
                  ),
                ),
              )
            ],
          )),
    );
  }
}
