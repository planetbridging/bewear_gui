import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';

Future<http.Response> getDynData(String link, String path, var parms) {
  return http.get(Uri.https(link, path, parms));
}

Future<http.Response> cveSearch(cve) {
  return http.get(
      Uri.parse('https://api.pressback.space/cpelookup?cve_search=' + cve));
}

Future<http.Response> getCve(cve) {
  return http
      .get(Uri.parse('https://api.pressback.space/cpelookup?cve=' + cve));
}

Future<http.Response> getCpe(cpe) {
  return http
      .get(Uri.parse('https://api.pressback.space/cpelookup?cpe=' + cpe));
}

Future<http.Response> getMsf(cve) {
  return http
      .get(Uri.parse('https://api.pressback.space/cpelookup?msf=' + cve));
}

Future<http.Response> getMsfCpe(cpe) {
  return http
      .get(Uri.parse('https://api.pressback.space/cpelookup?msfcpe=' + cpe));
}

Future<http.Response> cpeSearch(cpe) {
  //print('https://api.pressback.space/cpelookup?cpe_search=' + cpe);
  return http.get(
      Uri.parse('https://api.pressback.space/cpelookup?cpe_search=' + cpe));
}

getCveExploits(String cve) async {
  var d = await getCve(cve);

  var j = jsonDecode(d.body);
  try {
    var jd = j["cve"]["lstexploits"];
    return jd;
  } catch (e) {
    print("unable to get getCveExploits");
    print(e);
  }
}

getCveMsf(String cve) async {
  var d = await getMsf(cve);

  var j = jsonDecode(d.body);
  try {
    var jd = j["data"];
    return jd;
  } catch (e) {
    print("unable to get getCveExploits");
    print(e);
  }
}

getCpeMsf(String cpe) async {
  var d = await getMsfCpe(cpe);

  var j = jsonDecode(d.body);
  try {
    var jd = j["data"];
    return jd;
  } catch (e) {
    print("unable to get getCpeMsf");
    print(e);
  }
}

class ObjCve {
  String cve = "";
  String year = "";
  String score = "";
  String accessVector = "";
  String accessComplexity = "";
  String authentication = "";
  String confidentialityImpact = "";
  String integrityImpact = "";
  String availabilityImpact = "";
  String description = "";
  List<String> lstCpe = [];
  List<dynamic> lstexploits = [];
  List<dynamic> lstmsf = [];
  int cardnumber = 0;
  ObjCve(String c, String y, String s, String av, String ac, a, String ci,
      String ii, ai, String d, String cpe) {
    this.cve = c;
    this.year = y;
    this.score = s;
    this.accessVector = av;
    this.accessComplexity = ac;
    this.authentication = a;
    this.confidentialityImpact = ci;
    this.integrityImpact = ii;
    this.availabilityImpact = ai;
    this.description = d;
    if (cpe.contains("cpe:2.3:")) {
      var split = cpe.replaceAll("cpe:2.3:", "").split(':::');
      lstCpe = split;
    }
  }
  setExploits(var items) {
    for (var i in items) {
      print(i);
    }
  }
}

//exploits row
//id	file	description	date	author	type	platform	port
class ObjCpe {
  List<ObjCve> lstcve = [];
  List<dynamic> lstmsf = [];
  String cpe = "";
  int cveCount = 0;
  int exploitCount = 0;
  int msfCount = 0;

  getCveCount() {
    return this.cveCount.toString();
  }

  getExCount() {
    return this.exploitCount.toString();
  }

  getMsfCount() {
    return this.msfCount.toString();
  }

  ObjCpe(String c) {
    this.cpe = c;
  }
  processCpe() async {
    this.lstmsf = await getCpeMsf(this.cpe);
    try {
      var d = await getCpe(this.cpe);
      var j = jsonDecode(d.body);
      var jd = j["bulk"];
      for (var i in jd) {
        //print(i["data"]["CVEName"]);
        ObjCve tmpocve = new ObjCve(
          i["data"]["CVEName"],
          i["data"]["Year"],
          i["data"]["Score"],
          i["data"]["AccessVector"],
          i["data"]["AccessComplexity"],
          i["data"]["Authentication"],
          i["data"]["ConfidentialityImpact"],
          i["data"]["IntegrityImpact"],
          i["data"]["AvailabilityImpact"],
          i["data"]["Description"],
          "",
        );
        tmpocve.lstexploits = i["lstexploits"];
        lstcve.add(tmpocve);
        cveCount += 1;
        exploitCount += tmpocve.lstexploits.length;
      }
      msfCount = lstmsf.length;
      print("cve: " + cveCount.toString());
      print("ex: " + exploitCount.toString());
      print("msf: " + msfCount.toString());
    } catch (e) {
      print("unable to processCpe");
      print(e);
    }
  }
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
            style: TextStyle(color: Colors.black),
          )));
}

generateTableCell(String txt) {
  return TableCell(
    verticalAlignment: TableCellVerticalAlignment.top,
    child: Container(child: Center(child: Text(txt))),
  );
}

generateTblTxt(String txt) {
  return Flexible(
    flex: 2,
    child: Padding(
      padding: const EdgeInsets.only(
        left: 10,
        top: 10,
        right: 10,
        bottom: 10,
      ),
      child: Container(
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
                style: TextStyle(color: Colors.black),
              ))),
    ),
  );
}

mergeArray(List<dynamic> lst) {
  String items = "";
  for (var l in lst) {
    items += l.toString() + ",";
  }
  return items;
}

//a:apache:http_server:2.0.28
generateMsf(List<dynamic> msf, bool showtext) {
  return /*Flexible(
    flex: 4,
    child: */
      Padding(
    padding: EdgeInsets.all(16.0),
    //child: SingleChildScrollView
    child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          for (var m in msf)
            Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  if (showtext) generateTblTxt(m[1]),
                  generateTblTxt(m[3]),
                  Container(
                      child: Table(
                        border: TableBorder.all(),
                        defaultVerticalAlignment:
                            TableCellVerticalAlignment.fill,
                        children: <TableRow>[
                          TableRow(
                            children: <Widget>[
                              generateTableCell("Path"),
                              generateTableCell(m[0]),
                            ],
                          ),
                          TableRow(
                            children: <Widget>[
                              generateTableCell("Type"),
                              generateTableCell(m[2]),
                            ],
                          ),
                          TableRow(
                            children: <Widget>[
                              generateTableCell("Arch"),
                              generateTableCell(m[7]),
                            ],
                          ),
                          TableRow(
                            children: <Widget>[
                              generateTableCell("OS"),
                              generateTableCell(m[8]),
                            ],
                          ),
                          TableRow(
                            children: <Widget>[
                              generateTableCell("Ports"),
                              generateTableCell(mergeArray(m[6])),
                            ],
                          ),
                          TableRow(
                            children: <Widget>[
                              generateTableCell("Info"),
                              generateTableCell(mergeArray(m[9])),
                            ],
                          ),
                        ],
                      ),
                      decoration: new BoxDecoration(
                        //borderRadius: new BorderRadius.circular(16.0),
                        color: Colors.black.withOpacity(0.5),
                      )),
                  generateTblTxt(m[4]),
                ]),
        ]),
    // ),
  );
}

generateCveDisplay(ObjCve tcve) {
  return Flexible(
    flex: 4,
    child: Padding(
      padding: EdgeInsets.all(16.0),
      //child: SingleChildScrollView
      child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Container(
                child: Table(
                  border: TableBorder.all(),
                  defaultVerticalAlignment: TableCellVerticalAlignment.fill,
                  children: <TableRow>[
                    TableRow(
                      children: <Widget>[
                        generateTableCell("Year"),
                        generateTableCell("Score"),
                        generateTableCell("Access Vector"),
                      ],
                    ),
                    TableRow(
                      children: <Widget>[
                        generateTableCell(tcve.year),
                        generateTableCell(tcve.score),
                        generateTableCell(tcve.accessVector),
                      ],
                    ),
                    TableRow(
                      children: <Widget>[
                        generateTableCell("Access Complexity"),
                        generateTableCell(""),
                        generateTableCell("Authentication"),
                      ],
                    ),
                    TableRow(
                      children: <Widget>[
                        generateTableCell(tcve.accessComplexity),
                        generateTableCell(""),
                        generateTableCell(tcve.authentication),
                      ],
                    ),
                    TableRow(
                      children: <Widget>[
                        generateTableCell("Confidentiality"),
                        generateTableCell("Integrity"),
                        generateTableCell("Availability"),
                      ],
                    ),
                    TableRow(
                      children: <Widget>[
                        generateTableCell(tcve.confidentialityImpact),
                        generateTableCell(tcve.integrityImpact),
                        generateTableCell(tcve.availabilityImpact),
                      ],
                    ),
                  ],
                ),
                decoration: new BoxDecoration(
                  //borderRadius: new BorderRadius.circular(16.0),
                  color: Colors.black.withOpacity(0.5),
                ))
          ]),
    ),
  );
}

generateExploitsDisplay(ObjCve tcve, bool showtitle) {
  //id,file,description,date,author,type,platform,port
  if (tcve.lstexploits.length > 0) {
    return Flexible(
      flex: 1,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              if (showtitle) generateTblTxt("Exploits of " + tcve.cve),
              for (var t in tcve.lstexploits)
                Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Container(
                          child: Table(
                            border: TableBorder.all(),
                            defaultVerticalAlignment:
                                TableCellVerticalAlignment.fill,
                            children: <TableRow>[
                              TableRow(
                                children: <Widget>[
                                  generateTableCell("id"),
                                  generateTableCell("type"),
                                  generateTableCell("platform"),
                                ],
                              ),
                              TableRow(
                                children: <Widget>[
                                  generateTableCell(t[0]),
                                  generateTableCell(t[5]),
                                  generateTableCell(t[6]),
                                ],
                              ),
                              TableRow(
                                children: <Widget>[
                                  generateTableCell(""),
                                  generateTableCell("file"),
                                  generateTableCell(""),
                                ],
                              ),
                              TableRow(
                                children: <Widget>[
                                  generateTableCell(""),
                                  generateTableCell(t[1]),
                                  generateTableCell(""),
                                ],
                              ),
                              TableRow(
                                children: <Widget>[
                                  generateTableCell(""),
                                  generateTableCell("port"),
                                  generateTableCell(""),
                                ],
                              ),
                              TableRow(
                                children: <Widget>[
                                  generateTableCell(""),
                                  generateTableCell(t[7]),
                                  generateTableCell(""),
                                ],
                              ),
                            ],
                          ),
                          decoration: new BoxDecoration(
                            //borderRadius: new BorderRadius.circular(16.0),
                            color: Colors.black.withOpacity(0.5),
                          ))
                    ])
            ]),
      ),
    );
  } else {
    return Flexible(
      flex: 4,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
            child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
              if (!showtitle) Container(child: Text("No exploits found"))
            ])),
      ),
    );
  }
}
