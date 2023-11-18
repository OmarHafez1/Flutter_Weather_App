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
          vertical: 11,
          horizontal: 30,
        ),
        child: Column(
          children: [
            const Text(
              "09:00",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            Image.network(
              scale: 2,
              'https://openweathermap.org/img/wn/03d@2x.png',
            ),
            const Text(
              "301.17",
            ),
          ],
        ),
      ),
    );
  }
}
