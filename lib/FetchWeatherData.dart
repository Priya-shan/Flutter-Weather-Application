import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

class FetchWeatherData extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _fetchWeatherData();
  }
}

// ignore: camel_case_types
class _fetchWeatherData extends State<FetchWeatherData> {
  var jsonResponse;
  var resultTemperature = "";
  var resultMood = "";
  var resultCity = "";

  String apiKey = '7b6c82e83b5de0b02b4762f19954ec09';
  Future<void> fetchLatLon(city) async {
    setState(() {
      resultCity = city;
    });
    print("got sity");
    print(city);
    String apiUrl =
        "http://api.openweathermap.org/geo/1.0/direct?q=$city&appid=$apiKey";

    http.get(Uri.parse(apiUrl)).then((response) {
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        var locationData = jsonResponse[0];
        var lattitude = locationData['lat'];
        var longitude = locationData['lon'];
        print("success");
        print(lattitude);
        print(longitude);
        fetchWeather(lattitude.toString(), longitude.toString());
        print(jsonResponse);
      } else {
        jsonResponse = "faliedd";
        print('Request failed with status: ${response.statusCode}.');
      }
    }).catchError((error) {
      print('Hiii: $error');
    });
  }

  Future<void> fetchWeather(lat, lon) async {
    String apiUrl =
        "http://api.openweathermap.org/data/2.5/forecast?lat=$lat&lon=$lon&appid=$apiKey";

    await http.get(Uri.parse(apiUrl)).then((response) {
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        var temperature = jsonResponse['list'][0]['main']['temp'];
        var mood = jsonResponse['list'][0]['weather'][0]['description'];
        var city = jsonResponse['city']['name'];

        print("second success");
        print(temperature);
        print(mood);
        print(city);
        print(jsonResponse);
        setState(() {
          resultTemperature = temperature.toString();
          resultMood = mood.toString();
        });
      } else {
        jsonResponse = "falied";
        print('Request failed with status: ${response.statusCode}.');
      }
    }).catchError((error) {
      print('Hellooo: $error');
    });
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: double.infinity,
        margin: EdgeInsets.all(10),
        child: Column(
          children: [
            TextField(
              onSubmitted: (value) async {
                await fetchLatLon(value);
              },
            ),
            ElevatedButton(
                onPressed: _handleLocationPermission,
                child: Text("Get Current Data")),
            Card(
              elevation: 50,
              shadowColor: Colors.black,
              color: const Color.fromARGB(125, 141, 214, 245),
              child: Container(
                width: 300,
                height: 500,
                padding: EdgeInsets.all(50),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      // padding:EdgeInsets.only(bottom: 20)
                      color: Colors.transparent,
                      child: const CircleAvatar(
                        backgroundColor: Colors.transparent,
                        backgroundImage: NetworkImage(
                            "https://cdn.dribbble.com/users/2081/screenshots/6024594/snowflake_weather_app_icon.png"), //NetworkImage
                        radius: 100,
                      ),
                    ), //CircleAvatar
                    //SizedBox
                    Container(
                      width: double.infinity,
                      child: Text(
                        '$resultCity Weather',
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          fontSize: 30,
                          color: const Color.fromARGB(255, 0, 0, 0),
                          fontWeight: FontWeight.w500,
                        ), //Textstyle
                      ),
                    ), //Text
                    const SizedBox(
                      height: 10,
                    ), //SizedBox
                    Text(
                      "Temperature : $resultTemperature \n Mood : $resultMood",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                      ), //Textstyle
                    ), //Text
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ), //Padding
              ), //SizedBox
            ),
            // Text("jsonResponse"),
            // ElevatedButton(onPressed: fetchLatLon, child: Text("Get Data"))
          ],
        ),
      ),
    );
  }
}
