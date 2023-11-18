import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:weather_app/MainCard.dart';
import 'package:weather_app/SmallCard.dart';

void main() {
  runApp(const WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  // This widget is the root of your application.
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

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text("Weather App"),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.all(10),
            child: IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.refresh,
              ),
            ),
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(13),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MainCard(
              degree: '30',
              status: "Clear",
              iconCode: "03d",
            ),
            SizedBox(
              height: 18,
            ),
            Text(
              "Weather Forecast",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 27,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: 13,
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    SmallCard(
                      time: "09:00",
                      iconCode: "01d",
                      degree: "23",
                    ),
                    SmallCard(
                      time: "09:00",
                      iconCode: "01d",
                      degree: "23",
                    ),
                    SmallCard(
                      time: "09:00",
                      iconCode: "01d",
                      degree: "23",
                    ),
                    SmallCard(
                      time: "09:00",
                      iconCode: "01d",
                      degree: "23",
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
