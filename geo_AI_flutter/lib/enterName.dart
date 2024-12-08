import 'package:drdo_public/globalValue.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EnterName extends StatefulWidget {
  const EnterName({Key? key}) : super(key: key);

  @override
  State<EnterName> createState() => _EnterNameState();
}

class _EnterNameState extends State<EnterName> {
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
                labelText: 'Name',
              ),
              onChanged: (val) {
                name = val;
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
            final prefs = await SharedPreferences.getInstance();

            await prefs.setString('name', name);
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
