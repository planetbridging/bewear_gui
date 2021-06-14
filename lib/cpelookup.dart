import 'package:flutter/material.dart';
import 'dart:convert';
import 'Objs.dart';

class ObjCpelookup {
  generateText(String txt) {
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
              txt,
            )));
  }

  reqCpeSearch(var cpe, BuildContext context) async {
    var req = cpe;

    var d = await cpeSearch(req);

    var j = jsonDecode(d.body);
    //print(j);
    try {
      var jd = j["cpe_search"]["data"];
      //print(jd);
      /*for (var v in jd) {
        print(v["CVEName"]);


      }*/

      return Flexible(
          flex: 1,
          child: Container(
            width: 250,
            child: Padding(
              padding: EdgeInsets.all(1.0),
              child: SingleChildScrollView(
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                    for (var i = 0; i < jd.length; i++)
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        child: ElevatedButton(
                          onPressed: () async {
                            ObjCpe tmpcpe = new ObjCpe(jd[i]["cpe"]);
                            await tmpcpe.processCpe();

                            Navigator.pushNamed(context, '/showCpe',
                                arguments: tmpcpe);
                          },
                          child: Text(
                            jd[i]["cpe"],
                          ),
                        ),
                      )
                  ])),
            ),
          ));
    } catch (e) {
      print("unable to get reqCpeSearch");
      print(e);
    }
  }

  getCpelookup() {
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
