import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:ws54_flutter_speedrun3/service/data_model.dart';
import 'package:ws54_flutter_speedrun3/service/sql_sevice.dart';
import 'package:ws54_flutter_speedrun3/service/utilities.dart';

import '../constant/style_guide.dart';
import '../widget/text_button.dart';
import 'home.dart';

class AddPasswordPage extends StatefulWidget {
  const AddPasswordPage({super.key, required this.userID});
  final String userID;
  @override
  State<StatefulWidget> createState() => _AddPasswordPageState();
}

class _AddPasswordPageState extends State<AddPasswordPage> {
  bool isEdited = false;
  late TextEditingController tag_controller;
  late TextEditingController url_controller;
  late TextEditingController login_controller;
  late TextEditingController password_controller;
  late TextEditingController customChars_controller;
  int isFav = 0;
  bool isTagValid = false;
  bool isUrlValid = false;
  bool isLoginValid = false;
  bool isPasswordValid = false;

  bool hasLowerCase = true;
  bool hasUpperCase = true;
  bool hasSymbol = true;
  bool hasNumber = true;
  String customChars = "";
  int length = 16;
  @override
  void initState() {
    super.initState();
    tag_controller = TextEditingController();
    url_controller = TextEditingController();
    login_controller = TextEditingController();
    password_controller = TextEditingController();
    customChars_controller = TextEditingController();
  }

  @override
  void dispose() {
    tag_controller.dispose();
    url_controller.dispose();
    login_controller.dispose();
    password_controller.dispose();
    customChars_controller.dispose();
    super.dispose();
  }

  PasswordData packPasswordData() {
    return PasswordData(
        Utilities.randomID(),
        widget.userID,
        tag_controller.text,
        url_controller.text,
        login_controller.text,
        password_controller.text,
        isFav);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60), child: topbar()),
      body: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            const SizedBox(height: 20),
            const Text("標籤"),
            tagTextForm(),
            const SizedBox(height: 20),
            const Text("網址"),
            urlTextForm(),
            const SizedBox(height: 20),
            const Text("登入帳號"),
            loginTextForm(),
            const SizedBox(height: 20),
            const Text("密碼"),
            passwordTextForm(),
            const SizedBox(height: 20),
            favButton(),
            const SizedBox(height: 20),
            randomPasswordSettingButton(),
            const SizedBox(height: 20),
            submitButton()
          ]),
        ),
      ),
    );
  }

  Widget randomPasswordSettingButton() {
    return AppTextButton.rectangleTextButton(AppColor.black, "隨機設定", 20,
        () async {
      showDialog(
          context: context,
          builder: (context) {
            return StatefulBuilder(builder: (context, setState) {
              return AlertDialog(
                title: const Text("隨機密碼設定"),
                content: Column(mainAxisSize: MainAxisSize.min, children: [
                  const Text("指定字元"),
                  TextFormField(
                    controller: customChars_controller,
                  ),
                  CheckboxListTile(
                      title: const Text("包含小寫字母"),
                      value: (hasLowerCase),
                      onChanged: (value) =>
                          setState(() => hasLowerCase = !hasLowerCase)),
                  CheckboxListTile(
                      title: const Text("包含大寫字母"),
                      value: (hasUpperCase),
                      onChanged: (value) =>
                          setState(() => hasUpperCase = !hasUpperCase)),
                  CheckboxListTile(
                      title: const Text("包含數字"),
                      value: (hasNumber),
                      onChanged: (value) =>
                          setState(() => hasNumber = !hasNumber)),
                  CheckboxListTile(
                      title: const Text("包含符號"),
                      value: (hasSymbol),
                      onChanged: (value) =>
                          setState(() => hasSymbol = !hasSymbol)),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Slider(
                          min: 1,
                          max: 20,
                          divisions: 19,
                          value: (length.toDouble()),
                          onChanged: (value) {
                            setState(() => length = value.toInt());
                          }),
                      Text(length.toString())
                    ],
                  )
                ]),
              );
            });
          });
    });
  }

  Widget submitButton() {
    return AppTextButton.rectangleTextButton(AppColor.black, "創建", 30,
        () async {
      if (isEdited) {
        print("$isLoginValid, $isPasswordValid,$isTagValid,$isUrlValid");
        if (isLoginValid && isPasswordValid && isTagValid && isUrlValid) {
          await PasswordDAO.addPasswordData(packPasswordData());
          print("add password data");
          if (mounted) {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => HomePage(userID: widget.userID)));
          }
        } else {
          print("input unvallid");
          Utilities.showSnackBar(context, "請檢查是否輸入正確格式", 2);
        }
      } else {
        Utilities.showSnackBar(context, "尚未輸入任何資料", 2);
      }
    });
  }

  Widget favButton() {
    return TextButton(
        style: TextButton.styleFrom(
            iconColor: isFav == 0 ? AppColor.red : AppColor.white,
            shape: const CircleBorder(),
            side: const BorderSide(color: AppColor.red, width: 2.0),
            backgroundColor: isFav == 0 ? AppColor.white : AppColor.red),
        onPressed: () {
          isEdited = true;
          setState(() {
            isFav = isFav == 0 ? 1 : 0;
          });
        },
        child: Icon(
          isFav == 0 ? Icons.favorite_border : Icons.favorite,
        ));
  }

  Widget tagTextForm() {
    return SizedBox(
      width: 320,
      child: TextFormField(
        controller: tag_controller,
        onChanged: (value) => setState(() {
          isEdited = true;
        }),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            isTagValid = false;
            return "請輸入";
          } else {
            isTagValid = true;
            return null;
          }
        },
        decoration: InputDecoration(
            prefixIcon: const Icon(Icons.tag),
            hintText: "tag",
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(45),
                borderSide:
                    const BorderSide(color: AppColor.lightgrey, width: 1.5))),
      ),
    );
  }

  Widget urlTextForm() {
    return SizedBox(
      width: 320,
      child: TextFormField(
        controller: url_controller,
        onChanged: (value) => setState(() {
          isEdited = true;
        }),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            isUrlValid = false;
            return "請輸入";
          } else {
            isUrlValid = true;
            return null;
          }
        },
        decoration: InputDecoration(
            prefixIcon: const Icon(Icons.tag),
            hintText: "url",
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(45),
                borderSide:
                    const BorderSide(color: AppColor.lightgrey, width: 1.5))),
      ),
    );
  }

  Widget loginTextForm() {
    return SizedBox(
      width: 320,
      child: TextFormField(
        controller: login_controller,
        onChanged: (value) => setState(() {
          isEdited = true;
        }),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            isLoginValid = false;
            return "請輸入";
          } else {
            isLoginValid = true;
            return null;
          }
        },
        decoration: InputDecoration(
            prefixIcon: const Icon(Icons.tag),
            hintText: "lgoin account",
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(45),
                borderSide:
                    const BorderSide(color: AppColor.lightgrey, width: 1.5))),
      ),
    );
  }

  bool obscure = false;
  Widget passwordTextForm() {
    return SizedBox(
      width: 320,
      child: TextFormField(
        obscureText: obscure,
        controller: password_controller,
        onChanged: (value) => setState(() {
          isEdited = true;
        }),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            isPasswordValid = false;
            return "請輸入";
          } else {
            isPasswordValid = true;
            return null;
          }
        },
        decoration: InputDecoration(
            prefixIcon: const Icon(Icons.key),
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                    onPressed: () => setState(() {
                          isEdited = true;
                          password_controller.text = Utilities.randomPassword(
                              hasLowerCase,
                              hasUpperCase,
                              hasSymbol,
                              hasNumber,
                              customChars_controller.text,
                              length);
                        }),
                    icon: const Icon(Icons.casino)),
                IconButton(
                    onPressed: () => setState(() {
                          obscure = !obscure;
                        }),
                    icon: obscure
                        ? const Icon(Icons.visibility_off)
                        : const Icon(Icons.visibility)),
              ],
            ),
            hintText: "password",
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(45),
                borderSide:
                    const BorderSide(color: AppColor.lightgrey, width: 1.5))),
      ),
    );
  }

  Widget topbar() {
    return AppBar(
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back,
          color: AppColor.black,
        ),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      title: const Text(
        "創建您的密碼",
        style: TextStyle(color: AppColor.black),
      ),
      backgroundColor: AppColor.white,
    );
  }
}
