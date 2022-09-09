import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:musharax_app/config/constants.dart';
import 'package:musharax_app/screens/home_page.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  bool _loading = false;
  Future login() async {
    final String username = usernameController.text.trim();
    final String password = passwordController.text.trim();

    if (username.isEmpty & password.isEmpty) {
      return;
    }

    setState(() => _loading = true);

    //SENDING LOGIN INFORMATION TO SERVER
    Map data = {"username": username, "password": password};
    String body = convert.json.encode(data);
    const headers = {"Content-Type": "application/json"};
    var url = Uri.parse("https://musharax-app.herokuapp.com/admin");
    var response = await http.post(url, headers: headers, body: body);

    if (response.body != "NOT_FOUND") {
      print("SUCCESS");
      var dataBody = convert.json.decode(response.body);
      setState(() => _loading = false);
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => HomePage(data: dataBody)));
    } else {
      AwesomeDialog(
        context: context,
        btnOkColor: Colors.red,
        dismissOnTouchOutside: true,
        dismissOnBackKeyPress: true,
        animType: AnimType.TOPSLIDE,
        dialogType: DialogType.ERROR,
        body: Center(
          child: Text(
            'Please enter valid information',
            style: TextStyle(fontSize: 12, fontFamily: 'Karla'),
          ),
        ),
        btnOkOnPress: () {},
      )..show();
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20.0),
        height: size.height,
        width: size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [topGreen, bottomGreen],
          ),
        ),
        child: SafeArea(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: size.width - 100,
                height: size.height / 1.5 + 25,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
              Container(
                width: size.width - 70,
                height: size.height / 1.5 + 5,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
              SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.only(top: 20.0),
                  padding: EdgeInsets.all(20.0),
                  width: size.width,
                  height: size.height / 1.5,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "SIGN IN",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: topGreen,
                                    width: 2,
                                    style: BorderStyle.solid,
                                  ),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    child: Icon(
                                      Icons.person,
                                      color: topGreen,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: TextField(
                                      style: TextStyle(
                                        fontSize: 15,
                                      ),
                                      controller: usernameController,
                                      decoration: InputDecoration(
                                        hintText: "Username",
                                        hintStyle: TextStyle(
                                          letterSpacing: 1,
                                          color: Colors.black.withAlpha(80),
                                          fontSize: 15,
                                        ),
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 20),
                            Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: topGreen,
                                    width: 2,
                                    style: BorderStyle.solid,
                                  ),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    child: Icon(
                                      Icons.lock,
                                      color: topGreen,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: TextField(
                                      style: TextStyle(
                                        fontSize: 15,
                                      ),
                                      obscureText: true,
                                      controller: passwordController,
                                      decoration: InputDecoration(
                                        hintText: "Password",
                                        hintStyle: TextStyle(
                                          color: Colors.black.withAlpha(80),
                                          fontSize: 15,
                                        ),
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      _loading
                          ? SpinKitRipple(
                              color: topGreen,
                              borderWidth: 5,
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(30.0),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: login,
                                  //  {
                                  //   Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //         builder: (context) => HomePage()),
                                  //   );
                                  // },
                                  child: Ink(
                                    color: Colors.transparent,
                                    child: Container(
                                      width: size.width,
                                      height: 60,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                            colors: [bottomGreen, topGreen]),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "LOGIN",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16,
                                            color: Colors.white,
                                            letterSpacing: 1.5,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



// roles 
// admin
// user
// superUser