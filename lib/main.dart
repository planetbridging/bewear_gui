import 'package:flutter/material.dart';
import 'cvelookup.dart';
import 'showCve.dart';

void main() {
  runApp(MaterialApp(
    title: 'Japres',
    initialRoute: '/',
    routes: {
      ShowCvelookup.routeName: (context) => ShowCvelookup(),
      '/': (context) => SplashScreen(),
    },
  ));
}

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SplashScreen();
}

class _SplashScreen extends State<SplashScreen> with TickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late AnimationController _controller;
  var searchResults = false;
  var searchResultsData;
  Tween<double> _tween = Tween(begin: 0.8, end: 0.9);
  ObjCvelookup objCvelookup = new ObjCvelookup();
  List<String> LstPlaceholders = [
    "2003-0132",
    "a:apache:http_server:2.0.28",
    "2017-0144"
  ];
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: const Duration(milliseconds: 3000), vsync: this);
    _controller.repeat(reverse: true);
    objCvelookup = new ObjCvelookup();
  }

  @override
  dispose() {
    _controller.dispose(); // you need this
    super.dispose();
  }

  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white);
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Cvelookup',
      style: optionStyle,
    ),
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

  btnSubmit(var value, BuildContext context) async {
    //print(_selectedIndex);
    switch (_selectedIndex) {
      case 0:
        {
          var cvesearch = await objCvelookup.reqCveSearch(value, context);
          setState(() {
            searchResults = true;
            searchResultsData = cvesearch;
          });
        }
        break;

      case 1:
        {
          //statements;
        }
        break;
      case 2:
        {
          //statements;
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        /*appBar: AppBar(
        title: Text(widget.title),
      ),*/
        body: Center(
            child: GestureDetector(
          onTap: () {
            //Navigator.pushNamed(context, '/mainmenu');
          }, // handle your image tap here
          child: Stack(fit: StackFit.expand, children: <Widget>[
            Container(
                decoration: new BoxDecoration(
                  image: new DecorationImage(
                      image: new AssetImage("assets/imgs/planet.png"),
                      fit: BoxFit.cover),
                ),
                child: Column(children: [
                  Flexible(
                      flex: 1,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              flex: 2,
                              child: ScaleTransition(
                                  scale: _tween.animate(CurvedAnimation(
                                      parent: _controller,
                                      curve: Curves.elasticOut)),
                                  child: Image(
                                    image: AssetImage(
                                        "assets/imgs/bewear_title.png"),
                                  )),
                            ),
                            Flexible(
                                flex: 5,
                                child: Container(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      _widgetOptions.elementAt(_selectedIndex),
                                      Form(
                                        key: _formKey,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            TextFormField(
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                              textAlign: TextAlign.center,
                                              decoration: const InputDecoration(
                                                hintText: "Search",
                                              ),
                                              validator: (String? value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please enter some text';
                                                }
                                                btnSubmit(value, context);
                                                return null;
                                              },
                                            ),
                                            Center(
                                              child: Text(
                                                "Example: " +
                                                    LstPlaceholders[
                                                        _selectedIndex],
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white),
                                              ),
                                            ),
                                            Center(
                                                child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 16.0),
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  // Validate will return true if the form is valid, or false if
                                                  // the form is invalid.
                                                  if (_formKey.currentState!
                                                      .validate()) {
                                                    // Process data.
                                                  }
                                                },
                                                child: Text(
                                                  "Submit",
                                                ),
                                              ),
                                            )),
                                          ],
                                        ),
                                      ),
                                      if (searchResults &&
                                          searchResultsData != null)
                                        searchResultsData
                                      /*Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      
                                    ],
                                  ),*/
                                    ],
                                  ),
                                  decoration: new BoxDecoration(
                                    borderRadius:
                                        new BorderRadius.circular(16.0),
                                    color: Colors.black.withOpacity(0.5),
                                  ),
                                )),

                            // _widgetOptions.elementAt(_selectedIndex),
                          ])),
                ])),
          ]),
        )),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.blue,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Cve',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Cpe',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Msf',
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
