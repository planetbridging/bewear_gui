import 'package:flutter/material.dart';

class ObjCvelookup {
  getCvelookup() {
    return Container(
        //height: 20,
        //margin: const EdgeInsets.only(top: 20.0),
        decoration: new BoxDecoration(
          borderRadius: new BorderRadius.circular(16.0),
          color: Colors.white,
        ),
        child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "txt",
              style: TextStyle(),
            )));
  }
}

class Alert extends StatelessWidget {
  final String titlea;
  final String contexta;

  Alert(this.titlea, this.contexta);

  AlertDialog dialog = AlertDialog(
    title: Text("ff"),
    content: Text("dd"),
  );

  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context, builder: (BuildContext context) => dialog);
        },
      ),
    );
  }
}
