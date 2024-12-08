import 'package:drdo_public/globalValue.dart';
import 'package:drdo_public/services/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EnterUrl extends StatefulWidget {
  const EnterUrl({Key? key}) : super(key: key);

  @override
  State<EnterUrl> createState() => _EnterUrlState();
}

String url = "";

class _EnterUrlState extends State<EnterUrl> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // backgroundColor: colorGrey,

        body: Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.4,
            child: TextField(
              decoration: InputDecoration(
                labelText: 'url',
              ),
              onChanged: (val) {
                url = val;
              },
            ),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.3,
        ),
        ElevatedButton(
          style: globalButtonStyle,
          onPressed: () async {
            FireStoreService fireStoreService = FireStoreService();
            await fireStoreService.updateUrl(url: url);

            Navigator.pop(context);
          },
          child: Text("save"),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.1,
        ),
      ],
    ));
  }
}
