import 'package:drdo_public/model/datasetSample.dart';
import 'package:drdo_public/services/cloud_firestore.dart';
import 'package:flutter/material.dart';

class LeafDetails extends StatefulWidget {
  String response;
  String maskedImage;
  LeafDetails({Key? key, required this.response, required this.maskedImage})
      : super(key: key);

  @override
  State<LeafDetails> createState() => _LeafDetailsState();
}

class _LeafDetailsState extends State<LeafDetails> {
  ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    FireStoreService fireStoreService = FireStoreService();

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    var _bannerHeight = height * 0.4;

    List z = widget.response.split("*");
    List<int> ids = List<int>.empty(growable: true);
    List<double> confidences = List<double>.empty(growable: true);
    z.removeLast();

    for (var i in z) {
      var t = i.split('-');

      var cId = int.tryParse(t[0]) ?? 0;

      var cd = double.tryParse(t[1]) ?? 0;
      ids.add(cId);
      confidences.add(cd);
    }

    return FutureBuilder(
        future: fireStoreService.getTopThreePred(ids),
        builder: (context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return Padding(
              padding: const EdgeInsets.all(40.0),
              child: Center(child: CircularProgressIndicator()),
            );
          } else {
            List<DatasetSample> preds = snapshot.data;
            return SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                      height: _bannerHeight,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.network(widget.maskedImage),
                      )),
                  Container(
                    height: height * 0.07,
                    color: Colors.black,
                    padding: EdgeInsets.all(10),
                    child: Text(
                      "Top Three Results",
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    alignment: Alignment.centerLeft,
                  ),
                  Container(
                      height: height * 0.9,
                      color: Colors.lightGreenAccent.shade100.withOpacity(0.2),
                      padding: EdgeInsets.all(16.0),
                      child: ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: preds.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Container(
                                  color: Colors.black12,
                                  child: ListTile(
                                      title: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          child: Image.network(
                                            preds[index].imgLink,
                                            fit: BoxFit.fitWidth,
                                            height: height * 0.2,
                                            width: width * 0.25,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: height * 0.02,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        // mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: width * 0.4,
                                            child: Text(
                                              preds[index].className.toString(),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          SizedBox(
                                            height: height * 0.03,
                                          ),
                                          Text(
                                              "confidence ${confidences[index].toStringAsFixed(3)!}"),
                                        ],
                                      ),
                                    ],
                                  )),
                                ),
                              ),
                            );
                          })),
                ],
              ),
            );
          }
        });
  }
}
