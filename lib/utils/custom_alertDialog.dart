import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:newsweb/utils/appimage.dart';
import 'package:newsweb/utils/buttonborder.dart';

class CustomAlertDialog extends StatelessWidget {
  final String title;

  CustomAlertDialog(this.title);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      width: size.width / 2,
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            AppImages.welcomescreenillimage,
            width: 80,
            height: 80,
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            textAlign: TextAlign.center,
            title,
            style: TextStyle(fontSize: 15, color: Colors.black),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            width: double.infinity,
            child: ElevatedButton(
                style: TextButton.styleFrom(
                    backgroundColor: HexColor("#036eb7"),
                    shape: ButtonBorder()),
                onPressed: () 
                {
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: Text(
                    "Close",
                    style: TextStyle(color: Colors.white),
                  ),
                )),
          )
        ],
      ),
    );
  }
}
