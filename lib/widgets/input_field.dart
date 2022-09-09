import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final String title;
  final cont;
  final bool isNumber;
  final bool pass;
  const InputField({
    Key key,
    this.title,
    this.cont,
    this.isNumber = false,
    this.pass = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$title*",
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          SizedBox(height: 10),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15.0),
            decoration: BoxDecoration(
              color: Color(0xFFAFFBF1),
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: TextField(
              obscureText: pass ? true : false,
              keyboardType:
                  isNumber ? TextInputType.number : TextInputType.text,
              controller: cont,
              decoration: InputDecoration(
                border: InputBorder.none,
              ),
            ),
          )
        ],
      ),
    );
  }
}
