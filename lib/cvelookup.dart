import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'Objs.dart';

class ObjCvelookup {
  Future<http.Response> getDynData(String link, String path, var parms) {
    return http.get(Uri.https(link, path, parms));
  }

  Future<http.Response> cveSearch(cve) {
    return http.get(
        Uri.parse('https://api.pressback.space/cpelookup?cve_search=' + cve));
  }

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

  reqCveSearch(var cve, BuildContext context) async {
    var req = "CVE-" + cve;

    var d = await cveSearch(req);

    var j = jsonDecode(d.body);
    try {
      var jd = j["cve_search"]["data"];
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
                            //print(jd[i]);
                            ObjCve tmpocve = new ObjCve(
                              jd[i]["CVEName"],
                              jd[i]["Year"],
                              jd[i]["Score"],
                              jd[i]["AccessVector"],
                              jd[i]["AccessComplexity"],
                              jd[i]["Authentication"],
                              jd[i]["ConfidentialityImpact"],
                              jd[i]["IntegrityImpact"],
                              jd[i]["AvailabilityImpact"],
                              jd[i]["Description"],
                              jd[i]["LstCpe"],
                            );
                            var exploits =
                                await getCveExploits(jd[i]["CVEName"]);
                            tmpocve.lstexploits = exploits;

                            var msf = await getCveMsf(jd[i]["CVEName"]);
                            print(msf);
                            /*Navigator.pushNamed(context, '/showCve',
                                arguments: tmpocve);*/
                          },
                          child: Text(
                            jd[i]["CVEName"],
                          ),
                        ),
                      )
                  ])),
            ),
          ));
    } catch (e) {
      print("unable to get reqCveSearch");
      print(e);
    }
  }

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
