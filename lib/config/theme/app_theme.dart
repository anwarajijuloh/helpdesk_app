import 'package:flutter/material.dart';

import '../constants.dart';

ThemeData myTheme = ThemeData(
  fontFamily: 'Inter',
  colorSchemeSeed: greenPrimary,
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(6),
      borderSide: BorderSide.none,
    ),
    hintStyle: const TextStyle(
      fontSize: 12,
      fontStyle: FontStyle.italic,
      fontWeight: FontWeight.w400,
    ),
    fillColor: greenSecondary,
    filled: true,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
      ),
      visualDensity: VisualDensity.standard,
      minimumSize: const Size(double.infinity, 48),
      backgroundColor: greenPrimary,
      foregroundColor: Colors.white,
    ),
  ),
  dropdownMenuTheme: DropdownMenuThemeData(
    textStyle: const TextStyle(fontSize: 12),
    menuStyle: const MenuStyle(

    ),
    inputDecorationTheme: InputDecorationTheme(
      prefixIconColor: greenPrimary,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: BorderSide.none,
      ),
      hintStyle: const TextStyle(
        fontSize: 12,
        fontStyle: FontStyle.italic,
        fontWeight: FontWeight.w400,
      ),
      contentPadding: const EdgeInsets.all(10),
      fillColor: greenSecondary,
      filled: true,
    ),
  ),
);