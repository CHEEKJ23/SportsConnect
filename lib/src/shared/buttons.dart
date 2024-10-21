import 'package:flutter/material.dart';
import './colors.dart';

TextButton froyoTextBtn(String text, VoidCallback onPressed) {
  return TextButton(
    onPressed: onPressed,
    style: TextButton.styleFrom(
      foregroundColor: Colors.white,
      backgroundColor: primaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),
    child: Text(text),
  );
}

OutlinedButton froyoOutlinedBtn(String text, VoidCallback onPressed) {
  return OutlinedButton(
    onPressed: onPressed,
    style: OutlinedButton.styleFrom(
      side: const BorderSide(color: primaryColor),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      foregroundColor: primaryColor,
    ),
    child: Text(text),
  );
}
