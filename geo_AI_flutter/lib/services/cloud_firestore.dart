import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drdo_public/globalValue.dart';
import 'package:drdo_public/model/datasetSample.dart';
import 'package:drdo_public/model/leaf.dart';
import 'package:drdo_public/model/leaf_map_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class FireStoreService {
  final String? uid;

  FireStoreService({this.uid});

  final CollectionReference lfCollection =
      FirebaseFirestore.instance.collection('leaves');
  final CollectionReference sampleDatasetCollection =
      FirebaseFirestore.instance.collection('flaviaSampleDataset');

  final CollectionReference urlCollection =
      FirebaseFirestore.instance.collection('apiLinks');

  final DocumentReference statsDoc =
      FirebaseFirestore.instance.collection('stats').doc('statDoc');

  Future addLeafDoc({required Leaf l}) async {
    print('insie the addDoc');
    // print(uid);

    try {
      return await lfCollection.add({
        'image': l.img,
        'time': l.time,
        'loc': GeoPoint(l.loc.latitude!, l.loc.longitude!),
        'name': l.name,
        'isProcessed': false,
      }).then((value) async {
        await lfCollection.doc(value.id).update({"id": value.id.toString()});
        await statsDoc.update({'totalRequest': FieldValue.increment(1)});

        isNewDoc = true;
        currentDocId = value.id.toString();

        print(value.id.toString());
      });
    } catch (e) {
      print("error in DocUpdate");
      print(e.toString());
    }
  }

  Future updateUrl({required String url}) async {
    print('insie the addDoc');
    // print(uid);

    try {
      return await urlCollection.doc('mlLocalHost').update({'link': url});
    } catch (e) {
      print("error in DocUpdate");
      print(e.toString());
    }
  }

  Future<List<LeafMapPoints>> getLeafMapPoints() async {
    List<LeafMapPoints>? leafPointList =
        List<LeafMapPoints>.empty(growable: true);

    try {
      QuerySnapshot querySnapshot;
      print('insie getLeafMapPoints INfo');

      querySnapshot = await lfCollection
          .where("isProcessed", isEqualTo: true)
          .orderBy("time")
          .get();
      print('hi1');
      print(querySnapshot.size);

      final allDta = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;
        GeoPoint temp = data['loc'];

        LeafMapPoints lf = LeafMapPoints(
            location: LatLng(temp.latitude, temp.longitude),
            id: data['id'],
            maskedimgUrl: data['maskedImage'],
            time: data['time'],
            className: data['className'] ?? " ");

        leafPointList.add(lf);
      }).toList();
      print('insie the get leaf data info');
      print(leafPointList.length);
    } catch (e) {
      print('error in  getleafmappoints');
      print(e.toString());
    }

    return leafPointList;
  }

  Future<List<DatasetSample>> getTopThreePred(List<int> ids) async {
    List<DatasetSample>? predList = List<DatasetSample>.empty(growable: true);

    try {
      QuerySnapshot querySnapshot;
      print('insie getSmaplePoints INfo');
      // print(ids);

      for (var e in ids) {
        // print(e);
        querySnapshot =
            await sampleDatasetCollection.where("classId", isEqualTo: e).get();

        Map<String, dynamic> data =
            await querySnapshot.docs.first.data()! as Map<String, dynamic>;

        // print(data.toString());

        predList.add(DatasetSample(
            className: data['className'],
            classId: data['classId'],
            imgLink: data['image']));
      }

      print('insie the get pred data info');
      print(predList.length);
    } catch (e) {
      print('error in  getleafmappoints');
      print(e.toString());
    }

    return predList;
  }

  // Future addSampleDatasetDoc(
  //     {required String imgLink,
  //     required String className,
  //     required int classId}) async {
  //   print('insie the addDoc');
  //   // print(uid);
  //
  //   try {
  //     return await sampleDatasetCollection.add({
  //       'image': imgLink,
  //       'className': className,
  //       'classId': classId,
  //     }).then((value) async {
  //       await sampleDatasetCollection
  //           .doc(value.id)
  //           .update({"id": value.id.toString()});
  //
  //       isNewDoc = true;
  //       currentDocId = value.id.toString();
  //
  //       print(value.id.toString());
  //     });
  //   } catch (e) {
  //     print("error in DocUpdate sample dataset");
  //     print(e.toString());
  //   }
  // }
}
