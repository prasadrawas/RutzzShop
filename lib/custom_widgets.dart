import 'package:flutter/material.dart';

getText(String title, Color color, double size, FontWeight fontWeight) {
  return Padding(
    padding: const EdgeInsets.only(top: 4, bottom: 4),
    child: Text(
      title,
      style: TextStyle(
        color: color,
        fontSize: size,
        fontWeight: fontWeight,
      ),
    ),
  );
}

getNoPaddingText(
    String title, Color color, double size, FontWeight fontWeight) {
  return Text(
    title,
    style: TextStyle(
      color: color,
      fontSize: size,
      fontWeight: fontWeight,
    ),
  );
}
