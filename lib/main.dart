import 'package:flutter/material.dart';
import 'package:weather_app/Constants.dart';
import 'package:weather_app/reusable_widgets/AdditionalInformation.dart';
import 'package:weather_app/reusable_widgets/MainCard.dart';
import 'package:weather_app/reusable_widgets/SmallCard.dart';

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
        centerTitle: true,
        title: Text(
          "Weather App",
          style: KTitleTextStyle,
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
              height: 17,
            ),
            Text(
              "Weather Forecast",
              style: KTitleTextStyle,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: 11,
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
            SizedBox(
              height: 17,
            ),
            Text(
              "Additional Information",
              style: KTitleTextStyle,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: 11,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                children: [
                  AdditionalInformation(
                    iconData: Icons.water_drop,
                    title: "Humidity",
                    degree: "90",
                  ),
                  AdditionalInformation(
                    iconData: Icons.air,
                    title: "Wind SPeed",
                    degree: "7.67",
                  ),
                  AdditionalInformation(
                    iconData: Icons.beach_access,
                    title: "Pressure",
                    degree: "1006",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
