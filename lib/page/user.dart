import 'package:flutter/material.dart';
import 'package:ws54_flutter_speedrun3/page/home.dart';
import 'package:ws54_flutter_speedrun3/page/login.dart';
import 'package:ws54_flutter_speedrun3/service/Auth.dart';
import 'package:ws54_flutter_speedrun3/service/sharedPref.dart';
import 'package:ws54_flutter_speedrun3/service/sql_sevice.dart';
import 'package:ws54_flutter_speedrun3/widget/text_button.dart';

import '../constant/style_guide.dart';
import '../service/data_model.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key, required this.userID});
  final String userID;
  @override
  State<StatefulWidget> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  late TextEditingController account_controller;
  late TextEditingController password_controller;
  late TextEditingController username_controller;
  late TextEditingController birthday_controller;
  bool isAccountValid = false;
  bool isPasswordValid = false;
  bool isNameValid = false;
  bool isBirthdayValid = false;

  bool isEdited = false;

  UserData userData = UserData("", "", "", "", "");
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getCurrentUserData();
      print('get new user data :${userData.id}');
    });
    super.initState();
    account_controller = TextEditingController(text: userData.account);
    password_controller = TextEditingController(text: userData.password);
    username_controller = TextEditingController(text: userData.username);
    birthday_controller = TextEditingController(text: userData.birthday);
  }

  @override
  void dispose() {
    account_controller.dispose();
    password_controller.dispose();
    username_controller.dispose();
    birthday_controller.dispose();
    super.dispose();
  }

  void getCurrentUserData() async {
    String userID = await SharedPref.getLoggedUserID();
    UserData data = await UserDAO.getUserDataByUserID(userID);
    setState(() {
      account_controller.text = data.account;
      password_controller.text = data.password;
      username_controller.text = data.username;
      birthday_controller.text = data.birthday;
    });
  }

  UserData packUserData() {
    return UserData(
        widget.userID,
        username_controller.text,
        account_controller.text,
        password_controller.text,
        birthday_controller.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: topbar(),
        ),
        body: SizedBox(
          width: double.infinity,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            const SizedBox(height: 20),
            const Text("使用者名稱"),
            usernameTextForm(),
            const SizedBox(height: 20),
            const Text("帳號"),
            accountTextForm(),
            const SizedBox(height: 20),
            const Text("密碼"),
            passwordTextForm(),
            const SizedBox(height: 20),
            const Text("生日"),
            birthdayTextForm(),
            const SizedBox(height: 20),
            submitButton(),
            const SizedBox(height: 20),
            logOutButton()
          ]),
        ));
  }

  Widget submitButton() {
    return AppTextButton.rectangleTextButton(AppColor.black, "編輯完成", 30,
        () async {
      await UserDAO.updateUserData(packUserData());
      if (mounted) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => HomePage(userID: widget.userID)));
      }
    });
  }

  Widget accountTextForm() {
    return SizedBox(
      width: 320,
      child: TextFormField(
        controller: account_controller,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        onChanged: (value) => setState(() {
          isEdited = true;
        }),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            isAccountValid = false;
            return "請輸入帳號";
          } else if (!RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$")
              .hasMatch(value)) {
            isAccountValid = false;
            return "請輸入正確的帳號格式";
          } else {
            isAccountValid = true;
            return null;
          }
        },
        decoration: InputDecoration(
            prefixIcon: const Icon(Icons.email),
            hintText: "Email",
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(45),
                borderSide:
                    const BorderSide(color: AppColor.lightgrey, width: 1.5))),
      ),
    );
  }

  bool obscure = true;
  Widget passwordTextForm() {
    return SizedBox(
      width: 320,
      child: TextFormField(
        obscureText: obscure,
        controller: password_controller,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        onChanged: (value) => setState(() {
          isEdited = true;
        }),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            isPasswordValid = false;
            return "請輸入密碼";
          } else {
            isPasswordValid = true;
            return null;
          }
        },
        decoration: InputDecoration(
            prefixIcon: const Icon(Icons.key),
            suffixIcon: IconButton(
                onPressed: () => setState(() {
                      obscure = !obscure;
                    }),
                icon: obscure
                    ? const Icon(Icons.visibility_off)
                    : const Icon(Icons.visibility)),
            hintText: "Password",
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(45),
                borderSide:
                    const BorderSide(color: AppColor.lightgrey, width: 1.5))),
      ),
    );
  }

  Widget usernameTextForm() {
    return SizedBox(
      width: 320,
      child: TextFormField(
        controller: username_controller,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        onChanged: (value) => setState(() {
          isEdited = true;
        }),
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
        onChanged: (value) => setState(() {
          isEdited = true;
        }),
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

  Widget logOutButton() {
    return AppTextButton.rectangleTextButton(AppColor.red, "登出", 30, () async {
      await Auth.logOut();
      if (mounted) {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const LoginPage()));
      }
    });
  }

  Widget topbar() {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          if (isEdited) {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text("確定要回到主頁面嗎?"),
                    actions: [
                      AppTextButton.rectangleTextButton(
                          AppColor.green, "儲存編輯", 18, () async {
                        await UserDAO.updateUserData(packUserData());
                        if (mounted) {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) =>
                                      HomePage(userID: userData.id)));
                        }
                      }),
                      AppTextButton.rectangleTextButton(
                          AppColor.darkBlue, "繼續編輯", 18, () {
                        Navigator.of(context).pop();
                      }),
                      AppTextButton.rectangleTextButton(
                          AppColor.red, "放棄編輯", 18, () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) =>
                                HomePage(userID: userData.id)));
                      }),
                    ],
                    actionsAlignment: MainAxisAlignment.center,
                  );
                });
          } else {
            Navigator.of(context).pop();
          }
        },
      ),
      title: const Text("編輯用戶資料"),
      backgroundColor: AppColor.black,
    );
  }
}
