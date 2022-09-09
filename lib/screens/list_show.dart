import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:musharax_app/config/constants.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:rflutter_alert/rflutter_alert.dart';

class ListShow extends StatefulWidget {
  ListShow({Key key}) : super(key: key);

  @override
  _ListShowState createState() => _ListShowState();
}

class _ListShowState extends State<ListShow> {
  var allData;
  bool isLoading = true;
  Future fetch() async {
    var res2 = await http.get(
      Uri.parse("https://musharax-app.herokuapp.com/register/all"),
    );
    allData = convert.json.decode(res2.body);
    // print("ALL DATA : $allData");

    if (this.mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    fetch();
    return isLoading
        ? SpinKitCircle(
            color: topGreen,
            size: 20,
          )
        : Scaffold(
            appBar: AppBar(
              leading: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(Icons.arrow_back),
              ),
              title: Text(
                "Codeeyaasha",
                style: TextStyle(fontSize: 16),
              ),
              centerTitle: true,
              elevation: 0,
              backgroundColor: topGreen,
            ),
            body: allData["all"].length < 0
                ? Container(
                    color: bgLight,
                    child: ListView.builder(
                      itemCount: allData["all"].length,
                      itemBuilder: (BuildContext context, int index) {
                        return Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              Alert(
                                context: context,
                                title: "",
                                content: Column(
                                  children: [
                                    RichText(
                                      text: TextSpan(
                                        text:
                                            "${allData["all"][index]["name"]}\n" ??
                                                "N/A",
                                        style: TextStyle(color: Colors.black),
                                        children: [
                                          TextSpan(
                                              text:
                                                  "${allData["all"][index]["pNumber"]}\n"),
                                          TextSpan(
                                              text:
                                                  "${allData["all"][index]["cardId"]}\n"),
                                          TextSpan(
                                              text:
                                                  "${allData["all"][index]["area"]}"),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ).show();
                            },
                            child: Ink(
                              child: Card(
                                elevation: 0,
                                margin: EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 5.0),
                                color: Colors.white,
                                child: ListTile(
                                  title: Text(allData["all"][index]["name"]),
                                  trailing: Icon(
                                    Icons.info,
                                    color: bottomGreen,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  )
                : Center(
                    child: Text(
                    "Wali waxba ma diwaan gashana",
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  )),
          );
  }
}
