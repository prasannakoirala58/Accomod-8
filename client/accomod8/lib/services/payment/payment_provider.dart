import 'package:flutter/material.dart';

abstract class PaymentProvider<T> {
  Future<void> initialize();

  Future<void> performPayment({
    required BuildContext context,
    required int amount,
    required String productId,
    required String productName,
    // required String paymentConfig,
    required ValueChanged<T> onSuccess,
    required ValueChanged<T> onFailure,
  });
}
