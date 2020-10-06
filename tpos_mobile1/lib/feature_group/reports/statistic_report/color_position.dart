import 'package:flutter/material.dart';

Color getColor(int position) {
  if (position == 1) {
    return const Color(0xFF28A745);
  } else if (position == 2) {
    return const Color(0xFF7AC461);
  } else if (position == 3) {
    return const Color(0xFFB7E094);
  } else {
    return const Color(0xFFEBEDEF);
  }
}
