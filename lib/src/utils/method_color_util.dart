import 'package:flutter/material.dart';

class MethodColorUtil {
  static Color getMethodColor(String method) {
    switch (method) {
      case 'GET':
        return Colors.green;
      case 'POST':
        return Colors.orange;
      case 'PUT':
        return Colors.pink;
      case 'DELETE':
        return Colors.red;
      default:
        return Colors.blue;
    }
  }
}