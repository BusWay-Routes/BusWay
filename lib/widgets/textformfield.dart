// custom_text_field.dart

import 'package:bus_finder/providers/snackbarprovider.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;
  final SnackBarProvider snackBarProvider;

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    this.validator,
    this.onSaved,
    required this.snackBarProvider,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          snackBarProvider.showSnackBar('Please enter a valid location');
          return null;
        }
        return null;
      },
      onSaved: onSaved,
    );
  }
}
