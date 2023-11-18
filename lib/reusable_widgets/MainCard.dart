import 'dart:ui';

import 'package:flutter/material.dart';

class MainCard extends StatelessWidget {
  String degree, status, iconCode;
  MainCard({
    required this.degree,
    required this.status,
    required this.iconCode,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 12,
            sigmaY: 12,
          ),
          child: SizedBox(
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "$degree°C",
                  style: const TextStyle(
                    fontSize: 45,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Image.network(
                  scale: .9,
                  'https://openweathermap.org/img/wn/$iconCode@2x.png',
                ),
                Text(
                  status,
                  style: const TextStyle(
                    fontSize: 30,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
