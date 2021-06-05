import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

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
  List<String> lstexploits = [];
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
            style: TextStyle(),
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

generateCveDisplay(ObjCve tcve) {
  return Flexible(
    flex: 4,
    child: Padding(
      padding: EdgeInsets.all(16.0),
      child: SingleChildScrollView(
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
          ])),
    ),
  );
}