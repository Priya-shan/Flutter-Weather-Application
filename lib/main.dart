import 'package:flutter/material.dart';
import 'FetchWeatherData.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(title: Text("Weather Application")),
          body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/bg.gif"),
                fit: BoxFit.cover,
              ),
            ),
            child: FetchWeatherData(),
          )),
    );
  }
}
