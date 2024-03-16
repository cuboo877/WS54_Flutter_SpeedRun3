import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constant/style_guide.dart';

class AppTextButton {
  static Widget rectangleTextButton(
      Color backgroundColor, String text, int textSize, onPressed) {
    return TextButton(
        style: TextButton.styleFrom(
            padding: const EdgeInsets.all(10),
            backgroundColor: backgroundColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(45))),
        onPressed: onPressed,
        child: Text(text,
            style: TextStyle(
                color: AppColor.white, fontSize: textSize.toDouble())));
  }
}
