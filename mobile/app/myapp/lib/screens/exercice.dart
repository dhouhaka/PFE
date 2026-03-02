import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Exercice extends StatelessWidget {
  const Exercice({super.key});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("First Page"),
          backgroundColor: Colors.blueGrey,
        ),
        body: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: [
                Icon(Icons.phone, color: Colors.blueAccent, size: 25),
                SizedBox(height: 10),
                Text(
                  "CALL",
                  style: TextStyle(color: Colors.blueAccent, fontSize: 15),
                ),
              ],
            ),

            SizedBox(width: 10),
            Column(
              children: [
                Icon(Icons.navigate_next, color: Colors.blueAccent, size: 25),
                SizedBox(height: 10),
                Text(
                  "ROUTE",
                  style: TextStyle(color: Colors.blueAccent, fontSize: 15),
                ),
              ],
            ),
            SizedBox(width: 10),
            Column(
              children: [
                Icon(Icons.share, color: Colors.blueAccent, size: 25),
                SizedBox(height: 10),
                Text(
                  "SHARE",
                  style: TextStyle(color: Colors.blueAccent, fontSize: 15),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
