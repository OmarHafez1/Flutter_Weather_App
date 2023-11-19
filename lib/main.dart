import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/Constants.dart';
import 'package:weather_app/location.dart';
import 'package:weather_app/reusable_widgets/AdditionalInformation.dart';
import 'package:weather_app/reusable_widgets/MainCard.dart';
import 'package:weather_app/reusable_widgets/SmallCard.dart';

Location location = Location();
void main() {
  runApp(const WeatherApp());
}

const String OPENWEATHER_API_KEY = "c6f22dc15af77877269bfecd0c7be24f";
Position? _position;
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
  _position = await location.getLocation();
  _weatherData =
      await getWeatherData(_position!.latitude!, _position!.longitude!);
  _foreCastData =
      await getForecastData(_position!.latitude!, _position!.longitude!);
  return (_weatherData, _foreCastData);
}

int convertKelvinToCelsius(num kelvin) {
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
        if (snapshot.connectionState != ConnectionState.done ||
            _position == null ||
            snapshot.data == null) {
          return const Scaffold(
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
                  padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                  child: IconButton(
                    onPressed: () {
                      setState(() {});
                    },
                    icon: const Icon(
                      Icons.refresh,
                    ),
                  ),
                )
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(13),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      weatherData["name"],
                      style: KTitleTextStyle,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 8,
                      ),
                      child: MainCard(
                        degree:
                            convertKelvinToCelsius(weatherData['main']['temp'])
                                .toString(),
                        status: weatherData['weather'][0]['main'],
                        iconCode: weatherData['weather'][0]['icon'],
                      ),
                    ),
                    const SizedBox(
                      height: 17,
                    ),
                    Text(
                      "Weather Forecast",
                      style: KTitleTextStyle,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 8,
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
                    const SizedBox(
                      height: 17,
                    ),
                    Text(
                      "Additional Information",
                      style: KTitleTextStyle,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 8,
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
