import 'package:accomod8/utility/dialog/generic_dialog.dart';
import 'package:flutter/material.dart';

Future<bool> showDeleteUserDialog(BuildContext context) {
  return showGenericDialog<bool>(
    context: context,
    title: 'Delete',
    content: 'Are you sure you want to delete your account?',
    optionBuilder: () => {
      'Cancel': false,
      'Delete': true,
    },
  ).then(
    (value) => value ?? false,
  );
}
