import 'package:flutter/material.dart';
import 'Objs.dart';

class ShowCpelookup extends StatefulWidget {
  static const routeName = '/showCpe';
  @override
  State<StatefulWidget> createState() => _ShowCpelookup();
}

class _ShowCpelookup extends State<ShowCpelookup>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  var searchResults = false;
  var searchResultsData;
  Tween<double> _tween = Tween(begin: 0.8, end: 0.9);
  bool isLoaded = false;
  var jData = "";
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white);

  String cpe = "";
  List<ObjCve> lstcve = [];
  List<dynamic> lstmsf = [];

  getCveItems() {
    return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          for (var i = 0; i < lstcve.length; i++)
            Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  generateTblTxt(lstcve[i].cve),
                  generateCveDisplay(lstcve[i]),
                  generateTblTxt(lstcve[i].description),
                  //generateTblTxt("Exploits of " + args.cve),
                  //generateExploitsDisplay(args)
                ])
        ]);
  }

  getExploitItems() {
    return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          //generateTblTxt(cpe),
          for (var i = 0; i < lstcve.length; i++)
            Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[generateExploitsDisplay(lstcve[i], true)])
        ]);
  }

  List<Widget> _widgetOptions = <Widget>[
    Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[]),
    Text(
      'Cpelookup',
      style: optionStyle,
    ),
    Text(
      'Msflookup',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

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
    final args = ModalRoute.of(context)!.settings.arguments as ObjCpe;
    lstcve = args.lstcve;
    lstmsf = args.lstmsf;
    //print(lstmsf);
    cpe = args.cpe;
    /*if (args != null) {
      jData = args;
    }

    if (jData == null) {
      jData = "";
    }
    if (jData != "") {
      isLoaded = true;
    }*/
    //a:apache:http_server:2.0.28

    //print(args);
    return Scaffold(
        appBar: AppBar(
          title: Text("Cpelookup results"),
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
                                  parent: _controller,
                                  curve: Curves.elasticOut)),
                              child: Image(
                                image:
                                    AssetImage("assets/imgs/bewear_title.png"),
                              )),
                        ),
                        generateTblTxt(args.cpe),
                      ])),
                  Flexible(
                    flex: 5,
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: SingleChildScrollView(
                          //child: _widgetOptions.elementAt(_selectedIndex),
                          child: Column(children: [
                        if (_selectedIndex == 0) getCveItems(),
                        if (_selectedIndex == 1) getExploitItems(),
                        if (_selectedIndex == 2)
                          for (var m in args.lstmsf) generateMsf(m, true)
                      ])),
                    ),
                  ),
                ],
              ),
            )),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.blue,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Cve: ' + args.getCveCount(),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Exploit: ' + args.getExCount(),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Msf: ' + args.getMsfCount(),
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.white,
          selectedIconTheme: IconThemeData(opacity: 0.0, size: 0),
          unselectedIconTheme: IconThemeData(opacity: 0.0, size: 0),
          onTap: _onItemTapped,
        ));
  }
}
/*  generateTblTxt(args.cve),
                          generateCveDisplay(args),
                          generateTblTxt(args.description),
                          generateTblTxt("Exploits of " + args.cve),
                          generateExploitsDisplay(args)*/
