import 'package:accomod8/utility/snackbar/generic_snackbar.dart';
import 'package:flutter/material.dart';

class SuccessSnackBar {
  final String message;

  const SuccessSnackBar({required this.message});

  static showErrorSnackBar(
    BuildContext context,
    String message,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: GenericSnackBarWidget(
          message: message,
          title: 'Success!',
          barColor: const Color(0xFF689F38),
          symbolColor: const Color(0xFF33691E),
          symbol: 'client/assets/snackbar_icons/check.svg',
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
    );
  }
}
