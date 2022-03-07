import 'package:elite_fm2/utils/constants.dart';
import 'package:flutter/material.dart';

Widget mainTitle(
  String titleText,
  double length,
) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        titleText,
        style: TextStyle(
          color: whiteColor,
          fontSize: 30,
        ),
      ),
      SizedBox(
        width: length,
        child: Divider(
          thickness: 4,
          color: redColor,
          // indent: 30,
          // endIndent: 90,
        ),
      ),
    ],
  );
}
