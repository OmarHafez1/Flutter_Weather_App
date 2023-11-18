import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'package:weather_app/Constants.dart';
import 'package:weather_app/reusable_widgets/AdditionalInformation.dart';
import 'package:weather_app/reusable_widgets/MainCard.dart';
import 'package:weather_app/reusable_widgets/SmallCard.dart';

void main() {
  runApp(const WeatherApp());
}

const String OPENWEATHER_API_KEY = "c6f22dc15af77877269bfecd0c7be24f";
LocationData? _locationData;
http.Response? _weatherData, _foreCastData;

//https://api.openweathermap.org/data/2.5/forecast?lat=70&lon=70&appid=$OPENWEATHER_API_KEY
//https://api.openweathermap.org/data/2.5/weather?lat=70&lon=70&appid=$OPENWEATHER_API_KEY
class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(
        //colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

Future<LocationData> getLocation() async {
  Location location = new Location();

  PermissionStatus _permissionGranted;
  LocationData _locationData;

  bool _serviceEnabled = await location.serviceEnabled();
  if (!_serviceEnabled) {
    _serviceEnabled = await location.requestService();
    if (!_serviceEnabled) {
      throw Exception("location service is not enable");
    }
  }

  _permissionGranted = await location.hasPermission();
  if (_permissionGranted == PermissionStatus.denied) {
    _permissionGranted = await location.requestPermission();
    if (_permissionGranted != PermissionStatus.granted) {
      throw Exception("location permission is not granted");
    }
  }
  return location.getLocation();
}

Future<http.Response> getWeatherData(double lat, double lon) {
  return http.get(
    Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$OPENWEATHER_API_KEY'),
  );
}

Future<http.Response> getForecastData(double lat, double lon) {
  return http.get(
    Uri.parse(
        'https://api.openweathermap.org/data/2.5/forecast?lat=$lat&lon=$lon&appid=$OPENWEATHER_API_KEY'),
  );
}

Future<(http.Response? weatherData, http.Response? forecastData)>
    fetchWeatherAndForecastData() async {
  _locationData = await getLocation();
  _weatherData =
      await getWeatherData(_locationData!.latitude!, _locationData!.longitude!);
  _foreCastData = await getForecastData(
      _locationData!.latitude!, _locationData!.longitude!);
  return (_weatherData, _foreCastData);
}

int convertKelvinToCelsius(double kelvin) {
  return (kelvin - 273.15).round();
}

String convertDateTimetoTime(String dt) {
  return dt.split(' ')[1].substring(0, 5);
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchWeatherAndForecastData(),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          final weatherData =
              json.decode((snapshot.data!.$1 as http.Response).body);
          final forecastData =
              json.decode((snapshot.data!.$2 as http.Response).body);
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text(
                "Weather App",
                style: KTitleTextStyle,
              ),
              actions: [
                Padding(
                  padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                  child: IconButton(
                    onPressed: () async {
                      try {
                        for (var x in forecastData['list']) {
                          print(x['dt_txt']);
                        }
                      } catch (e) {
                        print(e);
                      }
                    },
                    icon: Icon(
                      Icons.refresh,
                    ),
                  ),
                )
              ],
            ),
            body: Padding(
              padding: EdgeInsets.all(13),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      weatherData["name"],
                      style: KTitleTextStyle,
                    ),
                    MainCard(
                      degree:
                          convertKelvinToCelsius(weatherData['main']['temp'])
                              .toString(),
                      status: weatherData['weather'][0]['main'],
                      iconCode: weatherData['weather'][0]['icon'],
                    ),
                    SizedBox(
                      height: 17,
                    ),
                    Text(
                      "Weather Forecast",
                      style: KTitleTextStyle,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: 11,
                      ),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            for (var val in forecastData['list'])
                              SmallCard(
                                time: convertDateTimetoTime(val['dt_txt']),
                                iconCode: val['weather'][0]["icon"],
                                degree:
                                    convertKelvinToCelsius(val['main']["temp"])
                                        .toString(),
                              ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 17,
                    ),
                    Text(
                      "Additional Information",
                      style: KTitleTextStyle,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: 11,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          AdditionalInformation(
                            iconData: Icons.water_drop,
                            title: "Humidity",
                            degree: weatherData['main']['humidity'].toString(),
                          ),
                          AdditionalInformation(
                            iconData: Icons.air,
                            title: "Wind SPeed",
                            degree: weatherData['wind']['speed'].toString(),
                          ),
                          AdditionalInformation(
                            iconData: Icons.beach_access,
                            title: "Pressure",
                            degree: weatherData['main']['pressure'].toString(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
