import 'package:flutter/material.dart';

Container basicContainer({color = Colors.transparent, Widget? child}) {
  return Container(
    height: 100,
    width: 100,
    color: color,
    child: Center(child: child),
  );
}

Color stringToColor(String str) {
  int hash = str.hashCode;
  return Color.fromARGB(
      255, (hash & 0xFF0000) >> 16, (hash & 0x00FF00) >> 8, hash & 0x0000FF);
}
