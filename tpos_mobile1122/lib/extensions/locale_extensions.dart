import 'package:flutter/material.dart';

extension LocaleExtensions on Locale {
  Widget getIcon() {
    switch (languageCode) {
      case 'vi':
        return Container(
          decoration: const BoxDecoration(
              shape: BoxShape.circle, color: Color(0xFFDD647A)),
          width: 30,
          height: 30,
          child: const Center(
            child: Text(
              "VI",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        );
      case 'en':
        return Container(
          decoration: const BoxDecoration(
              shape: BoxShape.circle, color: Color(0xFF2B82D3)),
          width: 30,
          height: 30,
          child: const Center(
              child: Text(
            "EN",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          )),
        );

      default:
        return Container(
          decoration: const BoxDecoration(
              shape: BoxShape.circle, color: Color(0xFF2B82D3)),
          width: 30,
          height: 30,
          child: const Center(
              child: Text(
            "EN",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          )),
        );
    }
  }

  String getText() {
    switch (languageCode) {
      case 'vi':
        return 'Tiếng Việt';
      case 'en':
        return "English";
      default:
        return languageCode;
    }
  }

  String getDescription() {
    switch (languageCode) {
      case 'vi':
        return '';
      case 'en':
        return "This language is currently not fully supported";
      default:
        return languageCode;
    }
  }
}
