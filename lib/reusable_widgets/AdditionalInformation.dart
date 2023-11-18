import 'package:flutter/material.dart';

class AdditionalInformation extends StatelessWidget {
  IconData iconData;
  String title, degree;
  AdditionalInformation({
    required this.iconData,
    required this.title,
    required this.degree,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          size: 40,
          iconData,
        ),
        const SizedBox(
          height: 4,
        ),
        Text(
          title,
          style: const TextStyle(
            fontSize: 15,
          ),
        ),
        const SizedBox(
          height: 3,
        ),
        Text(
          degree,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
