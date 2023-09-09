import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  String _msg = "Mesas dísponiveis!";

  void _incrementCounter() {
    setState(() {
      if (_counter >= 0 && _counter < 20){
        _counter++;
      }
      if (_counter == 20)
        _msg = "Lotado!";
    });
  }

  void _decrementCounter(){
    setState(() {
      if (_counter > 0 && _counter <= 20){
        _counter--;
      }
      if (_counter != 20)
        _msg = "Mesas dísponiveis!";
    });
  }


  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Image.asset("images/restaurante.jpg",
            fit: BoxFit.fill,
            height: 1000.0),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Pessoas: $_counter",
              style: TextStyle(color: Color(0xffAED6F1), fontWeight: FontWeight.bold, decoration: TextDecoration.none,  shadows: <Shadow>[
                Shadow(
                  offset: Offset(0.0, 0.0),
                  blurRadius: 7.0,
                  color: Color(0xff000000),
                )
              ],
              ),
            ),
            Text(
              "$_msg",
              style: TextStyle(color: Color(0xffAED6F1), fontSize: 20, fontWeight: FontWeight.bold, decoration: TextDecoration.none,  shadows: <Shadow>[
                Shadow(
                  offset: Offset(0.0, 0.0),
                  blurRadius: 7.0,
                  color: Color(0xff000000),
                )
              ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: ElevatedButton(
                    child: Text(
                      "+1",
                      style: TextStyle(fontSize: 40.0, color: Colors.white),
                    ),
                    onPressed: () {
                      _incrementCounter();
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Color(0xff3498DB)),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: ElevatedButton(
                    child: Text(
                      "-1",
                      style: TextStyle(fontSize: 40.0, color: Colors.white),
                    ),
                    onPressed: () {
                      _decrementCounter();
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Color(0xff3498DB)),
                  ),
                ),
              ],
            )
          ],
        )
      ],
    );
  }
}
