import 'package:flutter/material.dart';
import 'package:ws54_flutter_speedrun3/page/login.dart';

import '../constant/style_guide.dart';
import '../service/Auth.dart';
import '../service/data_model.dart';
import '../service/utilities.dart';
import '../widget/text_button.dart';
import 'details.dart';
import 'home.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<StatefulWidget> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late TextEditingController account_controller;
  late TextEditingController password_controller;
  late TextEditingController confirm_controller;
  bool isAccountValid = false;
  bool isPasswordValid = false;
  bool isConfirmValid = false;

  @override
  void initState() {
    super.initState();
    account_controller = TextEditingController();
    password_controller = TextEditingController();
    confirm_controller = TextEditingController();
  }

  @override
  void dispose() {
    account_controller.dispose();
    password_controller.dispose();
    confirm_controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                const Text("54屆 分區技能競賽", style: TextStyle(fontSize: 30)),
                const Text("註冊", style: TextStyle(fontSize: 20)),
                const SizedBox(height: 20),
                const Text("帳號", style: TextStyle(fontSize: 20)),
                const SizedBox(height: 20),
                accountTextForm(),
                const SizedBox(height: 20),
                const Text("密碼", style: TextStyle(fontSize: 20)),
                const SizedBox(height: 20),
                passwordTextForm(),
                const SizedBox(height: 20),
                confirmTextForm(),
                const SizedBox(height: 20),
                registerButton(),
                const SizedBox(height: 20),
                registerToLoginTextColumn()
              ],
            )),
      ),
    );
  }

  Widget registerToLoginTextColumn() {
    return Column(
      children: [
        const Text(
          "已經擁有帳號??",
          style: TextStyle(fontSize: 20),
        ),
        InkWell(
          child: const Text(
            "登入",
            style: TextStyle(fontSize: 40, color: AppColor.darkBlue),
          ),
          onTap: () => Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => const LoginPage())),
        )
      ],
    );
  }

  Widget registerButton() {
    return AppTextButton.rectangleTextButton(AppColor.black, "註冊", 20,
        () async {
      if (isAccountValid && isPasswordValid && isConfirmValid) {
        bool result =
            await Auth.hasAccountBeenRegistered(account_controller.text);
        if (result == false) {
          if (mounted) {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => DetailsPage(
                      account: account_controller.text,
                      password: password_controller.text,
                    )));
          }
        } else {
          if (mounted) {
            Utilities.showSnackBar(context, "此帳號已註冊", 2);
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const LoginPage()));
          }
        }
      } else {
        print("$isAccountValid $isPasswordValid $isConfirmValid");
        Utilities.showSnackBar(context, "請確認您的輸入資料格式", 2);
      }
    });
  }

  //FIXME
  Widget accountTextForm() {
    return SizedBox(
      width: 320,
      child: TextFormField(
        controller: account_controller,
        autovalidateMode: AutovalidateMode.onUserInteraction,
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

  bool obscure2 = true;
  Widget confirmTextForm() {
    return SizedBox(
      width: 320,
      child: TextFormField(
        obscureText: obscure2,
        controller: confirm_controller,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          if (value != password_controller.text.trim()) {
            isConfirmValid = false;
            return "請重新確認密碼!";
          } else if (value == null || value.trim().isEmpty) {
            isConfirmValid = false;
            return "請輸入密碼";
          } else {
            isConfirmValid = true;
            return null;
          }
        },
        decoration: InputDecoration(
            prefixIcon: const Icon(Icons.key),
            suffixIcon: IconButton(
                onPressed: () => setState(() {
                      obscure2 = !obscure2;
                    }),
                icon: obscure2
                    ? const Icon(Icons.visibility_off)
                    : const Icon(Icons.visibility)),
            hintText: "Confirm Password",
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(45),
                borderSide:
                    const BorderSide(color: AppColor.lightgrey, width: 1.5))),
      ),
    );
  }
}
