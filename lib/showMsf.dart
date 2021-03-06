import 'package:flutter/material.dart';
import 'Objs.dart';

class ShowMsflookup extends StatefulWidget {
  static const routeName = '/showMsf';
  @override
  State<StatefulWidget> createState() => _ShowMsflookup();
}

class _ShowMsflookup extends State<ShowMsflookup>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  var searchResults = false;
  var searchResultsData;
  Tween<double> _tween = Tween(begin: 0.8, end: 0.9);
  bool isLoaded = false;
  var jData = "";
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: const Duration(milliseconds: 3000), vsync: this);
    _controller.repeat(reverse: true);
  }

  @override
  dispose() {
    _controller.dispose(); // you need this
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //final args = ModalRoute.of(context)!.settings.arguments as List<dynamic>;
    final args = ModalRoute.of(context)!.settings.arguments as ObjCve;
    /*if (args != null) {
      jData = args;
    }

    if (jData == null) {
      jData = "";
    }
    if (jData != "") {
      isLoaded = true;
    }*/

    //print(args);
    return Scaffold(
      appBar: AppBar(
        title: Text("Msflookup results"),
      ),
      body: DefaultTextStyle(
          style: TextStyle(color: Colors.white),
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: new BoxDecoration(
              image: new DecorationImage(
                  image: new AssetImage("assets/imgs/planet.png"),
                  fit: BoxFit.cover),
            ),
            child: Column(
              children: [
                Flexible(
                    flex: 1,
                    child: Column(children: [
                      Flexible(
                        child: ScaleTransition(
                            scale: _tween.animate(CurvedAnimation(
                                parent: _controller, curve: Curves.elasticOut)),
                            child: Image(
                              image: AssetImage("assets/imgs/bewear_title.png"),
                            )),
                      ),
                    ])),
                Flexible(
                  flex: 4,
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: SingleChildScrollView(
                        child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                          generateTblTxt(args.cve),
                          generateMsf(args.lstmsf, false)
                        ])),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
