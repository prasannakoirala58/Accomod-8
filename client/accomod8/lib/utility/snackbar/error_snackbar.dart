import 'package:accomod8/utility/snackbar/generic_snackbar.dart';
import 'package:flutter/material.dart';

class ErrorSnackBar {
  final String message;

  const ErrorSnackBar({required this.message});

  static showErrorSnackBar(
    BuildContext context,
    String message,
  ) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: GenericSnackBarWidget(
          message: message,
          title: 'An error occured!',
          barColor: const Color(0xFFC72C45),
          symbolColor: const Color(0xFF801336),
          symbol: 'client/assets/snackbar_icons/close.svg',
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
    );
  }
}
