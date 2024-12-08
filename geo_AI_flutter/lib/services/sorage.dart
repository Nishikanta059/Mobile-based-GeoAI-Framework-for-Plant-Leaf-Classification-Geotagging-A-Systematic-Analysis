import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String>? uploadPic(XFile pic) async {
    print("---upload pic start---");
    String lurl = "";

    print("----------inside upload pic-----");
    try {
      Reference reference =
          _storage.ref().child("leaves" + "/" + DateTime.now().toString());

      await reference
          .putData(
        await pic.readAsBytes(),
      )
          .whenComplete(() async {
        await reference.getDownloadURL().then((value) {
          lurl = value;
          print(value);
        });
      });
      print("----------upload done-----");
    } catch (e) {
      // print("---error occured uploadpic---");
      print(e);
    }

    return lurl;
  }

  // Future<String>? uploadPicDatasetSample(XFile pic) async {
  //   print("---upload pic start---");
  //   String lurl = "";
  //
  //   print("----------inside upload pic-----");
  //   try {
  //     Reference reference = _storage
  //         .ref()
  //         .child("flaviaDatasetSample" + "/" + DateTime.now().toString());
  //
  //     await reference
  //         .putData(
  //       await pic.readAsBytes(),
  //       SettableMetadata(contentType: 'image/jpeg'),
  //     )
  //         .whenComplete(() async {
  //       await reference.getDownloadURL().then((value) {
  //         lurl = value;
  //         print(value);
  //       });
  //     });
  //     print("----------upload done-----");
  //   } catch (e) {
  //     // print("---error occured uploadpic---");
  //     print(e);
  //   }
  //
  //   return lurl;
  // }
}
