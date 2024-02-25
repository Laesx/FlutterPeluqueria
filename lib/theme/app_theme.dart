import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color.fromARGB(255, 75, 16, 175);
  static const Color secondaryColor = Color.fromARGB(255, 145, 84, 251);
  static const Color buttonColor = Colors.purple;
  static const Color textColor = Colors.white;

  static final ThemeData darkTheme = ThemeData.dark().copyWith(
    appBarTheme: const AppBarTheme(color: primaryColor, elevation: 0),
    listTileTheme: ListTileThemeData(
      tileColor: Colors.grey[900],
      selectedTileColor: Colors.grey[800],
      selectedColor: Colors.white,
      iconColor: Colors.white,
      textColor: Colors.white,
      contentPadding: EdgeInsets.symmetric(horizontal: 20),
    ),
    inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(
          borderSide: BorderSide(color: primaryColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: secondaryColor),
        ),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: secondaryColor),
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(20),
                bottomLeft: Radius.circular(20))),
        floatingLabelStyle: TextStyle(color: Colors.white),
        iconColor: secondaryColor,
        suffixIconColor: secondaryColor),
  );
}
