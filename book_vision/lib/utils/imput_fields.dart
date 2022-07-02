// ignore_for_file: prefer_const_constructors

import 'package:book_vision/utils/colors.dart';
import 'package:flutter/material.dart';

class InputFields {
  static Widget inputField(
    String name,
    String hintName,
    TextInputType textInputType,
    TextEditingController myController,
    String initialText,
  ) {
    if (myController.text == "") {
      myController.text = initialText;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // ignore: prefer_const_constructors
        Text(
          name,
          style: TextStyle(
            color: Colors.black,
            fontSize: 15,
          ),
        ),
        const SizedBox(
          height: 3,
        ),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: ColorsUtils.lightPurple,
            borderRadius: BorderRadius.circular(100.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6.0,
                offset: Offset(0, 2),
              ),
            ],
          ),
          height: 40.0,
          child: TextField(
            controller: myController,
            keyboardType: textInputType,
            style: TextStyle(
              color: Colors.black,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(
                top: -6,
                left: 15,
              ),
              hintText: hintName,
              hintStyle: TextStyle(
                color: Colors.grey,
                fontSize: 15,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
