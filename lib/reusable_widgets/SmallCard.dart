import 'package:flutter/material.dart';

class SmallCard extends StatelessWidget {
  String time, iconCode, degree;
  SmallCard({
    required this.time,
    required this.iconCode,
    required this.degree,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 7,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 30,
        ),
        child: Column(
          children: [
            Text(
              time,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            Image.network(
              scale: 1.9,
              'https://openweathermap.org/img/wn/$iconCode@2x.png',
            ),
            Text(
              "$degree°C",
              style: const TextStyle(
                fontSize: 17,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
