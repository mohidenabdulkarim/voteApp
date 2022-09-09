import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:musharax_app/config/constants.dart';
import 'package:musharax_app/screens/add_page.dart';
import 'package:musharax_app/screens/add_user_screen.dart';
import 'package:musharax_app/screens/list_show.dart';
import 'package:musharax_app/screens/login_page.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  final data;
  HomePage({Key key, @required this.data}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    fetchNotifications();
  }

  final messageController = TextEditingController();
  var notificationData;
  List<int> list = [1, 2, 3, 4];
  var messages = [];
  bool isLoading = true;
  bool notifyLoading = false;
  var allData, bodyData, byUserData;

  Future sendMessage() async {
    final String message = messageController.text.trim();

    if (message.isEmpty) {
      return;
    }
    final response = await http.post(
        Uri.parse("https://musharax-app.herokuapp.com/admin/add-notify"),
        headers: {"Content-Type": "application/json"},
        body: convert.json.encode({"msg": message}));

    final myRes = convert.json.decode(response.body);
    if (myRes["msg"] != "Success") {
      return;
    }
    Navigator.of(context, rootNavigator: true).pop();
    messageController.clear();
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) => super.widget));
  }

  Future fetchNotifications() async {
    setState(() {
      notifyLoading = true;
    });

    final msgResponse = await http
        .get(Uri.parse("https://musharax-app.herokuapp.com/admin/get-notify"));
    setState(() {
      notificationData = convert.json.decode(msgResponse.body);

      for (var i in notificationData["all"]) {
        i.forEach((k, v) => {
              if (k == "message") {messages.add(v)}
            });
      }
      print(messages);
    });
    setState(() {
      notifyLoading = false;
    });
  }

  Future fetchData() async {
    var res = await http.get(Uri.parse("https://musharax-app.herokuapp.com/"));
    bodyData = convert.json.decode(res.body);

    var res2 = await http.get(
      Uri.parse("https://musharax-app.herokuapp.com/all"),
    );
    allData = convert.json.decode(res2.body);
    var res3 = await http.post(
        Uri.parse(
            "https://musharax-app.herokuapp.com/register/registeredByUser"),
        headers: {"Content-Type": "application/json"},
        body: convert.json.encode({"adminId": widget.data["_id"]}));

    byUserData = convert.json.decode(res3.body);

    if (this.mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var now = new DateTime.now();
    var formatter = new DateFormat('dd-MM-yyyy');
    String formattedDate = formatter.format(now);
    DateTime date = DateTime.now();
    var nowMonth = DateFormat('EEEE').format(date);

    fetchData();

    Size size = MediaQuery.of(context).size;
    return isLoading
        ? Center(
            child: SpinKitRipple(
              color: topGreen,
              borderWidth: 5,
            ),
          )
        : Scaffold(
            body: SingleChildScrollView(
              child: Stack(
                children: [
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 10.0),
                    height: size.height,
                    width: size.width,
                    color: bgLight,
                    child: SafeArea(
                      child: Column(
                        mainAxisAlignment: widget.data["userType"] == "admin"
                            ? MainAxisAlignment.spaceEvenly
                            : MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              RichText(
                                  text: TextSpan(
                                      text:
                                          "${widget.data["name"].toString().toUpperCase()}",
                                      style: TextStyle(
                                        fontSize: size.aspectRatio * 30,
                                        letterSpacing: 1,
                                        color: Colors.black,
                                      ),
                                      children: [
                                    TextSpan(
                                        text: "  ${widget.data["userType"]}",
                                        style: TextStyle(
                                          fontSize: 13,
                                        ))
                                  ])),
                              Row(
                                children: [
                                  Container(
                                      width: 45,
                                      height: 45,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: topGreen,
                                        // border: Border.all(
                                        //   color: topGreen,
                                        //   width: 4,
                                        //   style: BorderStyle.solid,
                                        // ),
                                        boxShadow: [
                                          BoxShadow(
                                            blurRadius: 40,
                                            color: topGreen.withAlpha(70),
                                            offset: Offset(0, 40),
                                          ),
                                        ],
                                      ),
                                      child: InkWell(
                                        onTap: () {
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  scrollable: true,
                                                  title: Text('Notifications'),
                                                  content: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Column(
                                                      children: [
                                                        for (var i in messages)
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Text(
                                                                    "Name",
                                                                    style:
                                                                        TextStyle(
                                                                      color:
                                                                          bottomGreen,
                                                                      fontSize:
                                                                          13,
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    "yesterday 4:pm",
                                                                    style: TextStyle(
                                                                        color:
                                                                            bottomGreen,
                                                                        fontSize:
                                                                            13),
                                                                  )
                                                                ],
                                                              ),
                                                              SizedBox(
                                                                  height: 10),
                                                              Text(i),
                                                              SizedBox(
                                                                  height: 20),
                                                              Divider(
                                                                color: Colors
                                                                    .black38,
                                                                height: 0.2,
                                                                thickness: 0.2,
                                                              ),
                                                            ],
                                                          )
                                                      ],
                                                    ),
                                                  ),
                                                  actions: [
                                                    Row(
                                                      children: [
                                                        RaisedButton(
                                                            child:
                                                                Text("Close"),
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context);
                                                            }),
                                                      ],
                                                    )
                                                  ],
                                                );
                                              });
                                        },
                                        child: Icon(
                                          Icons.notifications_active_sharp,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                      )),
                                  SizedBox(width: 10),
                                  Container(
                                      width: 45,
                                      height: 45,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: topGreen,
                                        // border: Border.all(
                                        //   color: topGreen,
                                        //   width: 4,
                                        //   style: BorderStyle.solid,
                                        // ),
                                        boxShadow: [
                                          BoxShadow(
                                            blurRadius: 40,
                                            color: topGreen.withAlpha(70),
                                            offset: Offset(0, 40),
                                          ),
                                        ],
                                      ),
                                      child: InkWell(
                                        onTap: () {
                                          final route = MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  LoginPage());
                                          Navigator.of(this.context)
                                              .pushAndRemoveUntil(
                                                  route,
                                                  (Route<dynamic> route) =>
                                                      false);
                                        },
                                        child: Icon(
                                          Icons.logout,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                      )),
                                ],
                              )
                            ],
                          ),
                          widget.data["userType"] == "basicUser"
                              ? Container()
                              : Column(
                                  children: [
                                    widget.data["userType"] == "admin"
                                        ? Container()
                                        : Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.calendar_today,
                                                    color: topGreen,
                                                    size: 18,
                                                  ),
                                                  SizedBox(width: 8),
                                                  Text(
                                                    "$nowMonth, $formattedDate",
                                                    style: TextStyle(
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(50.0),
                                                child: Material(
                                                  color: Colors.transparent,
                                                  child: InkWell(
                                                    onTap: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                    AddUser()),
                                                      );
                                                    },
                                                    child: Ink(
                                                      child: Container(
                                                        width: 45,
                                                        height: 45,
                                                        decoration:
                                                            BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          gradient:
                                                              LinearGradient(
                                                            begin: Alignment
                                                                .centerLeft,
                                                            end: Alignment
                                                                .centerRight,
                                                            colors: [
                                                              topGreen,
                                                              bottomGreen
                                                            ],
                                                          ),
                                                          boxShadow: [
                                                            BoxShadow(
                                                              blurRadius: 40,
                                                              color: topGreen
                                                                  .withAlpha(
                                                                      70),
                                                              offset:
                                                                  Offset(0, 40),
                                                            ),
                                                          ],
                                                        ),
                                                        child: Icon(
                                                          Icons.add,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                    SizedBox(height: 10),
                                    Container(
                                      width: size.width,
                                      height: size.height / 4 - 20,
                                      decoration: BoxDecoration(
                                        color: Colors.green,
                                        gradient: LinearGradient(
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                          colors: [topGreen, bottomGreen],
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                        boxShadow: [
                                          BoxShadow(
                                            blurRadius: 40,
                                            color: topGreen.withAlpha(70),
                                            offset: Offset(0, 40),
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child: Center(
                                              child: RichText(
                                                text: widget.data["userType"] ==
                                                        "superAdmin"
                                                    ? TextSpan(
                                                        text: bodyData[
                                                                "registeredPeople"]
                                                            .toString(),
                                                        style: TextStyle(
                                                          fontSize: 30,
                                                          fontFamily: 'Karla',
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                        children: [
                                                            TextSpan(
                                                                text:
                                                                    "\nAyaad haysataa.",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 16,
                                                                  fontFamily:
                                                                      'Karla',
                                                                  height: 1.7,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                )),
                                                          ])
                                                    : TextSpan(
                                                        text:
                                                            byUserData["result"]
                                                                .toString(),
                                                        style: TextStyle(
                                                          fontSize: 30,
                                                          fontFamily: 'Karla',
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                        children: [
                                                            TextSpan(
                                                                text:
                                                                    "\nAyaad haysataa.",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 16,
                                                                  fontFamily:
                                                                      'Karla',
                                                                  height: 1.7,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                )),
                                                          ]),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Center(
                                              child: SvgPicture.asset(
                                                "assets/icons/Celebration-rafiki.svg",
                                                width: 150,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                          widget.data["userType"] == "admin"
                              ? Container()
                              : Row(
                                  children: [
                                    Expanded(
                                      child: Center(
                                        child: Container(
                                          width: size.width / 2 - 35,
                                          height: 110,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                            boxShadow: [
                                              BoxShadow(
                                                blurRadius: 40,
                                                color:
                                                    bottomGreen.withAlpha(50),
                                                offset: Offset(0, 40),
                                              ),
                                            ],
                                          ),
                                          child: Center(
                                              child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Text(
                                                "Xogta Cusub",
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              Text(
                                                bodyData["registeredPeople"]
                                                    .toString(),
                                                style: TextStyle(
                                                  fontSize: 22,
                                                  color: topGreen,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          )),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Center(
                                        child: Container(
                                          width: size.width / 2 - 35,
                                          height: 110,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                            boxShadow: [
                                              BoxShadow(
                                                blurRadius: 40,
                                                color:
                                                    bottomGreen.withAlpha(50),
                                                offset: Offset(0, 40),
                                              ),
                                            ],
                                          ),
                                          child: Center(
                                              child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Text(
                                                "Xogtii Hore",
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              Text(
                                                bodyData["registeredPeople"]
                                                    .toString(),
                                                style: TextStyle(
                                                  fontSize: 22,
                                                  color: topGreen,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          )),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                          widget.data["userType"] == "admin"
                              ? Container()
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(20.0),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => ListShow()),
                                        );
                                      },
                                      child: Ink(
                                        child: Container(
                                          padding: EdgeInsets.all(10.0),
                                          width: size.width,
                                          height: size.height / 4 - 50,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            boxShadow: [
                                              BoxShadow(
                                                blurRadius: 40,
                                                color: topGreen.withAlpha(70),
                                                offset: Offset(0, 40),
                                              ),
                                            ],
                                          ),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Center(
                                                  child: Text(
                                                    "Wadarta\nCodeeyaasha",
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      letterSpacing: 0.2,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: CircularPercentIndicator(
                                                  radius:
                                                      size.aspectRatio * 200,
                                                  lineWidth: 8.0,
                                                  animation: true,
                                                  percent:
                                                      ((10 / 2000) * 100) / 100,
                                                  center: new Text(
                                                    "10.0%",
                                                    style: new TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 12.0),
                                                  ),

                                                  circularStrokeCap:
                                                      CircularStrokeCap.round,
                                                  // progressColor: Color(0xFF6488E4),
                                                  progressColor: topGreen,
                                                  backgroundColor: Colors.grey
                                                      .withOpacity(0.2),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                          widget.data["userType"] == "basicUser"
                              ? Container()
                              : Row(
                                  mainAxisAlignment:
                                      widget.data["userType"] == "admin"
                                          ? MainAxisAlignment.center
                                          : MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(30.0),
                                      child: Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => AddPage(
                                                      data: widget.data)),
                                            );
                                          },
                                          child: Ink(
                                            child: Container(
                                              width: size.width / 4 + 70,
                                              height: 60,
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  begin: Alignment.centerLeft,
                                                  end: Alignment.centerRight,
                                                  colors: [
                                                    topGreen,
                                                    bottomGreen
                                                  ],
                                                ),
                                                boxShadow: [
                                                  BoxShadow(
                                                    blurRadius: 40,
                                                    color:
                                                        topGreen.withAlpha(70),
                                                    offset: Offset(0, 40),
                                                  ),
                                                ],
                                              ),
                                              child: Center(
                                                  child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Text("COD CUSUB",
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      )),
                                                  Icon(
                                                    Icons.add,
                                                    color: Colors.white,
                                                  ),
                                                ],
                                              )),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    widget.data["userType"] == "superAdmin"
                                        ? ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(30.0),
                                            child: Material(
                                              color: Colors.transparent,
                                              child: InkWell(
                                                onTap: () {
                                                  showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return AlertDialog(
                                                          scrollable: true,
                                                          title: Text(
                                                              'Add Notification'),
                                                          content: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Form(
                                                              child: Column(
                                                                children: <
                                                                    Widget>[
                                                                  TextFormField(
                                                                    controller:
                                                                        messageController,
                                                                    maxLines:
                                                                        null,
                                                                    minLines: 3,
                                                                    keyboardType:
                                                                        TextInputType
                                                                            .multiline,
                                                                    decoration:
                                                                        InputDecoration(
                                                                      labelText:
                                                                          'Message',
                                                                      icon: Icon(
                                                                          Icons
                                                                              .message),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          actions: [
                                                            RaisedButton(
                                                                child: Text(
                                                                    "Submit"),
                                                                onPressed:
                                                                    sendMessage),
                                                          ],
                                                        );
                                                      });
                                                },
                                                child: Ink(
                                                  child: Container(
                                                    width: size.width / 4 + 70,
                                                    height: 60,
                                                    decoration: BoxDecoration(
                                                      gradient: LinearGradient(
                                                        begin: Alignment
                                                            .centerLeft,
                                                        end: Alignment
                                                            .centerRight,
                                                        colors: [
                                                          topGreen,
                                                          bottomGreen
                                                        ],
                                                      ),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          blurRadius: 40,
                                                          color: topGreen
                                                              .withAlpha(70),
                                                          offset: Offset(0, 40),
                                                        ),
                                                      ],
                                                    ),
                                                    child: Center(
                                                        child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text("ADD NOTIFICATION",
                                                            style: TextStyle(
                                                              fontSize: 12,
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            )),
                                                        Icon(
                                                          Icons.add,
                                                          color: Colors.white,
                                                        ),
                                                      ],
                                                    )),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        : Container(),
                                  ],
                                )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
  }
}

// the superAdmin page
// the circle functionality
// add realTime dattime
