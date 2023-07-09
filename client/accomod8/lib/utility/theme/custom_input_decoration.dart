import 'package:flutter/material.dart';

class CustomInputDecoration {
  static InputDecoration build({
    required String label,
    IconData? prefixIconData,
  }) {
    return InputDecoration(
      label: Text(label),
      border: const OutlineInputBorder(),
      prefixIcon: prefixIconData != null
          ? Icon(
              prefixIconData,
              color: const Color.fromARGB(255, 242, 162, 131),
            )
          : null,
      // const Icon(
      //   Icons.home_work_outlined,
      //   color: Color.fromARGB(255, 242, 162, 131),
      // ),
      labelStyle: const TextStyle(
        color: Color.fromARGB(255, 242, 162, 131),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(
          width: 2.0,
          color: Color.fromARGB(255, 242, 162, 131),
        ),
      ),
    );
  }
}
