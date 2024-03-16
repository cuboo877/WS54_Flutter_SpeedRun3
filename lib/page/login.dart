import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ws54_flutter_speedrun3/constant/style_guide.dart';
import 'package:ws54_flutter_speedrun3/page/home.dart';
import 'package:ws54_flutter_speedrun3/page/register.dart';
import 'package:ws54_flutter_speedrun3/service/Auth.dart';
import 'package:ws54_flutter_speedrun3/service/data_model.dart';
import 'package:ws54_flutter_speedrun3/service/sql_sevice.dart';
import 'package:ws54_flutter_speedrun3/service/utilities.dart';
import 'package:ws54_flutter_speedrun3/widget/text_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late TextEditingController account_controller;
  late TextEditingController password_controller;
  bool isAccountValid = false;
  bool isPasswordValid = false;
  bool doAuthWarning = false;
  @override
  void initState() {
    super.initState();
    account_controller = TextEditingController();
    password_controller = TextEditingController();
  }

  @override
  void dispose() {
    account_controller.dispose();
    password_controller.dispose();
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
                const Text("登入", style: TextStyle(fontSize: 20)),
                const SizedBox(height: 20),
                const Text("帳號", style: TextStyle(fontSize: 20)),
                const SizedBox(height: 20),
                accountTextForm(),
                const SizedBox(height: 20),
                const Text("密碼", style: TextStyle(fontSize: 20)),
                const SizedBox(height: 20),
                passwordTextForm(),
                const SizedBox(height: 20),
                loginButton(),
                const SizedBox(height: 20),
                loginToRegisterTextColumn()
              ],
            )),
      ),
    );
  }

  Widget loginToRegisterTextColumn() {
    return Column(
      children: [
        const Text(
          "尚未擁有帳號?",
          style: TextStyle(fontSize: 20),
        ),
        InkWell(
          child: const Text(
            "註冊",
            style: TextStyle(fontSize: 40, color: AppColor.darkBlue),
          ),
          onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const RegisterPage())),
        )
      ],
    );
  }

  Widget loginButton() {
    return AppTextButton.rectangleTextButton(AppColor.black, "登入", 20,
        () async {
      if (isAccountValid && isPasswordValid) {
        Object result = await Auth.loginAuth(
            account_controller.text, password_controller.text);
        if (result != false) {
          UserData _result = result as UserData;
          if (mounted) {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => HomePage(userID: _result.id)));
            Utilities.showSnackBar(context, "歡迎回來!", 2);
          }
        } else {
          setState(() {
            doAuthWarning = true;
          });
          if (mounted) {
            Utilities.showSnackBar(context, "登入失敗", 2);
          }
        }
      } else {
        Utilities.showSnackBar(context, "請確認您的輸入資料格式", 2);
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
          doAuthWarning = false;
        }),
        validator: (value) {
          if (doAuthWarning) {
            isAccountValid = false;
            return "錯誤的帳號或密碼";
          } else if (value == null || value.trim().isEmpty) {
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
          doAuthWarning = false;
        }),
        validator: (value) {
          if (doAuthWarning) {
            isPasswordValid = false;
            return "錯誤的帳號或密碼";
          } else if (value == null || value.trim().isEmpty) {
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
}
