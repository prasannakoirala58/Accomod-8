import 'package:flutter/material.dart';

import 'generic_dialog.dart';

Future<bool?> showFeatureHostelDialog(
  BuildContext context,
  bool isFeatured,
) {
  final String title = isFeatured ? 'Unfeature?' : 'Feature?';
  final String message = isFeatured
      ? 'Are you sure you want to unfeature'
      : 'Are you sure you want to feature';

  return showGenericDialog<bool>(
    context: context,
    title: title,
    content: message,
    optionBuilder: () {
      return {
        'No': false,
        'Yes': true,
      };
    },
  );
}
