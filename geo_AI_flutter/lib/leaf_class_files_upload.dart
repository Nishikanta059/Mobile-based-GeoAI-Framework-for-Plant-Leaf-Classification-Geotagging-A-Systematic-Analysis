// import 'dart:io';
//
// import 'package:drdo_public/globalValue.dart';
// import 'package:drdo_public/services/cloud_firestore.dart';
// import 'package:drdo_public/services/sorage.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/foundation.dart' show kIsWeb;
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:image_picker/image_picker.dart';
//
// class DatasetSampleUpload extends StatefulWidget {
//   const DatasetSampleUpload({Key? key}) : super(key: key);
//
//   @override
//   State<DatasetSampleUpload> createState() => _DatasetSampleUploadState();
// }
//
// class _DatasetSampleUploadState extends State<DatasetSampleUpload> {
//   String className = "";
//   int classId = 0;
//   bool flag = false;
//   bool isSelected = false;
//   final ImagePicker imagePicker = ImagePicker();
//   XFile? selectedImage;
//   @override
//   Widget build(BuildContext context) {
//     double height = MediaQuery.of(context).size.height;
//     double width = MediaQuery.of(context).size.width;
//
//     FireStoreService fireStoreService = FireStoreService();
//     StorageService storageService = StorageService();
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Load 1 image from each class'),
//       ),
//       body: SingleChildScrollView(
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 !isSelected
//                     ? SizedBox()
//                     : SizedBox(
//                         height: MediaQuery.of(context).size.height * 0.5,
//                         child: kIsWeb
//                             ? Image.network(selectedImage!.path)
//                             : Image.file(
//                                 File(selectedImage!.path),
//                                 fit: BoxFit.cover,
//                               )),
//                 FloatingActionButton(
//                   focusColor: Colors.white,
//                   foregroundColor: Colors.green,
//                   backgroundColor: Colors.black,
//                   onPressed: () async {
//                     selectedImage = await imagePicker.pickImage(
//                       source: ImageSource.gallery,
//                     );
//
//                     print("imageSlected");
//                     isSelected = true;
//                     setState(() {});
//                   },
//                   child: Icon(
//                       isSelected ? Icons.refresh_sharp : Icons.file_upload),
//                 ),
//                 SizedBox(
//                   width: width * 0.4,
//                   child: Padding(
//                     padding: const EdgeInsets.all(20.0),
//                     child: TextField(
//                       decoration: InputDecoration(
//                         contentPadding: EdgeInsets.all(20.0),
//                         labelText: "Class Name",
//                         fillColor: Colors.transparent,
//                         border: UnderlineInputBorder(
//                           borderRadius: BorderRadius.circular(25.0),
//                           borderSide: BorderSide(),
//                         ),
//                       ),
//                       keyboardType: TextInputType.emailAddress,
//                       onChanged: (val) {
//                         className = val;
//                       },
//                     ),
//                   ),
//                 ),
//                 SizedBox(
//                   width: width * 0.4,
//                   child: Padding(
//                     padding: const EdgeInsets.all(20.0),
//                     child: TextField(
//                       decoration: InputDecoration(
//                         contentPadding: EdgeInsets.all(20.0),
//                         labelText: "Class Id",
//                         fillColor: Colors.transparent,
//                         border: UnderlineInputBorder(
//                           borderRadius: BorderRadius.circular(25.0),
//                           borderSide: BorderSide(),
//                         ),
//                       ),
//                       keyboardType: TextInputType.number,
//                       onChanged: (val) {
//                         classId = int.parse(val.toString());
//                       },
//                     ),
//                   ),
//                 ),
//                 TextButton(
//                     style: globalButtonStyle,
//                     onPressed: () async {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(
//                           content: Text('Processing...'),
//                         ),
//                       );
//                       var selectedImageString = await storageService
//                           .uploadPicDatasetSample(selectedImage!)!;
//                       await fireStoreService.addSampleDatasetDoc(
//                           imgLink: selectedImageString,
//                           className: className,
//                           classId: classId);
//                       isSelected = false;
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(
//                           content: Text('request sent'),
//                         ),
//                       );
//                       setState(() {});
//                     },
//                     child: const Text('upload')),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
