import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:musharax_app/config/constants.dart';
import 'package:musharax_app/widgets/input_field.dart';
import 'package:http/http.dart' as http;

class AddPage extends StatefulWidget {
  final data;
  AddPage({Key key, @required this.data}) : super(key: key);

  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final nameController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final idController = TextEditingController();
  final areaController = TextEditingController();

  Future add() async {
    final name = nameController.text;
    final pNumber = phoneNumberController.text;
    final id = idController.text;
    final area = areaController.text;

    if (name.isEmpty && pNumber.isEmpty && id.isEmpty && area.isEmpty) {
      return;
    }

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

    nameController.clear();
    phoneNumberController.clear();
    idController.clear();
    areaController.clear();
// https://musharax-app.herokuapp.com/register
    Map data = {
      "name": name,
      "pNumber": pNumber,
      "id": id,
      "area": area,
      "addBy": widget.data
    };
    String body = json.encode(data);
    const headers = {'Content-Type': 'application/json'};
    var url = Uri.parse("https://musharax-app.herokuapp.com/register");
    var response = await http.post(url, headers: headers, body: body);
    print("response is : $response");
    print("name: $name\nPhoneNumber: $pNumber\nid: $id\narea : $area");
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Diwan gali"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: topGreen,
      ),
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
                      // Row(
                      //   children: [
                      //     ClipRRect(
                      //       borderRadius: BorderRadius.circular(10.0),
                      //       child: Material(
                      //         color: Colors.transparent,
                      //         child: InkWell(
                      //           onTap: () {
                      //             Navigator.pop(context);
                      //           },
                      //           child: Ink(
                      //             child: Container(
                      //               width: 38,
                      //               height: 38,
                      //               decoration: BoxDecoration(
                      //                 color: Color(0xff22CCB1),
                      //               ),
                      //               child: Icon(
                      //                 Icons.arrow_back,
                      //                 color: Colors.white,
                      //               ),
                      //             ),
                      //           ),
                      //         ),
                      //       ),
                      //     ),
                      //     SizedBox(width: 100),
                      //     Text(
                      //       "Diwan gali",
                      //       style: TextStyle(
                      //         fontSize: 18,
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      Container(
                        padding: EdgeInsets.all(30.0),
                        width: size.width,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Column(
                          children: [
                            InputField(title: "Magaca", cont: nameController),
                            SizedBox(height: 25),
                            InputField(
                              title: "Lambarka",
                              cont: phoneNumberController,
                              isNumber: true,
                            ),
                            SizedBox(height: 25),
                            InputField(
                              title: "ID kaadh lambar",
                              cont: idController,
                              isNumber: true,
                            ),
                            SizedBox(height: 25),
                            InputField(
                                title: "Goobta codaynta", cont: areaController),
                            SizedBox(height: 50),
                            ClipRRect(
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
