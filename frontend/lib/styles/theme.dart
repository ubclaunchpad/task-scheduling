import 'package:flutter/material.dart';

/**
 * Main area to modify styles for widgets
 * NOTE: It's a work in progress - Subject to change
 * 
 */

ThemeData themeDataDark = ThemeData(colorScheme: scheme);

ColorScheme scheme = const ColorScheme(
    brightness: Brightness.light,
    primary: Color.fromARGB(255, 200, 202, 236),
    onPrimary: Color.fromARGB(255, 15, 16, 20),
    secondary: Color.fromARGB(255, 255, 234, 167),
    onSecondary: Colors.blue,
    error: Colors.red,
    onError: Colors.red,
    background: Colors.blue,
    onBackground: Colors.blue,
    surface: Colors.blue,
    onSurface: Colors.blue);

ButtonStyle primaryButtonStyle = ButtonStyle(
  enableFeedback: true,
  padding:
      MaterialStateProperty.all(const EdgeInsets.only(top: 10, bottom: 10)),
  maximumSize: MaterialStateProperty.all(const Size(150, 100)),
  minimumSize: MaterialStateProperty.all(const Size(150, 40)),
  elevation: MaterialStateProperty.all<double?>(3),
  backgroundColor: MaterialStateProperty.all(scheme.primary),
  overlayColor: MaterialStateProperty.all(scheme.onPrimary),
  side: MaterialStateProperty.all(
    const BorderSide(
      color: Colors.black,
      width: 1,
    ),
  ),
  shape:
      MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12.0),
  )),
);
