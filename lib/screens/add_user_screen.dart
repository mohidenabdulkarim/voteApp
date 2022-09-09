import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:musharax_app/config/constants.dart';
import 'package:musharax_app/widgets/input_field.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class AddUser extends StatefulWidget {
  AddUser({Key key}) : super(key: key);

  @override
  _AddUserState createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  bool _loading = false;
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final matchPasswordController = TextEditingController();
  final phoneNumberController = TextEditingController();

  String currentValue;
  List listItems = ["admin", "basicUser"];

  Future add() async {
    final String name = usernameController.text;
    final String password = passwordController.text;
    final String matchPassword = matchPasswordController.text;
    final String phoneNumber = phoneNumberController.text;

    if (name.isEmpty &&
        password.isEmpty &&
        matchPassword.isEmpty &&
        phoneNumber.isEmpty &&
        currentValue.isEmpty) {
      return;
    }

    if (password != matchPassword) {
      AwesomeDialog(
        context: context,
        btnOkColor: Colors.red,
        dismissOnTouchOutside: true,
        dismissOnBackKeyPress: true,
        animType: AnimType.TOPSLIDE,
        dialogType: DialogType.ERROR,
        body: Center(
          child: Text(
            'Labada raqam sir isku mid ma aha ❌',
            style: TextStyle(fontSize: 12),
          ),
        ),
        btnOkOnPress: () {},
      )..show();
    }

    if (this.mounted) {
      setState(() => _loading = true);
    }

    Map data = {
      "name": name,
      "phoneNumber": phoneNumber,
      "userType": currentValue,
      "password": password,
      "matchPassword": matchPassword
    };
    print(data);
    var body = convert.json.encode(data);

    var response = await http.post(
        Uri.parse("https://musharax-app.herokuapp.com/admin/sign-up"),
        headers: {"Content-Type": "application/json"},
        body: body);
    var resBody = convert.json.decode(response.body);

    if (resBody["msg"] == "SUCCESS") {
      AwesomeDialog(
        context: context,
        btnOkColor: topGreen,
        dismissOnTouchOutside: true,
        dismissOnBackKeyPress: true,
        animType: AnimType.TOPSLIDE,
        dialogType: DialogType.SUCCES,
        body: Center(
          child: Text(
            'Waad diwaan galisay ✅',
            style: TextStyle(fontSize: 12),
          ),
        ),
        btnOkOnPress: () {},
      )..show();
    }
    setState(() => _loading = false);
    usernameController.clear();
    phoneNumberController.clear();
    passwordController.clear();
    matchPasswordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
          title: Text(
            "Diwan gali qof cusub",
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: topGreen,
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          )),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.all(10.0),
              height: size.height,
              width: size.width,
              color: bgLight,
              child: SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        padding: EdgeInsets.all(30.0),
                        width: size.width,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InputField(
                                title: "Magaca", cont: usernameController),
                            SizedBox(height: 25),
                            InputField(
                              title: "Tilfon lambraka",
                              cont: phoneNumberController,
                              isNumber: true,
                            ),
                            InputField(
                              title: "Raqamka sirta ah",
                              cont: passwordController,
                              pass: true,
                            ),
                            SizedBox(height: 25),
                            InputField(
                              title: "Ku celi raqamka sirta ah",
                              cont: matchPasswordController,
                              isNumber: true,
                              pass: true,
                            ),
                            SizedBox(height: 50),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 3.0),
                              decoration: BoxDecoration(
                                color: topGreen,
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 40,
                                    color: topGreen.withAlpha(70),
                                    offset: Offset(0, 40),
                                  ),
                                ],
                              ),
                              child: DropdownButton(
                                hint: Text(
                                  "Select",
                                  style: TextStyle(color: Colors.white),
                                ),
                                dropdownColor: topGreen,
                                underline: SizedBox(),
                                iconEnabledColor: Colors.white,
                                value: currentValue,
                                onChanged: (newValue) {
                                  setState(() => currentValue = newValue);
                                },
                                items: listItems.map((item) {
                                  return DropdownMenuItem(
                                    value: item,
                                    child: Text(
                                      item,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                            SizedBox(height: 50),
                            _loading
                                ? SpinKitRipple(
                                    color: topGreen,
                                    borderWidth: 5,
                                  )
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(30.0),
                                    child: Material(
                                      child: InkWell(
                                        onTap: add,
                                        child: Ink(
                                          child: Container(
                                            width: size.width / 2,
                                            height: 55,
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                begin: Alignment.centerLeft,
                                                end: Alignment.centerRight,
                                                colors: [topGreen, bottomGreen],
                                              ),
                                            ),
                                            child: Center(
                                              child: Text(
                                                "Diwan Gali",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18,
                                                  letterSpacing: 1,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
