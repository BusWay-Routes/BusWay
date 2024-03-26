import 'package:flutter/material.dart';

class SnackBarProvider extends ChangeNotifier {
  BuildContext? _context;

  void setContext(BuildContext context) {
    _context = context;
  }

  void showSnackBar(String message) {
    if (_context == null) return;

    ScaffoldMessenger.of(_context!).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        elevation: 0,
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
