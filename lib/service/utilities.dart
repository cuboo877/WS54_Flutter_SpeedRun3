import 'dart:ffi';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ws54_flutter_speedrun3/constant/style_guide.dart';

class Utilities {
  static void showSnackBar(BuildContext context, String content, int seconds) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        content,
        style: const TextStyle(color: AppColor.white),
      ),
      backgroundColor: AppColor.black,
      duration: Duration(seconds: seconds),
    ));
  }

  static String randomID() {
    Random random = Random();
    String result = "";
    for (int i = 0; i < 9; i++) {
      result += random.nextInt(9).toString();
    }
    return result;
  }

  static String randomPassword(bool hasLowerCase, bool hasUpperCase,
      bool hasSymbol, bool hasNumber, String customChars, int length) {
    StringBuffer buffer = StringBuffer();
    int size = length - customChars.length;
    if (hasLowerCase) {
      buffer.write("abcdefghijklmnopqrstuvwxyz");
    }
    if (hasUpperCase) {
      buffer.write("ABCDEFGHIJKLMNOPQRSTUVWXYZ");
    }
    if (hasSymbol) {
      buffer.write("!@#%^*()_+{}[]?");
    }
    if (hasNumber) {
      buffer.write("0123456789");
    }
    Random random = Random();
    int insertIndex =
        random.nextInt(size - 1); // -1            !!!!!!!!!!!!!!!!!!!!!!!
    String bufferString = buffer.toString();
    String result = "";
    for (int i = 0; i < size; i++) {
      result += bufferString[random.nextInt(bufferString.length)];
    }
    String finalResult =
        "${result.substring(0, insertIndex)}$customChars${result.substring(insertIndex)}";
    return finalResult;
  }
}
