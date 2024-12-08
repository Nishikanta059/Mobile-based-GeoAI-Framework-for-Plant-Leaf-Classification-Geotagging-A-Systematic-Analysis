// import 'dart:io';
// import 'dart:math' as math;
// import 'dart:ui';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
//
// class TakePics extends StatefulWidget {
//   const TakePics({key}) : super(key: key);
//   @override
//   _TakePicsState createState() => _TakePicsState();
// }
//
// class _TakePicsState extends State<TakePics> {
//   bool _isPicked = false;
//   bool _isCameraChosen = true;
//   late File _file;
//   @override
//   Widget build(BuildContext context) {
//     return BackdropFilter(
//       filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
//       child: Scaffold(
//         backgroundColor: Colors.black54,
//         body: Stack(
//           children: [
//             Center(
//               child: Wrap(children: [
//                 ClipRRect(
//                   borderRadius: BorderRadius.circular(20),
//                   child: Container(
//                     decoration: BoxDecoration(color: Colors.white54),
//                     child: Column(
//                       children: [
//                         _isPicked
//                             ? Image.file(_file) ?? SizedBox.shrink()
//                             : SizedBox.shrink(),
//                         //todo: web-upadte it to bytes
//                         !_isPicked
//                             ? Row(
//                                 mainAxisSize: MainAxisSize.min,
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceAround,
//                                 children: [
//                                   Padding(
//                                     padding:
//                                         const EdgeInsets.fromLTRB(10, 8, 8, 8),
//                                     child: IconButton(
//                                         icon: Icon(
//                                             Icons.add_photo_alternate_outlined),
//                                         onPressed: () {
//                                           _imageFromGalary();
//                                         }),
//                                   ),
//                                   Padding(
//                                     padding:
//                                         const EdgeInsets.fromLTRB(8, 8, 10, 8),
//                                     child: IconButton(
//                                         icon: Transform(
//                                           child:
//                                               Icon(Icons.add_a_photo_outlined),
//                                           alignment: Alignment.center,
//                                           transform: Matrix4.rotationY(math.pi),
//                                         ),
//                                         onPressed: () {
//                                           _imageFromCamera();
//                                         }),
//                                   ),
//                                 ],
//                               )
//                             : Row(
//                                 mainAxisSize: MainAxisSize.max,
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceAround,
//                                 children: [
//                                   Padding(
//                                       padding: const EdgeInsets.fromLTRB(
//                                           10, 8, 8, 8),
//                                       child: TextButton.icon(
//                                           style: ButtonStyle(
//                                             foregroundColor:
//                                                 MaterialStateProperty.all<
//                                                     Color>(Colors.black),
//                                           ),
//                                           onPressed: () {
//                                             _isCameraChosen
//                                                 ? _imageFromCamera()
//                                                 : _imageFromGalary();
//                                           },
//                                           icon: Icon(Icons.refresh_outlined),
//                                           label: Text("retake"))),
//                                   Padding(
//                                     padding:
//                                         const EdgeInsets.fromLTRB(8, 8, 10, 8),
//                                     child: Padding(
//                                         padding: const EdgeInsets.fromLTRB(
//                                             10, 8, 8, 8),
//                                         child: TextButton.icon(
//                                             style: ButtonStyle(
//                                               foregroundColor:
//                                                   MaterialStateProperty.all(
//                                                       Colors.black),
//                                             ),
//                                             onPressed: () async {
//                                               Navigator.of(context)
//                                                   .push(PageRouteBuilder(
//                                                 pageBuilder: (context, _, __) =>
//                                                     LoadingScreen(
//                                                   label: " uploading ",
//                                                 ),
//                                                 opaque: false,
//                                               ));
//                                               await StorageService()
//                                                   .uploadPic(TobeUploadPic(
//                                                 isEdited: false,
//                                                 isStudent: true,
//                                                 isVerified: false,
//                                                 pic: _file,
//                                                 universityId:
//                                                     "basicSciensetest1",
//                                                 uploadTime: DateTime.now(),
//                                                 uploaderId: "testuserid1",
//                                                 //todo: chnage it to proper user id using provider
//                                               ));
//                                               Navigator.pop(context);
//                                               Navigator.pop(context);
//                                             },
//                                             icon: Icon(
//                                                 Icons.cloud_upload_outlined),
//                                             label: Text("upload"))),
//                                   ),
//                                 ],
//                               ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ]),
//             ),
//             Align(
//                 alignment: Alignment.topLeft,
//                 child: Padding(
//                   padding: const EdgeInsets.fromLTRB(8, 25, 8, 8),
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.circular(15),
//                     child: Container(
//                       color: Colors.white54,
//                       child: IconButton(
//                         icon: Icon(Icons.clear_outlined),
//                         onPressed: () {
//                           Navigator.pop(context);
//                         },
//                         color: Colors.black,
//                       ),
//                     ),
//                   ),
//                 ))
//           ],
//         ),
//       ),
//     );
//   }
//
//   void _imageFromCamera() async {
//     final _picker = ImagePicker();
//     final pickedFile = await _picker.getImage(source: ImageSource.camera);
//
//     setState(() {
//       _file = File(pickedFile.path);
//       _isPicked = true;
//       _isCameraChosen = true;
//     });
//   }
//
//   void _imageFromGalary() async {
//     final _picker = ImagePicker();
//     final pickedFile = await _picker.getImage(source: ImageSource.gallery);
//
//     setState(() {
//       _file = File(pickedFile.path);
//       _isPicked = true;
//       _isCameraChosen = false;
//     });
//   }
// }
