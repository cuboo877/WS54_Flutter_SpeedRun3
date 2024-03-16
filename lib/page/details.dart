import 'package:flutter/material.dart';
import 'package:ws54_flutter_speedrun3/constant/style_guide.dart';
import 'package:ws54_flutter_speedrun3/page/home.dart';
import 'package:ws54_flutter_speedrun3/service/Auth.dart';
import 'package:ws54_flutter_speedrun3/service/data_model.dart';
import 'package:ws54_flutter_speedrun3/service/utilities.dart';
import 'package:ws54_flutter_speedrun3/widget/text_button.dart';

class DetailsPage extends StatefulWidget {
  const DetailsPage({super.key, required this.account, required this.password});

  final String account;
  final String password;
  @override
  State<StatefulWidget> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  late TextEditingController username_controller;
  late TextEditingController birthday_controller;

  bool isNameValid = false;
  bool isBirthdayValid = false;
  @override
  void initState() {
    super.initState();
    username_controller = TextEditingController();
    birthday_controller = TextEditingController();
  }

  @override
  void dispose() {
    username_controller.dispose();
    birthday_controller.dispose();
    super.dispose();
  }

  UserData packUserData() {
    return UserData(Utilities.randomID(), username_controller.text,
        widget.account, widget.password, birthday_controller.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: topbar(),
      ),
      body: SingleChildScrollView(
          child: SizedBox(
        width: double.infinity,
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          const SizedBox(height: 20),
          const Text("使用者名稱"),
          usernameTextForm(),
          const SizedBox(height: 20),
          const Text("生日"),
          birthdayTextForm(),
          const SizedBox(height: 20),
          startButton()
        ]),
      )),
    );
  }

  Widget startButton() {
    return AppTextButton.rectangleTextButton(AppColor.black, "開始使用", 30,
        () async {
      if (isBirthdayValid && isNameValid) {
        UserData userData = packUserData();
        await Auth.registerAuth(userData);
        print("registed. ${userData.username}");
        if (mounted) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => HomePage(userID: userData.id)));
        }
      } else {
        Utilities.showSnackBar(context, "請確認輸入資料", 2);
      }
    });
  }

  Widget usernameTextForm() {
    return SizedBox(
      width: 320,
      child: TextFormField(
        controller: username_controller,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            isNameValid = false;
            return "請輸入密碼";
          } else {
            isNameValid = true;
            return null;
          }
        },
        decoration: InputDecoration(
            prefixIcon: const Icon(Icons.person),
            hintText: "Name",
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(45),
                borderSide:
                    const BorderSide(color: AppColor.lightgrey, width: 1.5))),
      ),
    );
  }

  Widget birthdayTextForm() {
    return SizedBox(
      width: 320,
      child: TextFormField(
        readOnly: true,
        controller: birthday_controller,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        onTap: () async {
          DateTime? _picked = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2026));
          if (_picked != null) {
            birthday_controller.text = _picked.toString().split(" ")[0];
            isBirthdayValid = true;
          } else {
            isBirthdayValid = true;
          }
        },
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            isBirthdayValid = false;
            return "請輸入生日";
          } else {
            isBirthdayValid = true;
            return null;
          }
        },
        decoration: InputDecoration(
            prefixIcon: const Icon(Icons.calendar_month),
            hintText: "Name",
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(45),
                borderSide:
                    const BorderSide(color: AppColor.lightgrey, width: 1.5))),
      ),
    );
  }

  Widget topbar() {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: const Text("即將完成註冊"),
      backgroundColor: AppColor.black,
    );
  }
}
