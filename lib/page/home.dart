import 'package:flutter/material.dart';
import 'package:ws54_flutter_speedrun3/constant/style_guide.dart';
import 'package:ws54_flutter_speedrun3/page/add_password.dart';
import 'package:ws54_flutter_speedrun3/page/user.dart';
import 'package:ws54_flutter_speedrun3/service/sql_sevice.dart';
import 'package:ws54_flutter_speedrun3/service/utilities.dart';
import 'package:ws54_flutter_speedrun3/widget/text_button.dart';

import '../service/Auth.dart';
import '../service/data_model.dart';
import 'edit.dart';
import 'login.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.userID});
  final String userID;
  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late TextEditingController tag_controller;
  late TextEditingController url_controller;
  late TextEditingController login_controller;
  late TextEditingController password_controller;
  late TextEditingController id_controller;

  bool hasFav = false;
  int isFav = 1;
  List<PasswordData> passwordList = [];
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setCurrentUserAllPasswordList();
    });
    super.initState();
    tag_controller = TextEditingController();
    url_controller = TextEditingController();
    login_controller = TextEditingController();
    password_controller = TextEditingController();
    id_controller = TextEditingController();
  }

  @override
  void dispose() {
    tag_controller.dispose();
    url_controller.dispose();
    login_controller.dispose();
    password_controller.dispose();
    id_controller.dispose();
    super.dispose();
  }

  void setCurrentUserAllPasswordList() async {
    List<PasswordData> _passwordList =
        await PasswordDAO.getPasswordListByUserID(widget.userID);
    setState(() {
      passwordList = _passwordList;
      print(
          "got new password list!!! // got :${passwordList.isEmpty},${passwordList.length} ");
    });
  }

  void setPasswordListyCondition() async {
    List<PasswordData> _passwordList =
        await PasswordDAO.getPasswordListByCondition(
            widget.userID,
            tag_controller.text,
            url_controller.text,
            login_controller.text,
            password_controller.text,
            id_controller.text,
            hasFav,
            isFav);
    setState(() {
      passwordList = _passwordList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          backgroundColor: AppColor.black,
          onPressed: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => AddPasswordPage(userID: widget.userID))),
          child: const Icon(Icons.add)),
      drawer: navDrawer(),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: homAppBar(),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: searchArea(),
                ),
                passwordLisViewBuilder()
              ],
            )),
      ),
    );
  }

  Widget searchArea() {
    return Container(
      padding: const EdgeInsets.fromLTRB(40, 20, 40, 20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: AppColor.black, width: 2.0)),
      child: Column(children: [
        TextFormField(
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.tag),
            hintText: "tag",
          ),
          controller: tag_controller,
        ),
        TextFormField(
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.link),
            hintText: "url",
          ),
          controller: url_controller,
        ),
        TextFormField(
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.email),
            hintText: "login",
          ),
          controller: login_controller,
        ),
        TextFormField(
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.key),
            hintText: "password",
          ),
          controller: password_controller,
        ),
        TextFormField(
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.key),
            hintText: "id",
          ),
          controller: id_controller,
        ),
        Row(
          children: [
            Expanded(
                child: CheckboxListTile(
                    controlAffinity: ListTileControlAffinity.leading,
                    title: const Text("啟用我的最愛"),
                    value: (hasFav),
                    onChanged: (value) => setState(() {
                          hasFav = !hasFav;
                        }))),
            Expanded(
                child: CheckboxListTile(
                    controlAffinity: ListTileControlAffinity.leading,
                    title: const Text("我的最愛"),
                    enabled: hasFav,
                    value: (isFav == 0 ? false : true),
                    onChanged: (value) => setState(() {
                          isFav = isFav == 0 ? 1 : 0;
                        }))),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppTextButton.rectangleTextButton(AppColor.black, "搜尋", 20,
                () async {
              setPasswordListyCondition();
              Utilities.showSnackBar(context, "已搜尋", 1);
            }),
            AppTextButton.rectangleTextButton(AppColor.black, "清除", 20,
                () async {
              setState(() {
                tag_controller.text = "";
                url_controller.text = "";
                login_controller.text = "";
                password_controller.text = "";
                id_controller.text = "";
                isFav = 1;
                hasFav = false;
              });
              Utilities.showSnackBar(context, "已清除", 1);
            }),
            AppTextButton.rectangleTextButton(AppColor.black, "取消搜尋", 20,
                () async {
              setCurrentUserAllPasswordList();
              Utilities.showSnackBar(context, "已取消搜尋", 1);
            })
          ],
        )
      ]),
    );
  }

  Widget passwordLisViewBuilder() {
    return ListView.builder(
        primary: false,
        shrinkWrap: true,
        itemCount: passwordList.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(15),
            child: dataContainer(passwordList[index]),
          );
        });
  }

  Widget dataContainer(PasswordData data) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: AppColor.black, width: 2.0)),
      child: Column(children: [
        Text("標籤${data.tag}"),
        Text("網址${data.url}"),
        Text("登入帳號${data.login}"),
        Text("密碼${data.password}"),
        Text("ID${data.id}"),
        Row(
          children: [
            TextButton(
                style: TextButton.styleFrom(
                    iconColor: data.isFav == 0 ? AppColor.red : AppColor.white,
                    shape: const CircleBorder(),
                    side: const BorderSide(color: AppColor.red, width: 2.0),
                    backgroundColor:
                        data.isFav == 0 ? AppColor.white : AppColor.red),
                onPressed: () async {
                  await PasswordDAO.updatePasswordData(data);
                  setState(() {
                    data.isFav = data.isFav == 0 ? 1 : 0;
                    print(data.isFav);
                  });
                },
                child: Icon(
                  data.isFav == 0 ? Icons.favorite_border : Icons.favorite,
                )),
            TextButton(
                style: TextButton.styleFrom(
                    iconColor: AppColor.white,
                    shape: const CircleBorder(),
                    backgroundColor: AppColor.green),
                onPressed: () async {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => EditPage(
                            userID: widget.userID,
                            passwordID: data.id,
                          )));
                },
                child: const Icon(Icons.edit)),
            TextButton(
                style: TextButton.styleFrom(
                    iconColor: AppColor.white,
                    shape: const CircleBorder(),
                    backgroundColor: AppColor.red),
                onPressed: () async {
                  await PasswordDAO.deletePasswordData(data);
                  setState(() {
                    setCurrentUserAllPasswordList();
                  });
                },
                child: const Icon(Icons.delete))
          ],
        )
      ]),
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

  Widget navDrawer() {
    return Drawer(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.of(context).pop(context);
                  },
                  icon: const Icon(Icons.close)),
              Image.asset(
                "assets/icon.png",
                width: 24,
                height: 24,
              )
            ],
          ),
          ListTile(
            title: const Text("主畫面"),
            leading: const Icon(Icons.home),
            onTap: () => Navigator.of(context).pop(),
          ),
          ListTile(
            title: const Text("帳戶設置"),
            leading: const Icon(Icons.home),
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => UserPage(userID: widget.userID))),
          ),
          logOutButton()
        ]),
      ),
    );
  }

  Widget homAppBar() {
    return AppBar(
      backgroundColor: AppColor.black,
      centerTitle: true,
      title: const Text("主畫面"),
    );
  }
}
